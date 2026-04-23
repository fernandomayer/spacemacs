#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Copying private/ to ~/.emacs.d/private/ ..."
cp -r "$REPO_DIR/private/"* ~/.emacs.d/private/

echo "Backing up ~/.spacemacs to ~/.spacemacs.bk ..."
cp ~/.spacemacs ~/.spacemacs.bk

echo "Copying spacemacs.el to ~/.spacemacs ..."
cp "$REPO_DIR/spacemacs.el" ~/.spacemacs

echo "Done."
