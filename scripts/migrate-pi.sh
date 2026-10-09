#!/bin/sh
# ABOUTME: One-off move of pi's agent dir from ~/.pi/agent to ~/.config/pi/agent,
# ABOUTME: then links the pi config tracked in common (settings, theme, extension)
#
# Close every pi session first: pi runs from its agent dir, so moving it under a
# running pi breaks that session. Safe to run again; on a machine that already
# uses ~/.config/pi/agent (macOS) it only links the tracked files. Stow common
# first (or let it, below) so ~/.zshenv exports PI_CODING_AGENT_DIR: pi only
# looks in ~/.config/pi/agent when that variable is set.
#
# Usage: scripts/migrate-pi.sh

set -eu

repo=$(cd "$(dirname "$0")/.." && pwd -P)
old="$HOME/.pi/agent"
new="$HOME/.config/pi/agent"

if [ -n "${PI_CODING_AGENT:-}" ] || pgrep -u "$(id -u)" -f '^pi( |$)' >/dev/null 2>&1; then
    echo "Close every pi session and run this from a shell outside pi." >&2
    exit 1
fi

if [ -L "$HOME/.config" ] || [ -L "$HOME/.config/pi" ] || [ -L "$new" ]; then
    echo "$HOME/.config/pi is linked into the repo (stow folded it); see" >&2
    echo "'pi coding agent' in README.md before running this." >&2
    exit 1
fi

# 1. Move the whole agent dir: pi's install, sessions, credentials and config
if [ -d "$old" ] && [ ! -L "$old" ]; then
    if [ -e "$new" ]; then
        # Only links from an earlier stow of common may be there already
        if [ -n "$(find "$new" ! -type d ! -lname '*/common/.config/pi/agent/*' | head -n 1)" ]; then
            echo "Both $old and $new have files; merge them by hand." >&2
            exit 1
        fi
        find "$new" -type l -delete
        find "$new" -depth -type d -empty -delete
        if [ -e "$new" ]; then
            echo "Could not clear $new; check it by hand." >&2
            exit 1
        fi
    fi
    mkdir -p "$(dirname "$new")"
    mv "$old" "$new"
    echo "Moved $old to $new"
fi
# Earlier versions of this script left ~/.pi/agent as a link to the new dir
if [ -L "$old" ]; then
    rm "$old"
    rmdir "$HOME/.pi" 2>/dev/null || true
    echo "Removed the $old link"
fi

# 2. Point the installer's launcher link at the new location
link="$HOME/.local/bin/pi"
case $(readlink "$link" 2>/dev/null || true) in
    */.pi/agent/bin/pi)
        ln -sf ../../.config/pi/agent/bin/pi "$link"
        echo "Re-pointed $link"
        ;;
esac

# 3. Hand the tracked files over to stow. A copy identical to the repo's is
#    removed; one that differs replaces the repo's working copy (like
#    stow --adopt), so git diff shows what this machine had.
cd "$repo"
differs=
for f in $(git ls-files common/.config/pi/agent); do
    target="$HOME/${f#common/}"
    [ -f "$target" ] && [ ! -L "$target" ] || continue
    # Under a dir stow already linked, the "target" is the repo's own file
    case $(cd "$(dirname "$target")" && pwd -P)/ in
        "$repo"/*) continue ;;
    esac
    cmp -s "$target" "$f" || { cp "$target" "$f"; differs=1; }
    rm "$target"
done
# Emptied extension dirs go, so stow links each extension as a whole directory
for d in "$new"/extensions/*/; do
    [ -d "$d" ] && [ ! -L "${d%/}" ] && rmdir "$d" 2>/dev/null || true
done

# A real directory, so stow links inside it instead of folding ~/.config/pi
mkdir -p "$new"
if ! stow -R -t "$HOME" common; then
    echo "stow failed (see above). Fix that and run this again; it picks up" >&2
    echo "where it stopped." >&2
    exit 1
fi
echo "Linked common's pi config into $new"

if [ -n "$differs" ]; then
    echo "This machine's copies differed from the repo; review: git -C \"$repo\" diff"
fi
if [ "${PI_CODING_AGENT_DIR:-}" != "$new" ]; then
    echo "PI_CODING_AGENT_DIR is not set in this shell. Only start pi from a shell"
    echo "that has it (new ones get it from ~/.zshenv), or it recreates $old."
fi
