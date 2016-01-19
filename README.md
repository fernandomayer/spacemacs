# spacemacs

## Spacemacs configuration files and private layers

[Spacemacs] is a set of configurations available to power up your
[Emacs], the best text editor in the world. Spacemacs brings a modern
interface, and many smart defaults, so you don't have to struggle to let
your `.emacs` the way you want (although many like the challenge).
Anyway, Spacemacs let you configure it the same old way, but based on
*layers*, which makes things much more organized. By the way, Spacemacs
even let [Vim] users to use their keybindings they were used to, but
with the power of Emacs.

This repository contains my `.spacemacs` file (named `spacemacs.el`) and
some private layers.

Layers are in the `private` directory, and now they are:

- `ess`: This is a clone of the original Spacemacs ess layer
  (available at `layers/+lang/ess`), but it includes the following
  modifications:
  - Use [R Coding Standards] instead of Hadley's coding standards (the
    default in the official layer)
  - Create a new variable, `ess-enable-smartparens`, to allow
    `smartparens` package to be used in ess. It can be specified in your
    `.spacemacs` the same way as `ess-enable-smart-equals` (both are
    disabled by default)
- `polymode`: Creates a layer to install and configure [polymode],
  adding support for R markdown (`Rmd`) files in Spacemacs.
  (Note that ess already supports `Rnw` files, and this is enabled by
  default in Spacemacs).
- `funk`: This is a layer to hold my personal (misc) functions and
  keybindings. It doesn't install any packages, just enable functions in
  `funcs.el`, and enables some keybindings setted in `keybindings.el`

These layers are enabled by moving them to `~/emacs.d/private` and adding
these lines at `dotspacemacs-configuration-layers` in `.spacemacs`

```
ess
funk
polymode
```

Many things in this repository are shared with @walmes in
<https://github.com/walmes/spacemacs>, where you can find much more
advanced settings.

[polymode]: https://github.com/vspinu/polymode
[R Coding Standards]: https://cran.r-project.org/doc/manuals/R-ints.html#R-coding-standards
[Spacemacs]: http://spacemacs.org/
[Emacs]: http://emacs.org/
[Vim]: http://www.vim.org/
