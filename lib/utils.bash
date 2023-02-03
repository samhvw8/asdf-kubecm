#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for kubecm.
GH_REPO="https://github.com/sunny0826/kubecm"
TOOL_NAME="kubecm"
TOOL_TEST="kubecm version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kubecm is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if kubecm has other means of determining installable versions.
  list_github_tags
}

function get_platform() {
  local platform arch

  platform="$(uname -s)"
  arch="$(uname -m)"

  case "${platform}" in
  "Linux") platform_dl="Linux" ;;
  "*BSD") platform_dl="Linux" ;;
  "Darwin") platform_dl="Darwin" ;;
  esac
  case "${arch}" in
  "x86_64" | "amd64") arch_dl="x86_64" ;;
  "arm64" | "aarch64") arch_dl="arm64" ;;
  "arm" | "armv7") arch_dl="arm" ;;
  "i386") arch_dl="i386" ;;
  esac

  echo "${platform_dl}_${arch_dl}"
}

function download_release() {
  local version download_path url platform release_tar

  version="${1}"
  download_path="${2}"
  platform="$(get_platform)"
  release_tar="${TOOL_NAME}_v${version}_${platform}.tar.gz"

  url="${GH_REPO}/releases/download/v${version}/${release_tar}"

  mkdir -p "${download_path}"

  echo "* Platform: ${platform}"
  echo "* Downloading ${TOOL_NAME} release ${version}..."
  echo "* Download url ${url}"
  if ! curl "${curl_opts[@]}" -o "${download_path}/${release_tar}" -C - "${url}"; then
    fail "Could not download ${url}"
  fi
}

function extract_release() {
  local version download_path platform release_tar

  version="${1}"
  download_path="${2}"
  platform="$(get_platform)"
  release_tar="${TOOL_NAME}_v${version}_${platform}.tar.gz"

  url="${GH_REPO}/releases/download/v${version}/${release_tar}"

  echo "* Extracting ${release_tar}..."
  if ! tar -xzf "${download_path}/${release_tar}" -C "${download_path}" ${TOOL_NAME}; then
    fail "Could not extract ${release_tar}"
  fi
  rm "${download_path}/${release_tar}"
}

function install_version() {
  local install_type version install_path download_path tool_cmd

  install_type="${1}"
  version="${2}"
  install_path="${3%/bin}/bin"
  download_path="${4}"

  if [ "${install_type}" != "version" ]; then
    fail "asdf-${TOOL_NAME} supports release installs only"
  fi

  if ! (
    mkdir -p "${install_path}"

    mv "${download_path}/${TOOL_NAME}" "${install_path}"

    tool_cmd="$(echo "${TOOL_TEST}" | cut -d' ' -f1)"
    if [[ ! -x "${install_path}/${tool_cmd}" ]]; then
      fail "Expected ${install_path}/${tool_cmd} to be executable."
    fi
    if ! "${install_path}/${TOOL_NAME}" version; then
      fail "'${tool_cmd} version' failed."
    fi

    echo "${TOOL_NAME} ${version} installation was successful!"
  ); then
    rm -rf "${install_path}"
    fail "An error occurred while installing ${TOOL_NAME} ${version}."
  fi
}
