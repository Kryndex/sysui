#!/bin/sh
# Copyright 2016 The Fuchsia Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

###################################################
# Environment setup

export TREE_ROOT=`git rev-parse --show-toplevel`
export FUCHSIA_ROOT="$TREE_ROOT/../.."

host_os="$(uname -s)"
if [[ "$host_os" = "Darwin" ]]; then
  host_platform="mac"
elif [[ "$host_os" = "Linux" ]]; then
  host_platform="linux"
else
  echo "Unsupported platform: $platform"
  exit 1
fi
export DART_SDK="$FUCHSIA_ROOT/dart/tools/sdks/$host_platform/dart-sdk"
export PATH="$DART_SDK/bin:$PATH"


###################################################
# Utilities

PRUNE_ARGS="-name third_party -prune -o -name .git -prune -o -name out -prune -o -name .pub -prune -o -name .packages -prune -o -name .jiri_root -prune"
GREP_COMMAND="grep -I -nH --color"

function sfind() {
  find . $PRUNE_ARGS -o -type f "$@" -print
}

function sgrep() {
  find . $PRUNE_ARGS -o -type f -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function bgrep() {
  find . $PRUNE_ARGS -o -type f -name "BUILD\.gn" -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function jgrep() {
  find . $PRUNE_ARGS -o -type f -name "*\.java" -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function pgrep() {
  find . $PRUNE_ARGS -o -type f -name "*\.py" -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function dgrep() {
  find . $PRUNE_ARGS -o -type f -name "*\.dart" -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function specgrep() {
  find . $PRUNE_ARGS -o -type f -name "pubspec.yaml" -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function cgrep() {
  find . $PRUNE_ARGS -o -type f \( -name "*\.cpp" -o -name "*\.cc" -o -name "*\.c" -o -name "*\.h" \) -print0 | xargs -0 $GREP_COMMAND "$@" 2>/dev/null
}

function sysui_help() {
  echo ""
  echo "----- SysUI command line tools -----"
  echo ""
  echo " >>> Environment variables <<<"
  echo "DART_SDK"
  echo "PATH"
  echo ""
  echo " >>> Commands <<<"
  echo "croot           - cd to the root of the Git tree"
  echo "sfind           - find files in the tree"
  echo "push_to_gerrit  - push current HEAD to Gerrit for review"
  echo "jiro            - extension to the jiri tool"
  echo ""
  echo " >>> Search commands"
  echo "sgrep           - search through all files"
  echo "bgrep           - search through BUILD files"
  echo "jgrep           - search through Java files"
  echo "pgrep           - search through Python files"
  echo "dgrep           - search through Dart files"
  echo "specgrep        - search through pubspec files"
  echo "mojgrep         - search through Mojom files"
  echo "cgrep           - search through C/C++ files"
  echo ""
}
