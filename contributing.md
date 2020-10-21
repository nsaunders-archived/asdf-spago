# Contributing

Testing Locally:

```shell
asdf plugin-test spago https://github.com/nsaunders/spago [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin-test spago https://github.com/nsaunders/asdf-spago.git "spago --help"
```

Tests are automatically run in GitHub Actions on push and PR.
