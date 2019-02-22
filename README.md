# spacemacs

## Spacemacs configuration files and private layers

[Spacemacs] is a set of configurations available to power up your
[Emacs], the best text editor in the world. Spacemacs brings a modern
interface, and many smart defaults, so you don't have to struggle to let
your `.emacs` the way you want (although many like the challenge).
Anyway, Spacemacs let you configure it the same old way, but based on
*layers*, which makes things much more organized. By the way, Spacemacs
even let [Vim] users to use keybindings they were used to, but
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

These layers are enabled by moving them to `~/.emacs.d/private` and adding
these lines at `dotspacemacs-configuration-layers` in `.spacemacs`

```
ess
funk
polymode
```

## Miscelaneous

### Using elpy instead of python layer

To use Python in spacemacs, the default choice is to enable the `python`
layer. This layer has by default the `anaconda-mode`, which has some
particularities I personally don't like. An alternative is to use
[elpy], which is a completely different project, and is much more
similar to the ESS layer for R.

To avoid conflicts, Spacemacs doesn't have an `elpy` layer by default.
So, it is necessary to include this layer by yourself. To do this, you
can copy this layer from this
[repository](https://github.com/rgemulla/spacemacs-layers) and place it
under your `~/.emacs.d/private/` directory. After doin that, you can
enable the `elpy` layer in your `~/.spacemacs`.

**Important:** don't enable the `python` layer at the same time as the
`elpy` layer as this may cause some conflicts. The `elpy` layer will be
the only one responsible for handling python files and modes.

### Maxima mode

There is no specific layer to enable the `maxima-mode` in Spacemacs.
Anyway you can just follow the instructions from
[here](https://www.emacswiki.org/emacs/MaximaMode) and include the
appropriate lines in `user-config()` section of your `~/.spacemacs`.

Some details:

- Use `.max` extension
- `M-x maxima-mode` in the file
- `M-x imaxima` to open a Maxima terminal with the output rendered as
  LaTeX
- Basic commands:
  - `C-c C-c`: send a line
  - `C-c *`: open a commentary block
  - `M-;`: comment a line


[polymode]: https://github.com/vspinu/polymode
[R Coding Standards]: https://cran.r-project.org/doc/manuals/R-ints.html#R-coding-standards
[Spacemacs]: http://spacemacs.org/
[Emacs]: https://www.gnu.org/software/emacs/
[Vim]: http://www.vim.org/
[elpy]: https://github.com/jorgenschaefer/elpy
