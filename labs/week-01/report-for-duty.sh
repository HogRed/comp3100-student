#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-01: claim your bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/                     your bench workspace (created)
#   ~/.bashrc                          one guarded block, between the markers
#                                      "# BEGIN ENGINEHOUSE" / "# END ENGINEHOUSE"
#
# Works offline. Needs no sudo.
set -eu

ENGINEHOUSE="$HOME/enginehouse"
INBOX="$ENGINEHOUSE/inbox"
BASHRC="$HOME/.bashrc"
BEGIN_MARK='# BEGIN ENGINEHOUSE'
END_MARK='# END ENGINEHOUSE'

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  # Only what this week put there. The four rooms are shared with later
  # weeks, so they go only if this week left them empty.
  rm -f "$INBOX/punch-card-fragment.txt" "$INBOX/noticeboard.txt"
  rmdir "$ENGINEHOUSE/inbox" "$ENGINEHOUSE/ledgers" \
        "$ENGINEHOUSE/spool" "$ENGINEHOUSE/machinery" 2>/dev/null || true
  rmdir "$ENGINEHOUSE" 2>/dev/null || true
  if [ -f "$BASHRC" ]; then
    # Delete the RANGE only when both markers survive. If the block has been
    # emptied or half-deleted by hand, a range sed that never meets its END
    # marker runs to the end of the file and takes the student's own
    # ~/.bashrc with it -- so in that case remove the stray marker lines only.
    if grep -qF "$BEGIN_MARK" "$BASHRC" && grep -qF "$END_MARK" "$BASHRC"; then
      sed -i '/# BEGIN ENGINEHOUSE/,/# END ENGINEHOUSE/d' "$BASHRC"
    else
      sed -i -e '/# BEGIN ENGINEHOUSE/d' -e '/# END ENGINEHOUSE/d' "$BASHRC"
    fi
  fi
  echo "Bench struck. This week's inbox is cleared, the empty rooms swept away, and the greeting is out of ~/.bashrc."
  echo "(Run this script again, without --reset, to report for duty afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------------ stage the bench
# Four rooms. Later weeks fill them; this week you only need to find them.
mkdir -p "$ENGINEHOUSE/inbox" "$ENGINEHOUSE/ledgers" \
         "$ENGINEHOUSE/spool" "$ENGINEHOUSE/machinery"

# Inbox item 1: a punched-card fragment the porter could not classify.
# (Rendered on paper tape for the bench-console: O = a punched hole, . = blank.)
cat > "$INBOX/punch-card-fragment.txt" <<'CARD'
.......O....O.......
...O...O............
.......O....O.......
...O...O............
.......O....O.......
...O...O............
.......O........O...
.......O....O.......
...O...O............
.......O............
...O................
.......O....O.......
CARD

# Inbox item 2: this morning's noticeboard, copied to every bench-console.
cat > "$INBOX/noticeboard.txt" <<'BOARD'
======================================================================
  THE ENGINEHOUSE NOTICEBOARD
  copied to every bench-console for the incoming cohort
======================================================================

     * * *  THE GREAT EXHIBITION OF INDUSTRY & SCIENCE  * * *

                BRASSBRIDGE  --  OPENS 7 DECEMBER 1851

        The GRAND ANALYTICAL ENGINE to stand at its centre,
        certified and demonstrated before the crowned heads
        and the engineering societies of the world.

                     +---------------------+
                     |  XVI WEEKS REMAIN   |
                     +---------------------+

----------------------------------------------------------------------

  NOTICE OF THE CIVIC PENSIONS BOARD                 No. 214 of 1849

  In the matter of the PETITION of the late staff of the
  COMPUTING ROOM, forty in number, praying that pensions be
  granted upon the disbanding of the said Room:

      The Board, having weighed the said petition against the
      economies lately achieved by the Grand Analytical Engine,
      finds the expenditure imprudent, and the petition is

                        D E N I E D

  Given under the Board's hand this 12th day of June, 1849.

----------------------------------------------------------------------
  (porter's pencil, in the margin: two years old, this notice, and
   it never stays down -- somebody pins it back up fresh each week.)
======================================================================
BOARD

# The Guild's greeting: one guarded block in ~/.bashrc, added at most once.
touch "$BASHRC"
if ! grep -qF "$BEGIN_MARK" "$BASHRC"; then
  # A hand-edited ~/.bashrc may not end in a newline. Appending straight onto
  # such a file welds "# BEGIN ENGINEHOUSE" onto the tail of the student's
  # last line -- breaking that line, and hiding the marker from the range sed
  # that --reset uses. Close the last line first if it is open.
  if [ -s "$BASHRC" ] && [ -n "$(tail -c 1 "$BASHRC")" ]; then
    printf '\n' >> "$BASHRC"
  fi
  cat >> "$BASHRC" <<'RC'
# BEGIN ENGINEHOUSE
if [ -n "${PS1:-}" ]; then echo "Ex Vapore, Ordo -- the Enginehouse is open.  Bench: ~/enginehouse  |  Duties: this week's work order"; fi
# END ENGINEHOUSE
RC
fi

# ------------------------------------------------------------------ self-test
fail=0
check() {
  if [ ! -e "$1" ]; then
    echo "self-test: MISSING $1" >&2
    fail=1
  fi
}
check "$ENGINEHOUSE/inbox"
check "$ENGINEHOUSE/ledgers"
check "$ENGINEHOUSE/spool"
check "$ENGINEHOUSE/machinery"
check "$INBOX/punch-card-fragment.txt"
check "$INBOX/noticeboard.txt"
if [ "$(wc -l < "$INBOX/punch-card-fragment.txt")" != "12" ]; then
  echo "self-test: punch-card fragment is not 12 rows" >&2
  fail=1
fi
if ! grep -qF "$BEGIN_MARK" "$BASHRC"; then
  echo "self-test: greeting block missing from ~/.bashrc" >&2
  fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-01 :: bench staged and verified
  ------------------------------------------------------------------
   Bench:     ~/enginehouse   (inbox, ledgers, spool, machinery)
   Inbox:     2 items await your attention
   Greeting:  added to ~/.bashrc -- appears on NEW terminals only
              (this terminal was already open; the next one salutes)

   Apprentice enrolled. The Chief expects your logbook Friday.
  ------------------------------------------------------------------

SLIP
