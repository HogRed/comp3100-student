#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-05: stage the Twin Looms bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/ledgers/output-ledger.txt            the Engine's Table IX
#   ~/enginehouse/ledgers/working-papers-tableIX.txt   the figures behind it
#
# Never touches ~/.ledger-annex -- that is Week 2's fair copy, kept apart
# from the house books, and three later weeks still need it whole.
#
# Works offline. Needs no sudo, no crontab, no background processes.
set -eu

ENGINEHOUSE="$HOME/enginehouse"
LEDGERS="$ENGINEHOUSE/ledgers"
OUTPUT="$LEDGERS/output-ledger.txt"
PAPERS="$LEDGERS/working-papers-tableIX.txt"

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  rm -f "$OUTPUT" "$PAPERS"
  # ledgers/ and enginehouse/ are shared with other weeks (Week 1 lays all
  # four rooms down), so they go only if this week leaves them empty, and
  # only if Week 1's own marker is gone too -- the same guard Week 4 uses.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$LEDGERS" 2>/dev/null || true
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. Both ledgers are gone; your annex fair copy at ~/.ledger-annex was never touched."
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------------ stage the bench
mkdir -p "$LEDGERS"

cat > "$OUTPUT" <<'LEDGER'
OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
  reservoir head, feet ............ 41.72
  mains draw, million gallons ..... 8.310
  computed loss, million gallons .. 0.518
  district balance, pounds ........ 214.08
  computed direct, by the Engine, from the working papers
LEDGER

cat > "$PAPERS" <<'PAPERS'
DISTRICT BALANCES, JUNE QUARTER — pounds, as computed from the working papers
  Northgate    53.515
  Waterside    61.245
  Old Quarter  44.635
  Kiln Row     54.665

CULVERT LOSSES, JUNE QUARTER — million gallons
  Culvert I    0.1725
  Culvert II   0.2035
  Culvert III  0.1410
PAPERS

# ------------------------------------------------------------------ self-test
fail=0
[ -f "$OUTPUT" ] || { echo "self-test: $OUTPUT missing" >&2; fail=1; }
[ -f "$PAPERS" ] || { echo "self-test: $PAPERS missing" >&2; fail=1; }
if [ -f "$OUTPUT" ] && ! grep -q '214.08' "$OUTPUT"; then
  echo "self-test: $OUTPUT does not carry 214.08" >&2
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
   Work Order No. 1851-05 :: bench staged and verified
  ------------------------------------------------------------------
   Ledgers:   ~/enginehouse/ledgers/output-ledger.txt
              ~/enginehouse/ledgers/working-papers-tableIX.txt
   Forge:     labs/week-05/starter   (twin-looms.c -- two looms, one
              shared ledger, and nothing standing guard over it)

   Build it. Run it more than once. Count what comes out each time,
   and do not trust the first count more than the second.
   (bash report-for-duty.sh --reset withdraws all.)
  ------------------------------------------------------------------

SLIP
