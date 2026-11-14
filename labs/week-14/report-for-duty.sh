#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-14: stage the aetheric exchange.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# The exchange has a transmission queued in it, and something on this machine
# is listening for replies: a small listener, running as the archive account
# (uid 1849, gid 100), on TCP port 1851 of THIS machine only (127.0.0.1 -- no
# other machine can reach it). To anyone who connects it writes one line and
# hangs up. It reads nothing, sends nothing anywhere, and writes no file. It is
# a living process, launched under the house keys once, exactly as Weeks 10 and
# 12 launched theirs; it does NOT survive `wsl --shutdown`.
#
# Nothing is scheduled. The queue is five plain files; nothing on this bench
# will ever send them anywhere, on any date.
#
# The listener's C source, the dispatches and the exchange's standing
# procedure all live here as sealed base64 payloads (decode_listener,
# decode_dispatch, decode_procedure). The C source is decoded and compiled at
# staging and swept up: no source is left on the bench. The payloads carry the
# archive account only as a number, never by name.
#
# What it touches, and nothing else:
#   ~/enginehouse/exchange/                       yours
#     outbound-queue/                             yours; its five papers, uid 1849
#     held/                                       yours, empty
#     cancellation-procedure.txt                  yours
#   ~/enginehouse/exchange-works/aether-listener  the listener, compiled here
#   TCP port 1851 on 127.0.0.1                    held by the listener
#   the house roll                                one dormant entry restored, by
#                                                 labs/lib/archive-roll.sh
#
# Never touches Week 10's survey/ or its keeper, Week 12's post/ or its copier,
# Week 11's cabinets/, mnt/, recovered/ or ledger-halls/, Week 13's registry/,
# Week 9's src/, Week 2's ~/.ledger-annex, or any other room. The roll entry is
# the course's, not this week's: no week's --reset removes it
# (bash ../lib/archive-roll.sh teardown, at end of term).
#
# Re-running stages the exchange afresh: the listener is stood down, the
# exchange is rebuilt with its queue full, and the listener is relaunched.
# Anything you did in exchange/ before is swept away with it.
#
# Sudo: this week asks for the house keys ONCE. Every job that needs root is
# named below before any of it happens, and all of it is done inside the one
# window. If this bench cannot get root, the script says so and stands down
# having staged nothing.
#
# Works offline. Needs gcc (Week 1's smoke test proved yours) and ss (stock).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
EXCH="$ENGINEHOUSE/exchange"
QUEUE="$EXCH/outbound-queue"            # dir, yours; five papers, 1849:100
HELD="$EXCH/held"                       # dir, yours, empty
PROC="$EXCH/cancellation-procedure.txt" # yours
ORDER="$EXCH/cancellation-order"        # not staged: the student files it
WORKS="$ENGINEHOUSE/exchange-works"
BIN="$WORKS/aether-listener"            # the compiled listener, outside exchange/
PORT=1851
HOLDER_UID=1849
HOLDER_GID=100
UNIT="aether-listener-$(id -u)"         # per-home; the PORT is machine-wide

# --------------------------------------------------------------- the payloads --
# The listener's drawing, kept only here. Decoded at stage time, compiled with
# the student's own gcc, executed as root (which drops itself to uid 1849), and
# swept up: only the built listener is left on the bench.
#
# aether-listener <outbound-queue-dir>
#   opens the queue directory while root (the home is 750), binds 127.0.0.1:1851
#   only, drops to uid 1849 / gid 100, chdir /, forks ONLY when started as root,
#   then answers every connection with one line -- the live count of
#   dispatch-*.txt in the queue -- and hangs up. Reads nothing from the caller.
#   Exits 3 if the port is taken. Run by hand as an ordinary user it stays in
#   the foreground and drops nothing.
decode_listener() { # writes aether-listener's C source to $1
  base64 -d > "$1" <<'B64'
LyogYWV0aGVyLWxpc3RlbmVyLmMgLS0gYSBsaXN0ZW5lciBsZWZ0IG9uIHRoZSBleGNoYW5nZSwg
d2FpdGluZyBmb3IgcmVwbGllcy4KICoKICogVXNhZ2U6ICBhZXRoZXItbGlzdGVuZXIgPG91dGJv
dW5kLXF1ZXVlLWRpcj4gW3BvcnRdCiAqCiAqIEl0IGxpc3RlbnMgb24gMTI3LjAuMC4xIG9ubHkg
LS0gdGhpcyBtYWNoaW5lLCBuZXZlciB0aGUgbmV0d29yayAtLSBhdCBUQ1AKICogcG9ydCAxODUx
IHVubGVzcyBhIHBvcnQgaXMgZ2l2ZW4gKHRoZSBwb3J0IGFyZ3VtZW50IGV4aXN0cyBzbyB0aGUg
cHJvZ3JhbQogKiBjYW4gYmUgcHJvdmVuIGJ5IGhhbmQgb24gYSBzcGFyZSBwb3J0OyBzdGFnaW5n
IG5ldmVyIHBhc3NlcyBvbmUpLiBUbyBldmVyeQogKiBjb25uZWN0aW9uIGl0IHdyaXRlcyBleGFj
dGx5IG9uZSBsaW5lIGFuZCBjbG9zZXM6CiAqCiAqICAgRVhDSEFOR0UgTElTVEVORVIgLS0gZGlz
cGF0Y2hlcyBxdWV1ZWQ6IE4gLS0gYWNrbm93bGVkZ21lbnRzIHJlY2VpdmVkOiAwCiAqCiAqIE4g
aXMgY291bnRlZCBhZnJlc2gsIG9uIGV2ZXJ5IGNvbm5lY3Rpb24sIGZyb20gdGhlIHF1ZXVlIGRp
cmVjdG9yeTogdGhlCiAqIGVudHJpZXMgbmFtZWQgZGlzcGF0Y2gtKi50eHQuIE1vdmUgdGhlbSBv
dXQgYW5kIE4gZmFsbHM7IHRoYXQgaXMgdGhlIHdob2xlCiAqIG9mIGl0cyBiZWhhdmlvdXIuIEl0
IHJlYWRzIG5vdGhpbmcgYSBjbGllbnQgc2VuZHMsIGZvcndhcmRzIG5vdGhpbmcsIG9wZW5zCiAq
IG5vIGNvbm5lY3Rpb24gb2YgaXRzIG93biwgYW5kIHdyaXRlcyB0byBubyBmaWxlLgogKgogKiBJ
dCBvcGVucyB0aGUgcXVldWUgZGlyZWN0b3J5IHdoaWxlIHN0aWxsIHJvb3QsIGJlY2F1c2UgdGhl
IHN0dWRlbnQncyBob21lCiAqIGlzIG1vZGUgNzUwIGFuZCBhIHByb2Nlc3MgcnVubmluZyBhcyB0
aGUgYXJjaGl2ZSBhY2NvdW50IGNvdWxkIG5vdAogKiB0cmF2ZXJzZSBpdC4gQW4gb3BlbiBkaXJl
Y3RvcnkgZGVzY3JpcHRvciBzdXJ2aXZlcyB0aGUgcHJpdmlsZWdlIGRyb3AgYW5kCiAqIGNhbiBz
dGlsbCBiZSByZWFkIChXZWVrIDEyJ3MgY29waWVyIGhlbGQgaXRzIEZJRk9zIHRoZSBzYW1lIHdh
eSkuIEl0IHRoZW4KICogZHJvcHMgdG8gdGhlIGFyY2hpdmUgYWNjb3VudCAodWlkIDE4NDksIGdp
ZCAxMDApLCBhcyBXZWVrcyAxMCBhbmQgMTIgZGlkLgogKgogKiBJdCBmb3JrcyBvbmNlIE9OTFkg
d2hlbiBzdGFydGVkIGFzIHJvb3QsIHNvIHN5c3RlbWQgKFR5cGU9Zm9ya2luZykgYWRvcHRzCiAq
IHRoZSBzdGFuZGluZyBjb3B5IGFuZCB0aGUgbGF1bmNoaW5nIHNoZWxsIHJldHVybnMuIFJ1biBi
eSBoYW5kIGFzIGFuCiAqIG9yZGluYXJ5IHVzZXIgaXQgbmVpdGhlciBkcm9wcyBwcml2aWxlZ2Vz
IG5vciBmb3JrczogaXQgc3RheXMgaW4gdGhlCiAqIGZvcmVncm91bmQsIHNvIGl0IGNhbiBiZSBw
cm92ZW4gdW5kZXIgYHRpbWVvdXRgIHdpdGggbm90aGluZyBsZWZ0IGJlaGluZC4KICoKICogSXQg
aWdub3JlcyBTSUdQSVBFIChhIGNsaWVudCB0aGF0IGhhbmdzIHVwIGVhcmx5IG11c3Qgbm90IGZl
bGwgaXQpIGFuZAogKiBzdGFuZHMgdW50aWwgaXQgaXMgc3RvcHBlZCAoU0lHVEVSTSwgdGhlIGRl
ZmF1bHQpLgogKgogKiBHZW5lcmF0ZWQgZnJvbSBhIGJhc2U2NCBwYXlsb2FkIGF0IHN0YWdpbmc7
IHRoZSBzb3VyY2UgaXMgbm90IGxlZnQgYmVoaW5kLgogKiBJdCBjYXJyaWVzIHRoZSBhcmNoaXZl
IGFjY291bnQgb25seSBhcyBhIG51bWJlciwgbmV2ZXIgYnkgbmFtZS4KICovCiNkZWZpbmUgX0dO
VV9TT1VSQ0UKI2luY2x1ZGUgPGRpcmVudC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUg
PGZjbnRsLmg+CiNpbmNsdWRlIDxncnAuaD4KI2luY2x1ZGUgPHNpZ25hbC5oPgojaW5jbHVkZSA8
c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRl
IDx1bmlzdGQuaD4KI2luY2x1ZGUgPGFycGEvaW5ldC5oPgojaW5jbHVkZSA8bmV0aW5ldC9pbi5o
PgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CgovKiBUaGUg
YXJjaGl2ZSBhY2NvdW50LCBhcyB0aGUgaG91c2Ugcm9sbCBjYXJyaWVzIGl0OiB1aWQgMTg0OSwg
cHJpbWFyeSBncm91cAogKiAxMDAgKCJ1c2VycyIpLiBOZXZlciB0aGUgbmFtZS4gKi8KI2RlZmlu
ZSBBUkNISVZFX1VJRCAxODQ5CiNkZWZpbmUgQVJDSElWRV9HSUQgMTAwCgojZGVmaW5lIERFRkFV
TFRfUE9SVCAxODUxCgovKiBDb3VudCB0aGUgZW50cmllcyBuYW1lZCBkaXNwYXRjaC0qLnR4dCwg
cmVhZGluZyB0aGUgaGVsZCBkaXJlY3RvcnkgZnJvbQogKiB0aGUgc3RhcnQgZWFjaCB0aW1lLiAq
LwpzdGF0aWMgaW50IGNvdW50X2Rpc3BhdGNoZXMoRElSICpkaXIpCnsKICAgIGludCBuID0gMDsK
ICAgIHN0cnVjdCBkaXJlbnQgKmU7CiAgICBzaXplX3QgcHJlID0gc3RybGVuKCJkaXNwYXRjaC0i
KSwgc3VmID0gc3RybGVuKCIudHh0Iik7CgogICAgcmV3aW5kZGlyKGRpcik7CiAgICB3aGlsZSAo
KGUgPSByZWFkZGlyKGRpcikpICE9IE5VTEwpIHsKICAgICAgICBzaXplX3QgbGVuID0gc3RybGVu
KGUtPmRfbmFtZSk7CiAgICAgICAgaWYgKGxlbiA+IHByZSArIHN1ZgogICAgICAgICAgICAmJiBz
dHJuY21wKGUtPmRfbmFtZSwgImRpc3BhdGNoLSIsIHByZSkgPT0gMAogICAgICAgICAgICAmJiBz
dHJjbXAoZS0+ZF9uYW1lICsgbGVuIC0gc3VmLCAiLnR4dCIpID09IDApCiAgICAgICAgICAgIG4r
KzsKICAgIH0KICAgIHJldHVybiBuOwp9CgovKiBXcml0ZSBhbGwgbiBieXRlcywgcmV0cnlpbmcg
c2hvcnQgd3JpdGVzIGFuZCBFSU5UUi4gKi8Kc3RhdGljIHZvaWQgd3JpdGVfYWxsKGludCBmZCwg
Y29uc3QgY2hhciAqYnVmLCBzaXplX3QgbikKewogICAgc2l6ZV90IG9mZiA9IDA7CiAgICB3aGls
ZSAob2ZmIDwgbikgewogICAgICAgIHNzaXplX3QgdyA9IHdyaXRlKGZkLCBidWYgKyBvZmYsIG4g
LSBvZmYpOwogICAgICAgIGlmICh3IDwgMCkgewogICAgICAgICAgICBpZiAoZXJybm8gPT0gRUlO
VFIpCiAgICAgICAgICAgICAgICBjb250aW51ZTsKICAgICAgICAgICAgcmV0dXJuOyAgICAgICAg
LyogdGhlIGNsaWVudCBoYXMgZ29uZTsgbm90aGluZyB0byBkbyAqLwogICAgICAgIH0KICAgICAg
ICBvZmYgKz0gKHNpemVfdCl3OwogICAgfQp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFy
Z3YpCnsKICAgIGlmIChhcmdjICE9IDIgJiYgYXJnYyAhPSAzKQogICAgICAgIHJldHVybiAyOwoK
ICAgIGludCBwb3J0ID0gREVGQVVMVF9QT1JUOwogICAgaWYgKGFyZ2MgPT0gMykgewogICAgICAg
IHBvcnQgPSBhdG9pKGFyZ3ZbMl0pOwogICAgICAgIGlmIChwb3J0IDwgMSB8fCBwb3J0ID4gNjU1
MzUpCiAgICAgICAgICAgIHJldHVybiAyOwogICAgfQoKICAgIGludCB3YXNfcm9vdCA9IChnZXRl
dWlkKCkgPT0gMCk7CgogICAgLyogT3BlbiB0aGUgcXVldWUgZGlyZWN0b3J5IHdoaWxlIHN0aWxs
IHJvb3Q7IHRoZSBkZXNjcmlwdG9yIG91dGxpdmVzCiAgICAgKiB0aGUgZHJvcC4gKi8KICAgIGlu
dCBkZmQgPSBvcGVuKGFyZ3ZbMV0sIE9fUkRPTkxZIHwgT19ESVJFQ1RPUlkpOwogICAgaWYgKGRm
ZCA8IDApCiAgICAgICAgcmV0dXJuIDE7CiAgICBESVIgKmRpciA9IGZkb3BlbmRpcihkZmQpOwog
ICAgaWYgKGRpciA9PSBOVUxMKQogICAgICAgIHJldHVybiAxOwoKICAgIC8qIExpc3RlbiBvbiB0
aGlzIG1hY2hpbmUgb25seS4gKi8KICAgIGludCBzID0gc29ja2V0KEFGX0lORVQsIFNPQ0tfU1RS
RUFNLCAwKTsKICAgIGlmIChzIDwgMCkKICAgICAgICByZXR1cm4gMTsKICAgIGludCBvbmUgPSAx
OwogICAgc2V0c29ja29wdChzLCBTT0xfU09DS0VULCBTT19SRVVTRUFERFIsICZvbmUsIHNpemVv
ZiBvbmUpOwogICAgc3RydWN0IHNvY2thZGRyX2luIGFkZHI7CiAgICBtZW1zZXQoJmFkZHIsIDAs
IHNpemVvZiBhZGRyKTsKICAgIGFkZHIuc2luX2ZhbWlseSA9IEFGX0lORVQ7CiAgICBhZGRyLnNp
bl9wb3J0ID0gaHRvbnMoKHVuc2lnbmVkIHNob3J0KXBvcnQpOwogICAgYWRkci5zaW5fYWRkci5z
X2FkZHIgPSBodG9ubChJTkFERFJfTE9PUEJBQ0spOwogICAgaWYgKGJpbmQocywgKHN0cnVjdCBz
b2NrYWRkciAqKSZhZGRyLCBzaXplb2YgYWRkcikgIT0gMCkKICAgICAgICByZXR1cm4gMzsgICAg
ICAgICAgLyogdGhlIHBvcnQgaXMgdGFrZW46IHN0YWdpbmcgc2F5cyBzbyAqLwogICAgaWYgKGxp
c3RlbihzLCA4KSAhPSAwKQogICAgICAgIHJldHVybiAxOwoKICAgIHNpZ25hbChTSUdQSVBFLCBT
SUdfSUdOKTsKCiAgICAvKiBEcm9wIHRvIHRoZSBhcmNoaXZlIGFjY291bnQsIGJ1dCBvbmx5IHdo
ZW4gc3RhcnRlZCBhcyByb290LiBHcm91cHMKICAgICAqIGZpcnN0LCB0aGVuIGdpZCwgdGhlbiB1
aWQgbGFzdC4gKi8KICAgIGlmICh3YXNfcm9vdCkgewogICAgICAgIGlmIChzZXRncm91cHMoMCwg
TlVMTCkgIT0gMCkKICAgICAgICAgICAgcmV0dXJuIDE7CiAgICAgICAgaWYgKHNldHJlc2dpZChB
UkNISVZFX0dJRCwgQVJDSElWRV9HSUQsIEFSQ0hJVkVfR0lEKSAhPSAwKQogICAgICAgICAgICBy
ZXR1cm4gMTsKICAgICAgICBpZiAoc2V0cmVzdWlkKEFSQ0hJVkVfVUlELCBBUkNISVZFX1VJRCwg
QVJDSElWRV9VSUQpICE9IDApCiAgICAgICAgICAgIHJldHVybiAxOwogICAgfQoKICAgIGlmIChj
aGRpcigiLyIpICE9IDApCiAgICAgICAgcmV0dXJuIDE7CgogICAgaWYgKHdhc19yb290KSB7CiAg
ICAgICAgcGlkX3QgcGlkID0gZm9yaygpOwogICAgICAgIGlmIChwaWQgPCAwKQogICAgICAgICAg
ICByZXR1cm4gMTsKICAgICAgICBpZiAocGlkID4gMCkKICAgICAgICAgICAgcmV0dXJuIDA7CiAg
ICAgICAgc2V0c2lkKCk7CiAgICB9CgogICAgLyogQW5zd2VyIGV2ZXJ5IGNhbGxlciB3aXRoIG9u
ZSBsaW5lLCB0aGVuIGhhbmcgdXAuICovCiAgICBmb3IgKDs7KSB7CiAgICAgICAgaW50IGMgPSBh
Y2NlcHQocywgTlVMTCwgTlVMTCk7CiAgICAgICAgaWYgKGMgPCAwKSB7CiAgICAgICAgICAgIGlm
IChlcnJubyA9PSBFSU5UUikKICAgICAgICAgICAgICAgIGNvbnRpbnVlOwogICAgICAgICAgICBj
b250aW51ZTsgICAgICAvKiBrZWVwIHN0YW5kaW5nICovCiAgICAgICAgfQogICAgICAgIGNoYXIg
bGluZVsxMjhdOwogICAgICAgIGludCBsZW4gPSBzbnByaW50ZihsaW5lLCBzaXplb2YgbGluZSwK
ICAgICAgICAgICAgIkVYQ0hBTkdFIExJU1RFTkVSIC0tIGRpc3BhdGNoZXMgcXVldWVkOiAlZCAt
LSBhY2tub3dsZWRnbWVudHMgcmVjZWl2ZWQ6IDBcbiIsCiAgICAgICAgICAgIGNvdW50X2Rpc3Bh
dGNoZXMoZGlyKSk7CiAgICAgICAgaWYgKGxlbiA+IDApCiAgICAgICAgICAgIHdyaXRlX2FsbChj
LCBsaW5lLCAoc2l6ZV90KWxlbik7CiAgICAgICAgY2xvc2UoYyk7CiAgICB9CiAgICByZXR1cm4g
MDsKfQo=
B64
}

# One dispatch, with {NN} and {ROMAN} left for its number and its route.
decode_dispatch() { # writes the dispatch template to $1
  base64 -d > "$1" <<'B64'
RElTUEFUQ0gge05OfSBPRiAwNSAtLSBST1VURSB7Uk9NQU59IC0tIEhPTEQgVU5USUwgTW9uIDcg
RGVjIDE4NTEsIG9wZW5pbmcgbW9ybmluZwoKVG8gdGhlIEJvYXJkcyBvZiB0aGUgZml2ZSBzaXN0
ZXIgY2l0aWVzLCBmb3IgdGhlIEV4aGliaXRpb24ncyBvcGVuaW5nIG1vcm5pbmcgLS0KR2VudGxl
bWVuOiB5b3UgYXJlIGJ1aWxkaW5nIEVuZ2luZXMgb2YgeW91ciBvd24sIGFuZCB5b3UgYXJlIGlu
dml0ZWQgdG8gYWRtaXJlIG91cnMuCkFkbWlyZSBpdC4gVGhlbiBjaGVjayBpdC4gSXRzIHRhYmxl
cyBoYXZlIGNhcnJpZWQgZXJyb3JzIGZvciB5ZWFycywKYW5kIHRoZSBtZW4gd2hvIGNvdWxkIGhh
dmUgY2F1Z2h0IHRoZW0gd2VyZSBzZW50IGhvbWUuCkEgbWFjaGluZSB0aGF0IGlzIG5ldmVyIGNo
ZWNrZWQgaXMgbm90IHRydXN0ZWQuIEl0IGlzIG9ubHkgYmVsaWV2ZWQuCkJlZm9yZSB5b3UgdHJ1
c3QgeW91cnMsIGZpbmQgc29tZW9uZSB3aG8gd2lsbCBjaGVjayBpdC4KeW91ciBkaWxpZ2VudCBz
ZXJ2YW50LAoKRU5DTE9TVVJFUyAoYnkgcmVmZXJlbmNlKToKICAxLiBUaHJlZSBtZW1vcmFuZGEg
dG8gdGhlIEJvYXJkIG9mIHRoZSBFbmdpbmVob3VzZSwgd3JpdHRlbiAxODQ4LAogICAgIHN0cnVj
ayBmcm9tIHRoZSByZWNvcmQgYnkgb3JkZXIgb2YgdGhlIEJvYXJkLCAxODQ5OgogICAgICAgMTg0
OC0wMy0xNC1ib2FyZC10YWJsZS1peC50eHQKICAgICAgIDE4NDgtMDgtMDItYm9hcmQtZGlzdHJp
Y3QtYmFsYW5jZXMudHh0CiAgICAgICAxODQ4LTExLTMwLWJvYXJkLXJldGFpbi10aGUtY29tcHV0
ZXJzLnR4dAogIDIuIFdhdGVyd29ya3MgVGFibGUgSVgsIHR3byByb3dzLCBhcyB0aGUgRW5naW5l
IHByaW50cyB0aGVtIGFuZCBhcwogICAgIHRoZXkgY29tZSBvdXQgd2hlbiBzdW1tZWQgZmlyc3Qg
YW5kIHJvdW5kZWQgb25jZToKICAgICAgIGNvbXB1dGVkIGxvc3MgKG1pbGxpb24gZ2FsbG9ucykg
ICAgMC41MTggICAgc2hvdWxkIHJlYWQgICAgMC41MTcKICAgICAgIGRpc3RyaWN0IGJhbGFuY2Ug
KHBvdW5kcykgICAgICAgICAgMjE0LjA4ICAgc2hvdWxkIHJlYWQgICAgMjE0LjA2CiAgMy4gRXZl
cnkgZmlndXJlIGFib3ZlIG1heSBiZSBjaGVja2VkIGJ5IGhhbmQuIENoZWNrIGl0Lgo=
B64
}

# The exchange's standing procedure, filed beside the queue.
decode_procedure() { # writes the procedure to $1
  base64 -d > "$1" <<'B64'
VEhFIFRFTEVHUkFQSCBFWENIQU5HRSBPRiBCUkFTU0JSSURHRQpTVEFORElORyBQUk9DRURVUkU6
IFRPIFNUQVkgQSBRVUVVRUQgVFJBTlNNSVNTSU9OCmVudGVyZWQ6IDE4NTEtMTAtMzAKCldIRVJF
QVMgYSB0cmFuc21pc3Npb24gcXVldWVkIGF0IHRoaXMgRXhjaGFuZ2UgaXMgaGVsZCB1bnRpbCBp
dHMKYXBwb2ludGVkIGhvdXIsIGFuZCBtYXkgYmUgc3RheWVkIGJlZm9yZSB0aGF0IGhvdXIgYnkg
YW55IG9mZmljZXIgb2YKdGhlIEV4Y2hhbmdlIG9yIGFueSBhcHByZW50aWNlIG9mIHRoZSBHdWls
ZDsKCkFORCBXSEVSRUFTIG5vdGhpbmcgc3RheWVkIGlzIHRoZXJlYnkgZGVzdHJveWVkOwoKVG8g
c3RheSBhIHF1ZXVlZCB0cmFuc21pc3Npb246CgogIDEuIENvdW50IHRoZSBkaXNwYXRjaGVzIHdh
aXRpbmcgaW4gdGhlIG91dGJvdW5kIHF1ZXVlLAogICAgICAgfi9lbmdpbmVob3VzZS9leGNoYW5n
ZS9vdXRib3VuZC1xdWV1ZS8KCiAgMi4gTW92ZSBldmVyeSBkaXNwYXRjaCwgdW5hbHRlcmVkLCBp
bnRvIHRoZSBoZWxkIHRyYXksCiAgICAgICB+L2VuZ2luZWhvdXNlL2V4Y2hhbmdlL2hlbGQvCiAg
ICAgQSBoZWxkIGRpc3BhdGNoIGlzIG5vdCBzZW50LiBJdCBtYXkgYmUgcmVhZCwgYW5kIGl0IG1h
eSBiZQogICAgIHJlbGVhc2VkLCBieSBhbnkgd2hvIGNvbWUgYWZ0ZXIuIERvIG5vdCBkZXN0cm95
IGl0LgoKICAzLiBGaWxlIGEgY2FuY2VsbGF0aW9uIG9yZGVyIGF0CiAgICAgICB+L2VuZ2luZWhv
dXNlL2V4Y2hhbmdlL2NhbmNlbGxhdGlvbi1vcmRlcgogICAgIGdpdmluZywgb25lIHRvIGEgbGlu
ZToKICAgICAgIGRpc3BhdGNoZXMgaGVsZDogPHRoZSBjb3VudCBmcm9tIHN0ZXAgMT4KICAgICAg
IGRhdGU6IDx0aGUgZGF5IHlvdSBoZWxkIHRoZW0+CgogIDQuIEFzayB0aGUgRXhjaGFuZ2UncyBs
aXN0ZW5lciB3aGF0IGl0IGlzIHdhaXRpbmcgZm9yLiBXaGVuIHRoZQogICAgIHF1ZXVlIGlzIHN0
YXllZCBpdCB3aWxsIHNheSB0aGF0IG5vdGhpbmcgaXMgcXVldWVkLgoKQSBkZW1vbnN0cmF0aW9u
IHRoYXQgY2Fubm90IGJlIHN0b3BwZWQgaXMgYSB3ZWFwb247IGEgZGVtb25zdHJhdGlvbiB0aGF0
IGNhbiBiZSBzdG9wcGVkIGlzIGFuIGFyZ3VtZW50Lgo=
B64
}

HERE="$(cd "$(dirname "$0")" && pwd)"
ROLL="$HERE/../lib/archive-roll.sh"
LC_ALL=C          # stat's file-type words are read back in English
export LC_ALL

# --------------------------------------------------------------- root guard --
# Running the whole script under sudo stages root's home, not yours, and every
# check this week reads from your own bench. Refuse before anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This script asks for the house keys itself, once, exactly when"   >&2
  echo "  it needs them -- running it under sudo stages root's home"        >&2
  echo "  directory instead of yours, and nothing this week will find it"   >&2
  echo "  there. Nothing has been staged. Run it again as yourself:"        >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

have_systemd_run() {
  command -v systemd-run >/dev/null 2>&1 && [ -d /run/systemd/system ]
}

# THIS HOME'S LISTENER: every uid-1849 process named exactly aether-listener
# that is alive in /proc AND whose command line names this home's queue. (Not
# kill -0: you may not signal another account's process, so the knock fails
# with EPERM and a live listener would read as dead.)
listener_pids() {
  for _p in $(pgrep -u "$HOLDER_UID" -x aether-listener 2>/dev/null || true); do
    [ -d "/proc/$_p" ] || continue
    if tr '\0' '\n' < "/proc/$_p/cmdline" 2>/dev/null | grep -qxF -- "$QUEUE"; then
      echo "$_p"
    fi
  done
}
listener_pid() { listener_pids | head -1; }
listener_up()  { [ -n "$(listener_pid)" ]; }

# Is anything listening on 127.0.0.1:1851 (or every address at 1851)?
port_taken() {
  ss -Htln 2>/dev/null | awk -v p="$PORT" '
    { n = split($4, a, ":"); if (a[n] == p) f = 1 } END { exit !f }'
}

# Ask the port for its one line (bash's own /dev/tcp: no other tool needed).
ask_port() {
  timeout 3 bash -c 'exec 3<>"/dev/tcp/127.0.0.1/$1" && cat <&3' sh "$PORT" 2>/dev/null || true
}

get_root() {
  command -v sudo >/dev/null 2>&1 || return 1
  sudo -n true 2>/dev/null && return 0
  { [ -t 0 ] && [ -t 1 ]; } || return 1
  sudo -v
}

# Stand this home's listener down, and nobody else's. The unit first; then, as
# a backstop, by pid -- SIGTERM, and SIGKILL if it will not go. Needs root.
# True only if no listener of this home's is left standing.
stop_listener() {
  if have_systemd_run; then
    sudo systemctl stop "$UNIT" 2>/dev/null || true
  fi
  for _p in $(listener_pids); do
    sudo kill -TERM "$_p" 2>/dev/null || true
    _i=0
    while [ "$_i" -lt 40 ] && [ -d "/proc/$_p" ]; do sleep 0.1; _i=$((_i + 1)); done
    if [ -d "/proc/$_p" ]; then sudo kill -KILL "$_p" 2>/dev/null || true; fi
  done
  if have_systemd_run; then
    sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
  fi
  _i=0
  while [ "$_i" -lt 20 ] && listener_up; do sleep 0.1; _i=$((_i + 1)); done
  ! listener_up
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  # The listener is uid 1849's, not yours, so standing it down needs the house
  # keys. If it is up and root cannot be had, nothing at all is removed.
  if listener_up; then
    echo "Closing the exchange. One step, via sudo: it stands down the listener"
    echo "(uid $HOLDER_UID), which is not yours and will not yield to you. sudo"
    echo "may ask for your password now."
    if ! get_root; then
      echo "report-for-duty: this bench cannot get root, so the listener could"   >&2
      echo "  not be stood down. Nothing has been removed -- the exchange is"     >&2
      echo "  exactly as you found it. Take this to your instructor rather than"  >&2
      echo "  working around it."                                                 >&2
      exit 1
    fi
    if ! stop_listener; then
      echo "report-for-duty: the listener would not stand down. Nothing has been" >&2
      echo "  removed. Take this to your instructor."                             >&2
      exit 1
    fi
  else
    if have_systemd_run && sudo -n true 2>/dev/null; then
      sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    fi
  fi

  # The rest is yours. The five papers belong to uid 1849, but they sit in
  # directories you own, and a directory's write bit is what governs removal.
  rm -rf "$EXCH" "$WORKS"
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The listener is stood down, and the exchange with it."
  if [ -d "$ENGINEHOUSE" ]; then
    echo "~/enginehouse still holds other weeks' papers; they were not touched."
  fi
  echo "The house roll is untouched -- that entry belongs to the course and not"
  echo "to this week. (bash ../lib/archive-roll.sh teardown removes it, once, at"
  echo "the end of term.)"
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

launch_listener() {
  if have_systemd_run; then
    sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    sudo systemd-run --collect --quiet --unit="$UNIT" -p Type=forking \
      "$BIN" "$QUEUE"
  else
    sudo setsid "$BIN" "$QUEUE" </dev/null >/dev/null 2>&1
  fi
}

# ------------------------------------------------------ what still wants doing
# Worked out before anything root happens, so a bench that cannot get root, or
# whose port is taken, is left as it was found rather than half-staged.
if ! command -v ss >/dev/null 2>&1; then
  echo "report-for-duty: ss not found -- it is part of every Ubuntu (iproute2)." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
  exit 1
fi
need_roll=0
bash "$ROLL" check || need_roll=1
restage=0
if listener_up || [ -e "$EXCH" ]; then restage=1; fi

# Port 1851 is the whole machine's, not just this home's. If something other
# than this home's own listener holds it, stand down before touching anything.
if port_taken && ! listener_up; then
  echo "report-for-duty: TCP port $PORT on this machine is already taken by a"    >&2
  echo "  program this script did not start here. Nothing has been staged."       >&2
  echo "  Find what holds it with:  sudo ss -tlnp | grep ':$PORT '"               >&2
  echo "  and take that line to your instructor."                                 >&2
  exit 1
fi

# --------------------------------------------------------- build the listener
if ! command -v gcc >/dev/null 2>&1; then
  echo "report-for-duty: gcc not found -- this week's listener is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_listener  "$tmp/aether-listener.c"
decode_dispatch  "$tmp/dispatch.template"
decode_procedure "$tmp/cancellation-procedure.txt"
if ! ( cd "$tmp" && gcc -O2 -s -Wall -Wextra -o aether-listener aether-listener.c ); then
  echo "report-for-duty: the listener did not build on this bench. The messages" >&2
  echo "  above are gcc's. Nothing has been staged. Take this to your"           >&2
  echo "  instructor rather than working around it."                             >&2
  exit 1
fi
mkdir "$tmp/queue"
n=1
for r in I II III IV V; do
  sed -e "s/{NN}/0$n/" -e "s/{ROMAN}/$r/" "$tmp/dispatch.template" > "$tmp/queue/dispatch-0$n.txt"
  n=$((n + 1))
done

# -------------------------------------------------------------- the house keys
stand_down() {
  echo "report-for-duty: this bench cannot get root -- either sudo is not"      >&2
  echo "  installed, or it wants a password prompt this session has no"         >&2
  echo "  terminal to give. Nothing has been staged: the exchange is exactly"   >&2
  echo "  as you found it. Take this to your instructor rather than working"    >&2
  echo "  around it."                                                           >&2
  exit 1
}

echo "Before the exchange can be staged, the house keys are wanted. They are"
echo "asked for once, for the whole of the following, and for nothing else:"
echo
if [ "$need_roll" -ne 0 ]; then
  echo "  * The roll. One dormant entry is restored to it (useradd, by"
  echo "    labs/lib/archive-roll.sh): no password, no home directory, no"
  echo "    login shell -- nothing can log in as it. Reversible by name, and"
  echo "    shared with later weeks, so no week's --reset takes it away."
fi
if [ "$restage" -ne 0 ]; then
  echo "  * The old exchange. Its listener is stood down, so the exchange can"
  echo "    be rebuilt clean. (Only this home's: another account's on this"
  echo "    machine is not touched.)"
fi
echo "  * The queue's papers. They are made over to uid $HOLDER_UID. Their"
echo "    folder, and everything else in the exchange, stays yours."
if have_systemd_run; then
  echo "  * The listener. It is launched as a transient unit named '$UNIT'"
  echo "    (systemd-run), takes port $PORT on 127.0.0.1 -- this machine only --"
  echo "    then drops itself to uid $HOLDER_UID and stands. systemd keeps it"
  echo "    alive past this shell."
else
  echo "  * The listener. It is launched (setsid), takes port $PORT on 127.0.0.1"
  echo "    -- this machine only -- then drops itself to uid $HOLDER_UID and"
  echo "    stands. This bench has no systemd to keep it, so it may not outlive"
  echo "    this login session."
fi
echo "  * One look at the port's owner (only root may see another account's"
echo "    process there), to confirm it is the listener just launched."
echo
echo "One prompt covers all of it. sudo may ask for your password now, once,"
echo "and everything listed above happens inside that one window."
if [ "$need_roll" -ne 0 ]; then
  echo "(The roll office adds its own note on the first item as it works. It"
  echo "will not ask you for anything.)"
fi
echo

command -v sudo >/dev/null 2>&1 || stand_down
if ! sudo -n true 2>/dev/null; then
  { [ -t 0 ] && [ -t 1 ]; } || stand_down
  sudo -v || stand_down
fi

# -------------------------------------------------------------- the house roll
if [ "$need_roll" -ne 0 ]; then
  if ! bash "$ROLL" ensure; then
    echo "report-for-duty: the house roll was not restored, so the exchange has" >&2
    echo "  been left unstaged rather than half-staged. The message above is"    >&2
    echo "  the roll office's -- take it to your instructor."                     >&2
    exit 1
  fi
  echo
fi

# ------------------------------------------------------------- strike the old
# The listener goes first: it holds the old queue directory open.
if ! stop_listener; then
  echo "report-for-duty: the old listener would not stand down. Nothing has been" >&2
  echo "  rebuilt. Take this to your instructor."                                  >&2
  exit 1
fi
i=0
while [ "$i" -lt 30 ] && port_taken; do sleep 0.1; i=$((i + 1)); done
if port_taken; then
  echo "report-for-duty: port $PORT is still held after the old listener stood"  >&2
  echo "  down. Nothing has been rebuilt. Take this to your instructor."          >&2
  exit 1
fi
rm -rf "$EXCH"

# ---------------------------------------------------------------- the exchange
mkdir -p "$QUEUE" "$HELD" "$WORKS"
chmod 755 "$EXCH" "$QUEUE" "$HELD"
mv -f "$tmp/aether-listener" "$BIN"
chmod 755 "$BIN"
install -m 644 "$tmp/cancellation-procedure.txt" "$PROC"
for f in "$tmp"/queue/dispatch-0?.txt; do
  sudo install -o "$HOLDER_UID" -g "$HOLDER_GID" -m 644 "$f" "$QUEUE/"
done

# --------------------------------------------------------- launch the listener
if ! launch_listener; then
  echo "report-for-duty: the listener could not be launched. Take this to your" >&2
  echo "  instructor."                                                         >&2
  exit 1
fi
i=0
while [ "$i" -lt 40 ] && ! { listener_up && port_taken; }; do sleep 0.1; i=$((i + 1)); done
if ! listener_up; then
  echo "report-for-duty: the listener did not come up after launch. Take this"  >&2
  echo "  to your instructor."                                                  >&2
  exit 1
fi

# ------------------------------------------------------------------ self-test
# Checks the bench against what was just decoded. It reports where the bench
# disagrees; it never prints what the exchange holds.
fail=0
me="$(id -u):$(id -g)"
expect() { # expect <path> <%F> <uid:gid> <mode, or - for any>
  _got="$(stat -c '%F|%u:%g|%a' "$1" 2>/dev/null || echo missing)"
  _want="$2|$3|$4"
  [ "$4" = - ] && _got="${_got%|*}|-"
  if [ "$_got" != "$_want" ]; then
    echo "self-test: $1 is '$_got', not '$_want'" >&2; fail=1
  fi
}
expect "$EXCH"   directory      "$me" 755
expect "$QUEUE"  directory      "$me" 755
expect "$HELD"   directory      "$me" 755
expect "$PROC"   "regular file" "$me" 644
expect "$BIN"    "regular file" "$me" 755
for f in "$tmp"/queue/dispatch-0?.txt; do
  b="$(basename "$f")"
  expect "$QUEUE/$b" "regular file" "$HOLDER_UID:$HOLDER_GID" 644
  cmp -s "$f" "$QUEUE/$b" || { echo "self-test: $b differs from its staged paper" >&2; fail=1; }
done
cmp -s "$tmp/cancellation-procedure.txt" "$PROC" || { echo "self-test: the procedure differs from its staged paper" >&2; fail=1; }
if [ "$(ls -A "$EXCH" | sort | tr '\n' ' ')" != "cancellation-procedure.txt held outbound-queue " ]; then
  echo "self-test: exchange/ does not hold exactly its three items" >&2; fail=1
fi
if [ -n "$(ls -A "$HELD")" ]; then
  echo "self-test: held/ is not empty" >&2; fail=1
fi
if [ "$(ls -A "$QUEUE" | sort | tr '\n' ' ')" != "$(ls "$tmp/queue" | sort | tr '\n' ' ')" ]; then
  echo "self-test: outbound-queue/ does not hold exactly its staged papers" >&2; fail=1
fi
pids="$(listener_pids)"
if [ "$(printf '%s\n' "$pids" | grep -c .)" -ne 1 ]; then
  echo "self-test: want exactly one listener on this home's queue, found: ${pids:-none}" >&2; fail=1
fi
pid="$(listener_pid)"
if [ -n "$pid" ]; then
  uids="$(awk '/^Uid:/{print $2, $3, $4, $5}' "/proc/$pid/status" 2>/dev/null)"
  gids="$(awk '/^Gid:/{print $2, $3, $4, $5}' "/proc/$pid/status" 2>/dev/null)"
  if [ "$uids" != "$HOLDER_UID $HOLDER_UID $HOLDER_UID $HOLDER_UID" ] ||
     [ "$gids" != "$HOLDER_GID $HOLDER_GID $HOLDER_GID $HOLDER_GID" ]; then
    echo "self-test: the listener runs as uid '$uids' gid '$gids', not $HOLDER_UID/$HOLDER_GID" >&2; fail=1
  fi
  if [ "$(tr '\0' '\n' < "/proc/$pid/cmdline")" != "$(printf '%s\n' "$BIN" "$QUEUE")" ]; then
    echo "self-test: the listener's command line does not name this home's queue" >&2; fail=1
  fi
  # Who holds the port: only root may see another account's process there.
  if ! sudo -n ss -Htlnp 2>/dev/null | awk -v a="127.0.0.1:$PORT" -v p="pid=$pid," \
       '$4 == a && index($0, p) { f = 1 } END { exit !f }'; then
    echo "self-test: port $PORT on 127.0.0.1 is not held by this home's listener" >&2; fail=1
  fi
fi
# This machine only: the port must be on 127.0.0.1 and on no other address.
others="$(ss -Htln 2>/dev/null | awk -v p="$PORT" '{ n = split($4, a, ":"); if (a[n] == p && $4 != "127.0.0.1:" p) print $4 }')"
if [ -n "$others" ]; then
  echo "self-test: port $PORT is also open on: $others" >&2; fail=1
fi
want="EXCHANGE LISTENER -- dispatches queued: $(ls "$tmp/queue" | grep -c '^dispatch-.*\.txt$') -- acknowledgments received: 0"
if [ "$(ask_port)" != "$want" ]; then
  echo "self-test: the port did not answer as staged" >&2; fail=1
fi
if have_systemd_run && ! systemctl is-active --quiet "$UNIT"; then
  echo "self-test: the unit $UNIT is not active" >&2; fail=1
fi
if ! bash "$ROLL" check; then
  echo "self-test: the house roll does not carry uid $HOLDER_UID" >&2; fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-14 :: bench staged and verified
  ------------------------------------------------------------------
   Exchange:  ~/enginehouse/exchange/   a transmission is queued here

   Something on this machine is listening that you did not start.
   It can be reached from this machine only. The work order shows
   you how to find it, and how to ask it what it is waiting for.

   It is a living process, not a file: it does NOT survive
   `wsl --shutdown`, a reboot, or (on WSL) closing every Ubuntu
   window. Re-run this script to stage it afresh -- that rebuilds
   the exchange with its queue full, and sweeps away anything you
   did there before.
   (bash report-for-duty.sh --reset closes the exchange. The house
   roll stays -- it belongs to the course.)
  ------------------------------------------------------------------

SLIP

# This week's instruments. A bench that lacks one should hear so now rather
# than at the first command.
for t in ss nc timeout; do
  if ! command -v "$t" >/dev/null 2>&1; then
    echo "report-for-duty: note -- $t is not on this bench, and this week needs it." >&2
    echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
  fi
done
if ! command -v netstat >/dev/null 2>&1; then
  echo "report-for-duty: note -- netstat is not on this bench. This week and the"  >&2
  echo "  A Good Sport commission both use it. Install it once with:"              >&2
  echo "    sudo apt install -y net-tools"                                          >&2
fi
