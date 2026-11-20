#!/usr/bin/env bash

## Liga os layers privados, os snippets e o spacemacs.el deste repositório ao
## ~/.emacs.d e ao ~/.spacemacs, com links simbólicos. Depois disso, um git pull
## basta para atualizar a configuração.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Linking private layers into ~/.emacs.d/private/ ..."
for layer in elpy ess funk polymode; do
    rm -rf ~/.emacs.d/private/"$layer"
    ln -s "$REPO_DIR/private/$layer" ~/.emacs.d/private/"$layer"
done

echo "Linking snippets into ~/.emacs.d/private/snippets/ ..."
rm -rf ~/.emacs.d/private/snippets/markdown-mode
ln -s "$REPO_DIR/private/snippets/markdown-mode" \
    ~/.emacs.d/private/snippets/markdown-mode

if [ -f ~/.spacemacs ] && [ ! -L ~/.spacemacs ]; then
    echo "Backing up ~/.spacemacs to ~/.spacemacs.bk ..."
    cp ~/.spacemacs ~/.spacemacs.bk
fi

echo "Linking spacemacs.el to ~/.spacemacs ..."
ln -sfn "$REPO_DIR/spacemacs.el" ~/.spacemacs

echo "Done."
