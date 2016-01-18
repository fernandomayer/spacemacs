# spacemacs

## Spacemacs configuration files and private layers

This repository contains my `.spacemacs` file (named `spacemacs.el`) and
some private layers.

Layers are in the `private` directory, and now they are:

- `ess`: This is a clone of the original Spacemacs ess layer
  (available at `layers/+lang/ess`), but it includes the following
  modifications:
  - Use [R Coding Standards] instead of Hadley's coding standards (the
    default in the official layer)
- `polymode`: Creates a layer to install and configure [polymode],
  adding support for editing R markdown (`Rmd`) files in Spacemacs.
  (Note that ess already support for `Rnw` files, and this is enables by
  default in Spacemacs).
- `funk`: This is a layer to hold my personal (misc) functions. It
  doesn't install any packages, just enable functions in `funcs.el`

These layers are enabled by moving them to `~/emacs.d/private` and adding
these lines at `dotspacemacs-configuration-layers` in `.spacemacs`

```
ess
funk
polymode
```

Many things in this repository are shared with @walmes
<https://github.com/walmes/spacemacs>, where you can find more advanced settings.

[polymode]: https://github.com/vspinu/polymode
[R Coding Standards]: https://cran.r-project.org/doc/manuals/R-ints.html#R-coding-standards
