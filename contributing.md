# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test kubecm https://github.com/samhvw8/asdf-kubecm.git "kubecm version"
```

Tests are automatically run in GitHub Actions on push and PR.
