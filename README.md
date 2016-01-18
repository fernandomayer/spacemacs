# spacemacs

Spacemacs configuration files and private layers

This repository contains my `.spacemacs` file (named `spacemacs.el`) and
some private layers.

Layers are in the `private` directory, and now they are:

- [private/ess]: This is a clone of the original Spacemacs ess layer
  (available at `layers/+lang/ess`), but it includes the following
  modifications:
  - Add [polymode] to the list of packages to be installed from ELPA,
    and configure it to load with `Rmd` files.
  - Use [R Coding Standards] instead of Hadley's coding standards (the
    default in the official layer)



[polymode]: https://github.com/vspinu/polymode
