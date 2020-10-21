<div align="center">

# asdf-spago ![Build](https://github.com/nsaunders/asdf-spago/workflows/Build/badge.svg) ![Lint](https://github.com/nsaunders/asdf-spago/workflows/Lint/badge.svg)

[spago](https://github.com/spago/spago) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Dependencies

The only dependencies are `bash`, `curl`, and `tar`.

# Install

Plugin:

```shell
asdf plugin-add spago
# or
asdf plugin-add https://github.com/nsaunders/asdf-spago.git
```

Installation:

```shell
# Show all installable versions.
asdf list-all spago

# Install specific version.
asdf install spago latest

# Set a version globally (on your ~/.tool-versions file).
asdf global spago latest

# Now spago command is available.
spago --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install and manage versions.
