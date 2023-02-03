<div align="center">

# asdf-kubecm [![Build](https://github.com/samhvw8/asdf-kubecm/actions/workflows/build.yml/badge.svg)](https://github.com/samhvw8/asdf-kubecm/actions/workflows/build.yml) [![Lint](https://github.com/samhvw8/asdf-kubecm/actions/workflows/lint.yml/badge.svg)](https://github.com/samhvw8/asdf-kubecm/actions/workflows/lint.yml)


[kubecm](https://kubecm.cloud/en-us/README) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add kubecm
# or
asdf plugin add kubecm https://github.com/samhvw8/asdf-kubecm.git
```

kubecm:

```shell
# Show all installable versions
asdf list-all kubecm

# Install specific version
asdf install kubecm latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubecm latest

# Now kubecm commands are available
kubecm version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/samhvw8/asdf-kubecm/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Sam Hoang](https://github.com/samhvw8/)
