#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Deploy the built docs site to the gh-pages branch.

Usage:
  bash scripts/deploy-gh-pages.sh [--dry-run] [-m "Deploy message"]

Options:
  --dry-run            Build and prepare the publish worktree, but do not commit or push
  -m, --message TEXT   Commit message for the gh-pages deployment
  -h, --help           Show this help message

Notes:
  - Run this from anywhere inside the smart-docs repo.
  - Your tracked working tree must be clean before deploying.
  - This script publishes only the built site. Commit/push your source branch separately.
EOF
}

log() {
  printf '[deploy-gh-pages] %s\n' "$*"
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$ROOT" ]]; then
  ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
fi
if [[ -z "$ROOT" ]]; then
  echo "Not inside a git repository, and could not locate one from the script path." >&2
  exit 1
fi

cd "$ROOT"

DRY_RUN=0
COMMIT_MESSAGE="Deploy docs"
REMOTE="${REMOTE:-origin}"
PUBLISH_BRANCH="${PUBLISH_BRANCH:-gh-pages}"
BUILD_DIR="$ROOT/docs/build/html"
TEMP_BUILD=""
PUBLISH_DIR=""
WORKTREE_ACTIVE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -m|--message)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      COMMIT_MESSAGE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo >&2
      usage >&2
      exit 1
      ;;
  esac
done

cleanup() {
  set +e
  if [[ "$WORKTREE_ACTIVE" -eq 1 && -n "$PUBLISH_DIR" ]]; then
    git worktree remove --force "$PUBLISH_DIR" >/dev/null 2>&1 || rm -rf "$PUBLISH_DIR"
  elif [[ -n "$PUBLISH_DIR" ]]; then
    rm -rf "$PUBLISH_DIR"
  fi

  if [[ -n "$TEMP_BUILD" ]]; then
    rm -rf "$TEMP_BUILD"
  fi
}

trap cleanup EXIT

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Tracked changes are not committed. Commit or stash them first." >&2
  exit 1
fi

if ! command -v make >/dev/null 2>&1; then
  echo "'make' is required but was not found." >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "'rsync' is required but was not found." >&2
  exit 1
fi

if ! git show-ref --verify --quiet "refs/heads/$PUBLISH_BRANCH"; then
  echo "Local branch '$PUBLISH_BRANCH' does not exist." >&2
  exit 1
fi

log "Building docs"
make -C docs html

if [[ ! -d "$BUILD_DIR" ]]; then
  echo "Build directory not found: $BUILD_DIR" >&2
  exit 1
fi

TEMP_BUILD="$(mktemp -d "${TMPDIR:-/tmp}/smart-docs-build.XXXXXX")"
PUBLISH_DIR="$(mktemp -d "${TMPDIR:-/tmp}/smart-docs-pages.XXXXXX")"

log "Preparing temporary publish workspace"
rsync -a --delete "$BUILD_DIR"/ "$TEMP_BUILD"/
touch "$TEMP_BUILD/.nojekyll"

git worktree prune
git worktree add --detach "$PUBLISH_DIR" "$PUBLISH_BRANCH" >/dev/null
WORKTREE_ACTIVE=1

log "Updating $PUBLISH_BRANCH contents"
find "$PUBLISH_DIR" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
rsync -a --delete --exclude .git "$TEMP_BUILD"/ "$PUBLISH_DIR"/

git -C "$PUBLISH_DIR" add -A

if git -C "$PUBLISH_DIR" diff --cached --quiet; then
  log "No site changes to deploy"
  exit 0
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  log "Dry run complete. Changes were prepared but not committed or pushed."
  exit 0
fi

log "Committing deployment"
git -C "$PUBLISH_DIR" commit -m "$COMMIT_MESSAGE"

log "Pushing to $REMOTE/$PUBLISH_BRANCH"
git -C "$PUBLISH_DIR" push "$REMOTE" "HEAD:$PUBLISH_BRANCH"

log "Done. GitHub Pages should update shortly."
