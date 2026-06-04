#!/usr/bin/env bash
# setup-collections.sh — Phased, idempotent registration of qmd collections
#
# Usage:  setup-collections.sh {1|2|3|4|all|status|<name>-rm}
#
# Rollout plan (matches the project's phased approach):
#   1: quickshell  (~/Workspace/tmp/quickshell/**)   — first, verify works
#   2: nixos       (~/NixOS/**.nix)                  — second, mostly Nix code
#   3: references  (8 loose *.md in ~/Workspace/tmp) — color/preset/ecosystem maps
#   4: per-subdir  (wayle, wayle-modules, rofi, hyprland, wezterm)
#
# After any change, run:  qmd update && qmd embed
#
# Re-runs are safe. Existing collections are detected and skipped.
# Per-collection add:    setup-collections.sh <name>
# Remove a collection:   setup-collections.sh <name>-rm
#
# breadcrumbs-obsidian/ is intentionally skipped (0 .md files as of 2026-06-03).
#
# Note: the `references` collection overlaps with per-subdir collections in
# content (both index ~/Workspace/tmp/**.md). This is intentional — `references`
# is a global "loose files" bucket, while per-subdir collections let the agent
# scope with `-c quickshell` etc. The agent picks the right scope based on the
# `intent` field, and qmd's rerank deduplicates effectively.

set -euo pipefail

WORKSPACE="${WORKSPACE:-$HOME/Workspace/tmp}"
NIXOS_DIR="${NIXOS_DIR:-$HOME/NixOS}"

get_path() {
  case "$1" in
    quickshell)     echo "$WORKSPACE/quickshell" ;;
    nixos)          echo "$NIXOS_DIR" ;;
    references)     echo "$WORKSPACE" ;;
    wayle)          echo "$WORKSPACE/wayle" ;;
    wayle-modules)  echo "$WORKSPACE/wayle-modules" ;;
    rofi)           echo "$WORKSPACE/rofi" ;;
    hyprland)       echo "$WORKSPACE/hyprland" ;;
    wezterm)        echo "$WORKSPACE/wezterm" ;;
    *) echo "unknown collection: $1" >&2; return 1 ;;
  esac
}

get_pattern() {
  case "$1" in
    nixos) echo "**/*.nix" ;;
    *)     echo "**/*.md" ;;
  esac
}

COLLECTIONS=(quickshell nixos references wayle wayle-modules rofi hyprland wezterm)

exists() {
  qmd collection list 2>/dev/null | grep -qE "(^|[[:space:]])${1}[[:space:]]"
}

add_collection() {
  local name="$1"
  if exists "$name"; then
    echo "  ↪ $name: already exists, skipping"
    return 0
  fi
  local path pattern
  path="$(get_path "$name")"
  pattern="$(get_pattern "$name")"
  if [ ! -d "$path" ]; then
    echo "  ✗ $name: path missing: $path"
    return 1
  fi
  echo "  + $name: adding ($path, $pattern)"
  ( cd "$path" && qmd collection add "$path" "$name" ) | sed 's/^/    /'
}

remove_collection() {
  local name="$1"
  if ! exists "$name"; then
    echo "  ↪ $name: not present, nothing to remove"
    return 0
  fi
  echo "  − $name: removing"
  qmd collection remove "$name" | sed 's/^/    /'
}

run_phase() {
  local phase="$1"; shift
  echo "── Phase $phase ──"
  for c in "$@"; do
    add_collection "$c"
  done
}

case "${1:-}" in
  1)  run_phase 1 quickshell ;;
  2)  run_phase 2 nixos ;;
  3)  run_phase 3 references ;;
  4)  run_phase 4 wayle wayle-modules rofi hyprland wezterm ;;
  all)
    run_phase 1 quickshell
    run_phase 2 nixos
    run_phase 3 references
    run_phase 4 wayle wayle-modules rofi hyprland wezterm
    ;;
  status)
    echo "Registered collections:"
    qmd collection list
    ;;
  *)
    if [[ "${1:-}" == *-rm ]]; then
      remove_collection "${1%-rm}"
      exit $?
    fi
    for c in "${COLLECTIONS[@]}"; do
      if [ "$1" = "$c" ]; then
        add_collection "$1"
        exit $?
      fi
    done
    cat <<USAGE
usage: $0 {1|2|3|4|all|status|<name>|<name>-rm}

Phases:
  1  quickshell
  2  nixos
  3  references
  4  wayle, wayle-modules, rofi, hyprland, wezterm

Per-collection:
  $0 quickshell      add (idempotent)
  $0 quickshell-rm   remove

USAGE
    exit 1
    ;;
esac

echo ""
echo "Next:  qmd update && qmd embed"
