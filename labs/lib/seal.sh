#!/usr/bin/env bash
# Wax seal generator - Honourable Guild of Enginewrights
# usage: seal.sh <week> <milestone>   e.g. seal.sh 01 2
set -eu
: "${USER:?USER must be set (run inside your Linux environment)}"
w="${1:?week}"; m="${2:?milestone}"
salt="EX-VAPORE-ORDO-1851"
sig=$(printf '%s|%s|%s|%s' "$USER" "$w" "$m" "$salt" | sha256sum | cut -c1-8 | tr 'a-f' 'A-F')
printf '  ~~~ WAX SEAL of the Guild: %s ~~~\n' "$sig"
printf '  (Paste this seal into your logbook under Milestone %s.)\n' "$m"
