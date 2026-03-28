#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────
# Point this at your templates directory.
TEMPLATE_DIR="$HOME/.dotfiles/templates"

# ── Argument parsing ─────────────────────────────────────────────
usage() {
  echo "Usage: $(basename "$0") <template> [project-name] [target-dir]"
  echo ""
  echo "  project-name  defaults to current directory name"
  echo "  target-dir    defaults to ./<project-name>"
  echo ""
  echo "Templates:"
  for d in "$TEMPLATE_DIR"/*/; do
    [[ -d "$d" ]] && echo "  $(basename "$d")"
  done
  exit 1
}

[[ $# -lt 1 ]] && usage

TEMPLATE="$1"
TEMPLATE_PATH="$TEMPLATE_DIR/$TEMPLATE"

if [[ ! -d "$TEMPLATE_PATH" ]]; then
  echo "Error: unknown template '$TEMPLATE'" >&2
  usage
fi

# If no project name given, use current dir (for init-in-place)
if [[ $# -ge 2 ]]; then
  PROJECT="$2"
  TARGET="${3:-$(pwd)/$PROJECT}"
else
  TARGET="$(pwd)"
  PROJECT="$(basename "$TARGET")"
fi

# ── Scaffold ─────────────────────────────────────────────────────
mkdir -p "$TARGET"
cd "$TARGET"

echo "→ Initialising '$PROJECT' from template '$TEMPLATE'..."

# Copy template files, skip anything that already exists
skipped=()
copied=()
while IFS= read -r -d '' file; do
  rel="${file#"$TEMPLATE_PATH"/}"
  dest="$TARGET/$rel"

  if [[ -e "$dest" ]]; then
    skipped+=("$rel")
  else
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
    copied+=("$rel")
  fi
done < <(find "$TEMPLATE_PATH" -type f -print0)

if [[ ${#copied[@]} -gt 0 ]]; then
  echo "  copied: ${copied[*]}"
fi
if [[ ${#skipped[@]} -gt 0 ]]; then
  echo "  skipped (already exist): ${skipped[*]}"
fi

# ── direnv ───────────────────────────────────────────────────────
if [[ -f .envrc ]] && command -v direnv &>/dev/null; then
  echo "→ Allowing direnv..."
  direnv allow .
fi

# ── Language-specific init ───────────────────────────────────────
case "$TEMPLATE" in
  rust)
    if [[ ! -f Cargo.toml ]]; then
      echo "→ Initializing rust project"
      direnv exec . cargo init --name "$PROJECT" .
    fi
    ;;
  python)
    direnv exec . uv init
    ;;
esac

echo ""
echo "Done!"
