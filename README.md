# linter-write-good

Naive linter for English prose for developers who can't write good and wanna
learn to do other stuff good too.

A Linter interface for the [write-good](https://github.com/btford/write-good)
library.

This provides a variety of english usage text tips when writing documentation
and commit messages.

This package requires [Linter](https://github.com/AtomLinter/Linter).

[See it on atom.io](https://atom.io/packages/linter-write-good)

[See it on github.com](https://github.com/gepoch/linter-write-good)

![](https://raw.github.com/gepoch/linter-write-good/master/screenshot.png)

## Configuration

In the package settings, you can use a custom node binary, a custom write-good
script, and pass arguments to the write good command. See
[write-good](https://github.com/btford/write-good) for possible arguments to the
command.

Moreover, you can set the **severity level** of this linter. The default level
is **Error**. Setting the severity level to **Warning** or **Info** helps
distinguish *write-good* highlighting from the highlighting of an ordinary spell
checker, or higher priority linters.

### Note: Additional Linting

#### E-Prime

The Write-Good library implements a linter for
[E-Prime](https://github.com/btford/write-good/issues/70) which is off by
default. To enable E-Prime linting, you'll need to add the `--yes-eprime` flag
to the extra arguments input under this package's settings page.

![](https://raw.github.com/gepoch/linter-write-good/master/flags.png)
