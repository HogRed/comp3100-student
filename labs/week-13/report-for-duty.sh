#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-13: stage the Warden's registry.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# The registry is three papers and nothing else. No process is launched, no
# service is started, nothing here runs in the background and nothing is lost
# if the machine is shut down:
#   ~/enginehouse/registry/                       yours: the registry's room
#     .spare-key                                  a short script, uid 1849,
#                                                 with the setuid bit set
#     auth-ledger.log                             the Warden's log of keys
#                                                 shown at the Guild's doors,
#                                                 uid 1849 (readable by all)
#     visitor-ledger-1851.txt                     the porters' visitor book,
#                                                 yours (readable by all)
#
# The key and the log belong to the archive account (uid 1849, gid 100), so
# making them over to it, and setting the key's setuid bit, needs root. The
# key is a plain `#!/bin/sh` script that prints one line and exits: there is
# no compiled program here, and nothing in it reads, writes or changes
# privilege. Running it does exactly what that sentence says.
#
# All three papers live here as sealed base64 payloads (decode_key,
# decode_auth_ledger, decode_visitor_ledger) and are decoded to a temporary
# directory before anything is touched. The payloads carry the archive account
# only as a number, never by name.
#
# What it touches, and nothing else:
#   ~/enginehouse/registry/                 the three papers above
#   the house roll                          one dormant entry restored, by
#                                           labs/lib/archive-roll.sh, if absent
#
# Never touches Week 10's survey/ or its keeper, Week 11's cabinets/, mnt/,
# recovered/ or ledger-halls/, Week 12's post/, post-works/ or tube-shop/, Week
# 9's src/, Week 2's ~/.ledger-annex, or any other room. It never reads or
# writes the machine's own authentication log: the Warden's log here is a paper
# the story staged, nothing more. The roll entry is the course's, not this
# week's: no week's --reset removes it (bash ../lib/archive-roll.sh teardown, at
# end of term).
#
# Re-running lays the three papers down afresh: the three are removed and made
# again, and workbench/ (your own scratch folder inside the registry, which the
# work order has you make) is left exactly as it is. --reset removes the whole
# registry, workbench/ included.
#
# Sudo: this week asks for the house keys ONCE. Every job that needs root is
# named below before any of it happens, and all of it is done inside the one
# window. If this bench cannot get root, the script says so and stands down
# having staged nothing. --reset needs no root at all.
#
# Works offline. Needs nothing beyond coreutils and sudo.
set -eu

ENGINEHOUSE="$HOME/enginehouse"
REG="$ENGINEHOUSE/registry"
KEY="$REG/.spare-key"                       # 1849:100, 4755
AUTH="$REG/auth-ledger.log"                 # 1849:100, 644
VISITORS="$REG/visitor-ledger-1851.txt"     # yours, 644
HOLDER_UID=1849
HOLDER_GID=100

# --------------------------------------------------------------- the payloads --
# The key: a #!/bin/sh script, kept only here. Its single comment names the
# archive account as a number. The kernel does not honour the setuid bit on a
# script, so it grants nothing; it is a planted paper for an audit to find.
decode_key() { # writes the key script to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgQSBzcGFyZSBrZXkuIEN1dCBieSBubyBvbmUgdGhlIFdhcmRlbiBrbm93czsg
aXRzIG93bmVyIG9uIHRoZSByb2xsIGlzIHVpZCAxODQ5LgplY2hvICJUaGlzIGtleSB3YXMgbmV2
ZXIgY3V0IGJ5IHRoZSBXYXJkZW4uIgpleGl0IDAK
B64
}

# The Warden's log: about two years of key presentations, one line per
# presentation:  date weekday time door key=<holder> event.
decode_auth_ledger() { # writes the Warden's log to $1
  base64 -d > "$1" <<'B64'
IyBUaGUgV2FyZGVuJ3MgcmVnaXN0cnkgbG9nIC0tIG9uZSBsaW5lIHBlciBrZXkgc2hvd24gYXQg
YSBHdWlsZCBkb29yLgojIGRhdGUgd2Vla2RheSB0aW1lIGRvb3Iga2V5IGV2ZW50CjE4NTAtMDEt
MDYgTW9uIDE2OjMwIEJPQVJELVJPT00ga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0wMS0wNyBU
dWUgMDk6NTggTE9ER0Uga2V5PXBvcnRlci0wMyBQUkVTRU5UCjE4NTAtMDEtMTYgVGh1IDA4OjIy
IEVOR0lORS1IQUxMIGtleT1lbmdpbmV3cmlnaHQtMDcgUFJFU0VOVAoxODUwLTAxLTIxIFR1ZSAx
Mjo1MCBSRUdJU1RSWSBrZXk9Y2xlcmstMDIgUFJFU0VOVAoxODUwLTAxLTIyIFdlZCAxMjozMiBD
T01QVVRJTkctUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUwLTAxLTI0IEZy
aSAwOToyNiBSRUdJU1RSWSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUwLTAxLTI3IE1vbiAwOTow
MyBUVUJFLVNIT1Aga2V5PWVuZ2luZXdyaWdodC0wNCBQUkVTRU5UCjE4NTAtMDEtMjggVHVlIDEw
OjIyIFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBSRVNFTlQKMTg1MC0wMS0zMSBGcmkg
MDk6MzcgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUwLTAyLTAzIE1vbiAxMjow
NiBXRVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4NTAtMDItMDYgVGh1IDEyOjIyIFRV
QkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUwLTAyLTExIFR1ZSAxMToz
NSBCT0FSRC1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDItMTIgV2Vk
IDEyOjA5IFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAxIFBSRVNFTlQKMTg1MC0wMi0xNCBGcmkgMTQ6
MzggRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAtMDItMTcgTW9u
IDA4OjQzIEFSQ0hJVkUga2V5PWFyY2hpdmlzdC0wMSBQUkVTRU5UCjE4NTAtMDItMjAgVGh1IDE1
OjEzIFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBSRVNFTlQKMTg1MC0wMi0yMSBGcmkg
MDk6NDYgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUwLTAzLTAzIE1vbiAxMzow
NyBDT01QVVRJTkctUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUwLTAzLTA1
IFdlZCAxMTo0NyBMT0RHRSBrZXk9cG9ydGVyLTAzIFBSRVNFTlQKMTg1MC0wMy0wNiBUaHUgMTE6
MzcgVFVCRS1TSE9QIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDMtMTAgTW9u
IDE3OjAyIExPREdFIGtleT1wb3J0ZXItMDMgUFJFU0VOVAoxODUwLTAzLTE0IEZyaSAxMzo1MSBC
T0FSRC1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDMtMjEgRnJpIDEx
OjU3IEJPQVJELVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MC0wMy0yMSBG
cmkgMTI6MjcgVFVCRS1TSE9QIGtleT1lbmdpbmV3cmlnaHQtMDQgUFJFU0VOVAoxODUwLTAzLTI2
IFdlZCAwOToyNCBXRVNULURPT1Iga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTAtMDQtMDEgVHVl
IDA4OjUyIFRVQkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUwLTA0LTAx
IFR1ZSAxNzoyNyBMT0RHRSBrZXk9cG9ydGVyLTAyIFBSRVNFTlQKMTg1MC0wNC0wMyBUaHUgMDg6
MDQgUkVHSVNUUlkga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0wNC0wOCBUdWUgMTQ6NTYgUkVH
SVNUUlkga2V5PWNsZXJrLTAyIFBSRVNFTlQKMTg1MC0wNC0xMSBGcmkgMTA6MTQgV0VTVC1ET09S
IGtleT1wb3J0ZXItMDMgUFJFU0VOVAoxODUwLTA0LTE0IE1vbiAwOTo0NyBSRUdJU1RSWSBrZXk9
Y2xlcmstMDIgUFJFU0VOVAoxODUwLTA0LTI2IFNhdCAxMTo0OSBBUkNISVZFIGtleT1hcmNoaXZp
c3QtMDEgUFJFU0VOVAoxODUwLTA1LTA1IE1vbiAxNDoyOSBFQVNULUdBTExFUlkga2V5PWVuZ2lu
ZXdyaWdodC0xMSBQUkVTRU5UCjE4NTAtMDUtMDYgVHVlIDEyOjM2IEFSQ0hJVkUga2V5PWFyY2hp
dmlzdC0wMSBQUkVTRU5UCjE4NTAtMDUtMTQgV2VkIDEzOjU1IENPTVBVVElORy1ST09NIGtleT1h
cHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDUtMTUgVGh1IDE1OjU3IExPREdFIGtleT1w
b3J0ZXItMDMgUFJFU0VOVAoxODUwLTA1LTIwIFR1ZSAxMDowMiBUVUJFLVNIT1Aga2V5PWFwcHJl
bnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MC0wNS0yMCBUdWUgMTA6MzcgUkVBRElORy1ST09NIGtl
eT1hcmNoaXZpc3QtMDEgUFJFU0VOVAoxODUwLTA1LTIyIFRodSAxMDo1OSBCT0FSRC1ST09NIGtl
eT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDUtMjQgU2F0IDEwOjEwIFRVQkUtU0hP
UCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MC0wNS0yOCBXZWQgMDc6NDEgUkVHSVNU
Ulkga2V5PWNsZXJrLTAyIFBSRVNFTlQKMTg1MC0wNS0yOSBUaHUgMTA6NTkgQk9BUkQtUk9PTSBr
ZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUwLTA1LTI5IFRodSAxNzozNCBXRVNULURP
T1Iga2V5PXBvcnRlci0wMyBQUkVTRU5UCjE4NTAtMDUtMzAgRnJpIDEyOjA3IEJPQVJELVJPT00g
a2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0wNi0wMiBNb24gMTI6MDAgRU5HSU5FLUhBTEwga2V5
PXdhcmRlbiBQUkVTRU5UCjE4NTAtMDYtMDMgVHVlIDE0OjM5IEJPQVJELVJPT00ga2V5PWNsZXJr
LTAxIFBSRVNFTlQKMTg1MC0wNi0xMCBUdWUgMTM6MTIgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdy
aWdodC0xMSBQUkVTRU5UCjE4NTAtMDYtMTEgV2VkIDEzOjI5IENPTVBVVElORy1ST09NIGtleT1l
bmdpbmV3cmlnaHQtMDkgUFJFU0VOVAoxODUwLTA2LTEyIFRodSAxMjo0NCBCT0FSRC1ST09NIGtl
eT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDYtMTYgTW9uIDEzOjM5IExPREdFIGtl
eT1wb3J0ZXItMDIgUFJFU0VOVAoxODUwLTA2LTE5IFRodSAxMzozOSBCT0FSRC1ST09NIGtleT1h
cHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDYtMjAgRnJpIDEyOjE3IFJFR0lTVFJZIGtl
eT1jbGVyay0wMiBQUkVTRU5UCjE4NTAtMDYtMjEgU2F0IDEzOjExIEJPQVJELVJPT00ga2V5PWNs
ZXJrLTAxIFBSRVNFTlQKMTg1MC0wNi0yMyBNb24gMDg6NTIgRUFTVC1HQUxMRVJZIGtleT1lbmdp
bmV3cmlnaHQtMTEgUFJFU0VOVAoxODUwLTA2LTI0IFR1ZSAxNjowMCBFTkdJTkUtSEFMTCBrZXk9
ZW5naW5ld3JpZ2h0LTA5IFBSRVNFTlQKMTg1MC0wNi0yNiBUaHUgMTI6NTkgRUFTVC1HQUxMRVJZ
IGtleT1lbmdpbmV3cmlnaHQtMTEgUFJFU0VOVAoxODUwLTA2LTMwIE1vbiAxNzozNyBCT0FSRC1S
T09NIGtleT1jbGVyay0wMSBQUkVTRU5UCjE4NTAtMDctMDcgTW9uIDA4OjQ5IEVBU1QtRE9PUiBr
ZXk9cG9ydGVyLTAyIFBSRVNFTlQKMTg1MC0wNy0xMSBGcmkgMDk6MzUgVFVCRS1TSE9QIGtleT1h
cHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDctMTQgTW9uIDA4OjU3IFRVQkUtU0hPUCBr
ZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MC0wNy0xOCBGcmkgMDg6MDAgRU5HSU5FLUhB
TEwga2V5PWVuZ2luZXdyaWdodC0wOSBQUkVTRU5UCjE4NTAtMDctMTkgU2F0IDE0OjE2IFRVQkUt
U0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MC0wNy0yMSBNb24gMTI6NTIgQ09N
UFVUSU5HLVJPT00ga2V5PWVuZ2luZXdyaWdodC0wOSBQUkVTRU5UCjE4NTAtMDctMjMgV2VkIDA4
OjU2IFJFR0lTVFJZIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTAtMDgtMDIgU2F0IDE2OjA5IENP
TVBVVElORy1ST09NIGtleT1jbGVyay0wMyBQUkVTRU5UCjE4NTAtMDgtMDYgV2VkIDEzOjQwIEJP
QVJELVJPT00ga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0wOC0wNyBUaHUgMTQ6NTMgQk9BUkQt
Uk9PTSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUwLTA4LTA4IEZyaSAxMToyMiBFQVNULUdBTExF
Ulkga2V5PWVuZ2luZXdyaWdodC0xMSBQUkVTRU5UCjE4NTAtMDgtMTEgTW9uIDEyOjUxIFRVQkUt
U0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MC0wOC0xMiBUdWUgMTc6MDUgV0VT
VC1ET09SIGtleT1wb3J0ZXItMDMgUFJFU0VOVAoxODUwLTA4LTEzIFdlZCAxNToxMSBCT0FSRC1S
T09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDgtMTQgVGh1IDEwOjE3IEVB
U1QtR0FMTEVSWSBrZXk9ZW5naW5ld3JpZ2h0LTExIFBSRVNFTlQKMTg1MC0wOC0xNiBTYXQgMTE6
MTAgUkVHSVNUUlkga2V5PWNsZXJrLTAyIFBSRVNFTlQKMTg1MC0wOC0yMCBXZWQgMDg6MzYgRU5H
SU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0xMSBQUkVTRU5UCjE4NTAtMDgtMjAgV2VkIDE0OjM4
IENPTVBVVElORy1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTAtMDgtMjcg
V2VkIDExOjA1IEJPQVJELVJPT00ga2V5PWNsZXJrLTAzIFBSRVNFTlQKMTg1MC0wOC0yOSBGcmkg
MTY6MTMgV0VTVC1ET09SIGtleT1wb3J0ZXItMDMgUFJFU0VOVAoxODUwLTA5LTAxIE1vbiAwODoz
MSBUVUJFLVNIT1Aga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAtMDktMDIgVHVlIDE0
OjI2IEVBU1QtR0FMTEVSWSBrZXk9ZW5naW5ld3JpZ2h0LTExIFBSRVNFTlQKMTg1MC0wOS0wNiBT
YXQgMTI6MzMgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUwLTA5LTEwIFdlZCAw
Nzo0NyBSRUdJU1RSWSBrZXk9d2FyZGVuIFBSRVNFTlQKMTg1MC0wOS0xMSBUaHUgMTU6MjQgVFVC
RS1TSE9QIGtleT1lbmdpbmV3cmlnaHQtMDcgUFJFU0VOVAoxODUwLTA5LTEzIFNhdCAxMDoyNiBU
VUJFLVNIT1Aga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAtMDktMTUgTW9uIDA4OjQ4
IEJPQVJELVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MC0wOS0xNSBNb24g
MTU6NTQgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAtMDktMTkg
RnJpIDEwOjMzIFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MC0wOS0y
NCBXZWQgMDk6MDYgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAt
MDktMjUgVGh1IDA4OjQzIEVOR0lORS1IQUxMIGtleT1lbmdpbmV3cmlnaHQtMDQgUFJFU0VOVAox
ODUwLTA5LTI5IE1vbiAxMDoyNSBMT0RHRSBrZXk9cG9ydGVyLTAzIFBSRVNFTlQKMTg1MC0xMC0w
MyBGcmkgMTE6MzUgUkVHSVNUUlkga2V5PWNsZXJrLTAyIFBSRVNFTlQKMTg1MC0xMC0wNCBTYXQg
MDc6MzkgUkVBRElORy1ST09NIGtleT1hcmNoaXZpc3QtMDEgUFJFU0VOVAoxODUwLTEwLTA2IE1v
biAwODozMSBDT01QVVRJTkctUk9PTSBrZXk9ZW5naW5ld3JpZ2h0LTA5IFBSRVNFTlQKMTg1MC0x
MC0wNyBUdWUgMTM6NDEgQ09NUFVUSU5HLVJPT00ga2V5PWNsZXJrLTAzIFBSRVNFTlQKMTg1MC0x
MC0wNyBUdWUgMTQ6NDcgQ09NUFVUSU5HLVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNF
TlQKMTg1MC0xMC0xMyBNb24gMTA6MTAgQ09NUFVUSU5HLVJPT00ga2V5PWVuZ2luZXdyaWdodC0w
OSBQUkVTRU5UCjE4NTAtMTAtMTQgVHVlIDE1OjMxIFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0
LTA3IFBSRVNFTlQKMTg1MC0xMC0xNyBGcmkgMTY6MTIgV0VTVC1ET09SIGtleT1wb3J0ZXItMDMg
UFJFU0VOVAoxODUwLTEwLTI5IFdlZCAxNjoxOCBSRUdJU1RSWSBrZXk9Y2xlcmstMDIgUFJFU0VO
VAoxODUwLTEwLTMxIEZyaSAxNTozOCBFQVNULUdBTExFUlkga2V5PXdhcmRlbiBQUkVTRU5UCjE4
NTAtMTEtMDMgTW9uIDE3OjIwIENPTVBVVElORy1ST09NIGtleT1jbGVyay0wMyBQUkVTRU5UCjE4
NTAtMTEtMDQgVHVlIDEwOjIyIFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQK
MTg1MC0xMS0wNCBUdWUgMTI6MTggQ09NUFVUSU5HLVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVy
IFBSRVNFTlQKMTg1MC0xMS0wNyBGcmkgMTI6MTUgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDIgUFJF
U0VOVAoxODUwLTExLTExIFR1ZSAxNjo0NiBMT0RHRSBrZXk9cG9ydGVyLTAxIFBSRVNFTlQKMTg1
MC0xMS0xMiBXZWQgMDk6MjcgVFVCRS1TSE9QIGtleT1lbmdpbmV3cmlnaHQtMDcgUFJFU0VOVAox
ODUwLTExLTEyIFdlZCAxMjoyNCBDT01QVVRJTkctUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIg
UFJFU0VOVAoxODUwLTExLTEzIFRodSAxNToxNCBCT0FSRC1ST09NIGtleT1jbGVyay0wMiBQUkVT
RU5UCjE4NTAtMTEtMTcgTW9uIDEzOjA2IFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBS
RVNFTlQKMTg1MC0xMS0xOSBXZWQgMTA6NDkgVFVCRS1TSE9QIGtleT1hcHByZW50aWNlLW1hc3Rl
ciBQUkVTRU5UCjE4NTAtMTEtMjAgVGh1IDE1OjE2IEVOR0lORS1IQUxMIGtleT1lbmdpbmV3cmln
aHQtMDQgUFJFU0VOVAoxODUwLTExLTIxIEZyaSAxNzoyOCBFQVNULUdBTExFUlkga2V5PXdhcmRl
biBQUkVTRU5UCjE4NTAtMTEtMjQgTW9uIDEwOjA1IExPREdFIGtleT1wb3J0ZXItMDMgUFJFU0VO
VAoxODUwLTExLTI0IE1vbiAxMTo0MiBCT0FSRC1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQ
UkVTRU5UCjE4NTAtMTEtMjUgVHVlIDE0OjU2IFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAyIFBSRVNF
TlQKMTg1MC0xMS0yNyBUaHUgMTA6MTkgUkVBRElORy1ST09NIGtleT1hcmNoaXZpc3QtMDEgUFJF
U0VOVAoxODUwLTExLTI5IFNhdCAxMToxNyBSRUdJU1RSWSBrZXk9Y2xlcmstMDEgUFJFU0VOVAox
ODUwLTEyLTAzIFdlZCAxMjoyNSBCT0FSRC1ST09NIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTAt
MTItMDggTW9uIDA3OjM3IFJFR0lTVFJZIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTAtMTItMTUg
TW9uIDE0OjM1IEJPQVJELVJPT00ga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0xMi0xNiBUdWUg
MTA6NDkgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTAtMTItMTgg
VGh1IDExOjA5IEJPQVJELVJPT00ga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MC0xMi0yNyBTYXQg
MTM6NTEgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDIgUFJFU0VOVAoxODUwLTEyLTI5IE1vbiAxMjox
MCBCT0FSRC1ST09NIGtleT1jbGVyay0wMSBQUkVTRU5UCjE4NTAtMTItMzEgV2VkIDA4OjUxIFRV
QkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBSRVNFTlQKMTg1MS0wMS0wNiBUdWUgMTA6NTkg
Q09NUFVUSU5HLVJPT00ga2V5PWVuZ2luZXdyaWdodC0wOSBQUkVTRU5UCjE4NTEtMDEtMDYgVHVl
IDExOjE5IENPTVBVVElORy1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTEt
MDEtMDggVGh1IDA3OjQ5IEVOR0lORS1IQUxMIGtleT1lbmdpbmV3cmlnaHQtMDQgUFJFU0VOVAox
ODUxLTAxLTE3IFNhdCAwOToxOSBMT0RHRSBrZXk9cG9ydGVyLTAyIFBSRVNFTlQKMTg1MS0wMS0y
MCBUdWUgMTA6NTIgTE9ER0Uga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDEtMjEgV2VkIDEw
OjA2IFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAxIFBSRVNFTlQKMTg1MS0wMS0yMiBUaHUgMTA6MDgg
Qk9BUkQtUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUxLTAxLTIzIEZyaSAx
MDo0MCBSRUdJU1RSWSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUxLTAxLTI2IE1vbiAxMjowNCBF
QVNULUdBTExFUlkga2V5PXdhcmRlbiBQUkVTRU5UCjE4NTEtMDItMDMgVHVlIDE0OjI4IEVOR0lO
RS1IQUxMIGtleT1lbmdpbmV3cmlnaHQtMDkgUFJFU0VOVAoxODUxLTAyLTA0IFdlZCAwOTozMiBD
T01QVVRJTkctUk9PTSBrZXk9ZW5naW5ld3JpZ2h0LTA5IFBSRVNFTlQKMTg1MS0wMi0wNSBUaHUg
MTI6MjIgQ09NUFVUSU5HLVJPT00ga2V5PWVuZ2luZXdyaWdodC0wOSBQUkVTRU5UCjE4NTEtMDIt
MDcgU2F0IDE3OjM3IFJFR0lTVFJZIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTEtMDItMDkgTW9u
IDE2OjMyIEVOR0lORS1IQUxMIGtleT1lbmdpbmV3cmlnaHQtMDcgUFJFU0VOVAoxODUxLTAyLTEw
IFR1ZSAxMTo0MyBFTkdJTkUtSEFMTCBrZXk9ZW5naW5ld3JpZ2h0LTA5IFBSRVNFTlQKMTg1MS0w
Mi0xMSBXZWQgMTE6MzQgRUFTVC1HQUxMRVJZIGtleT1lbmdpbmV3cmlnaHQtMTEgUFJFU0VOVAox
ODUxLTAyLTI1IFdlZCAxMjozNSBFQVNULUdBTExFUlkga2V5PWVuZ2luZXdyaWdodC0xMSBQUkVT
RU5UCjE4NTEtMDMtMDIgTW9uIDExOjQwIEJPQVJELVJPT00ga2V5PWNsZXJrLTAzIFBSRVNFTlQK
MTg1MS0wMy0wNCBXZWQgMTQ6MDYgQVJDSElWRSBrZXk9YXJjaGl2aXN0LTAxIFBSRVNFTlQKMTg1
MS0wMy0xMCBUdWUgMTU6MzcgVFVCRS1TSE9QIGtleT1lbmdpbmV3cmlnaHQtMDcgUFJFU0VOVAox
ODUxLTAzLTExIFdlZCAwOTowMiBXRVNULURPT1Iga2V5PXBvcnRlci0wMyBQUkVTRU5UCjE4NTEt
MDMtMTQgU2F0IDE3OjE1IFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1
MS0wMy0xNyBUdWUgMDc6MzAgRUFTVC1ET09SIGtleT1wb3J0ZXItMDIgUFJFU0VOVAoxODUxLTAz
LTE3IFR1ZSAxMToxNyBDT01QVVRJTkctUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VO
VAoxODUxLTAzLTE4IFdlZCAxNjo0MiBMT0RHRSBrZXk9cG9ydGVyLTAzIFBSRVNFTlQKMTg1MS0w
My0yNSBXZWQgMTI6MjggVFVCRS1TSE9QIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4
NTEtMDQtMDEgV2VkIDA4OjE2IExPREdFIGtleT1wb3J0ZXItMDIgUFJFU0VOVAoxODUxLTA0LTAy
IFRodSAxNzoxMiBSRUFESU5HLVJPT00ga2V5PWFyY2hpdmlzdC0wMSBQUkVTRU5UCjE4NTEtMDQt
MDYgTW9uIDEwOjA0IEJPQVJELVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1
MS0wNC0wNiBNb24gMTU6MjkgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5U
CjE4NTEtMDQtMTAgRnJpIDEyOjMyIFJFR0lTVFJZIGtleT13YXJkZW4gUFJFU0VOVAoxODUxLTA0
LTEzIE1vbiAxNToxMSBBUkNISVZFIGtleT1hcmNoaXZpc3QtMDEgUFJFU0VOVAoxODUxLTA0LTE0
IFR1ZSAwOToxMSBXRVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4NTEtMDQtMjMgVGh1
IDEwOjIxIFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAxIFBSRVNFTlQKMTg1MS0wNC0yNCBGcmkgMTc6
MDUgUkVHSVNUUlkga2V5PWNsZXJrLTAyIFBSRVNFTlQKMTg1MS0wNC0yNSBTYXQgMTM6MDAgTE9E
R0Uga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDQtMjggVHVlIDEwOjA3IEJPQVJELVJPT00g
a2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MS0wNC0zMCBUaHUgMTM6MDkgQ09NUFVU
SU5HLVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MS0wNS0wNCBNb24gMDk6
MDggRUFTVC1HQUxMRVJZIGtleT13YXJkZW4gUFJFU0VOVAoxODUxLTA1LTA1IFR1ZSAxMzo1MSBC
T0FSRC1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTEtMDUtMTIgVHVlIDA4
OjMzIEJPQVJELVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MS0wNS0xMyBX
ZWQgMTI6MTcgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTEtMDUt
MTMgV2VkIDEzOjE3IFRVQkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUx
LTA1LTE1IEZyaSAxMjo1OCBCT0FSRC1ST09NIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTEtMDUt
MTggTW9uIDExOjI4IFRVQkUtU0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBSRVNFTlQKMTg1MS0w
NS0yMSBUaHUgMTA6NTEgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4
NTEtMDUtMjIgRnJpIDExOjEyIFRVQkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VO
VAoxODUxLTA1LTMwIFNhdCAxMTo1OSBFTkdJTkUtSEFMTCBrZXk9d2FyZGVuIFBSRVNFTlQKMTg1
MS0wNi0wMSBNb24gMDg6NDUgQk9BUkQtUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VO
VAoxODUxLTA2LTA4IE1vbiAwOTowOCBSRUdJU1RSWSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUx
LTA2LTA5IFR1ZSAxMToxOSBDT01QVVRJTkctUk9PTSBrZXk9Y2xlcmstMDMgUFJFU0VOVAoxODUx
LTA2LTEwIFdlZCAwOTo0OCBFQVNULURPT1Iga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDYt
MTEgVGh1IDA4OjA5IENPTVBVVElORy1ST09NIGtleT1lbmdpbmV3cmlnaHQtMDkgUFJFU0VOVAox
ODUxLTA2LTEyIEZyaSAxNjo1MyBUVUJFLVNIT1Aga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5U
CjE4NTEtMDYtMTYgVHVlIDA4OjA1IFJFR0lTVFJZIGtleT13YXJkZW4gUFJFU0VOVAoxODUxLTA2
LTIyIE1vbiAxMjoyMyBFQVNULURPT1Iga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDYtMjMg
VHVlIDEzOjE1IFRVQkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUxLTA2
LTMwIFR1ZSAxMzoxNiBUVUJFLVNIT1Aga2V5PWVuZ2luZXdyaWdodC0wNyBQUkVTRU5UCjE4NTEt
MDctMDEgV2VkIDExOjI5IEJPQVJELVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQK
MTg1MS0wNy0wMSBXZWQgMTM6MzAgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdyaWdodC0wOSBQUkVT
RU5UCjE4NTEtMDctMDIgVGh1IDE2OjQxIExPREdFIGtleT1wb3J0ZXItMDIgUFJFU0VOVAoxODUx
LTA3LTA4IFdlZCAxODozMiBXRVNULURPT1Iga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDct
MTYgVGh1IDE1OjAyIFJFQURJTkctUk9PTSBrZXk9YXJjaGl2aXN0LTAxIFBSRVNFTlQKMTg1MS0w
Ny0xNyBGcmkgMjE6MDEgTE9ER0Uga2V5PXBvcnRlci0wMiBQUkVTRU5UCjE4NTEtMDctMjEgVHVl
IDA5OjEzIEJPQVJELVJPT00ga2V5PWNsZXJrLTAxIFBSRVNFTlQKMTg1MS0wNy0yMiBXZWQgMjA6
NTEgRUFTVC1ET09SIGtleT1wb3J0ZXItMDEgUFJFU0VOVAoxODUxLTA3LTIzIFRodSAxMTowNiBU
VUJFLVNIT1Aga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MS0wNy0yMyBUaHUgMTc6
MzggQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUxLTA3LTI5IFdlZCAxMjo0MyBC
T0FSRC1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTEtMDctMjkgV2VkIDE4
OjI0IFJFQURJTkctUk9PTSBrZXk9MTg0OSBQUkVTRU5UCjE4NTEtMDctMjkgV2VkIDIwOjM4IExP
REdFIGtleT1jbGVyay0wMiBQUkVTRU5UCjE4NTEtMDgtMDEgU2F0IDEyOjE2IExPREdFIGtleT1w
b3J0ZXItMDMgUFJFU0VOVAoxODUxLTA4LTAzIE1vbiAwODozMyBXRVNULURPT1Iga2V5PXBvcnRl
ci0wMyBQUkVTRU5UCjE4NTEtMDgtMDcgRnJpIDEyOjE2IFJFR0lTVFJZIGtleT1jbGVyay0wMiBQ
UkVTRU5UCjE4NTEtMDgtMDcgRnJpIDE4OjI5IFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAxIFBSRVNF
TlQKMTg1MS0wOC0wNyBGcmkgMTg6MzMgUkVBRElORy1ST09NIGtleT0xODQ5IFBSRVNFTlQKMTg1
MS0wOC0xMCBNb24gMTQ6MjkgQk9BUkQtUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VO
VAoxODUxLTA4LTEwIE1vbiAxNTo1OSBFQVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4
NTEtMDgtMTIgV2VkIDE5OjAyIFJFQURJTkctUk9PTSBrZXk9MTg0OSBQUkVTRU5UCjE4NTEtMDgt
MTMgVGh1IDA4OjUzIFJFR0lTVFJZIGtleT1jbGVyay0wMSBQUkVTRU5UCjE4NTEtMDgtMTggVHVl
IDA3OjU4IFdFU1QtRE9PUiBrZXk9cG9ydGVyLTAzIFBSRVNFTlQKMTg1MS0wOC0yMiBTYXQgMTE6
MzIgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDMgUFJFU0VOVAoxODUxLTA4LTI2IFdlZCAxOTo0NCBX
RVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4NTEtMDgtMjggRnJpIDA3OjQ4IFRVQkUt
U0hPUCBrZXk9ZW5naW5ld3JpZ2h0LTA0IFBSRVNFTlQKMTg1MS0wOC0yOCBGcmkgMDk6MDUgQ09N
UFVUSU5HLVJPT00ga2V5PWFwcHJlbnRpY2UtbWFzdGVyIFBSRVNFTlQKMTg1MS0wOC0yOCBGcmkg
MTg6MTcgUkVBRElORy1ST09NIGtleT0xODQ5IFBSRVNFTlQKMTg1MS0wOC0yOCBGcmkgMTg6NDEg
V0VTVC1ET09SIGtleT1wb3J0ZXItMDEgUFJFU0VOVAoxODUxLTA4LTMxIE1vbiAxMTowNCBDT01Q
VVRJTkctUk9PTSBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAoxODUxLTA5LTAxIFR1ZSAx
MDoxMiBSRUdJU1RSWSBrZXk9Y2xlcmstMDIgUFJFU0VOVAoxODUxLTA5LTAyIFdlZCAwNzo0MSBS
RUdJU1RSWSBrZXk9Y2xlcmstMDEgUFJFU0VOVAoxODUxLTA5LTA0IEZyaSAxOToxMSBSRUFESU5H
LVJPT00ga2V5PTE4NDkgUFJFU0VOVAoxODUxLTA5LTA0IEZyaSAyMTowMyBMT0RHRSBrZXk9cG9y
dGVyLTAyIFBSRVNFTlQKMTg1MS0wOS0wOSBXZWQgMDc6MzAgRU5HSU5FLUhBTEwga2V5PWVuZ2lu
ZXdyaWdodC0wNyBQUkVTRU5UCjE4NTEtMDktMDkgV2VkIDE4OjU2IEVBU1QtRE9PUiBrZXk9cG9y
dGVyLTAyIFBSRVNFTlQKMTg1MS0wOS0xMCBUaHUgMTA6MTkgRU5HSU5FLUhBTEwga2V5PWVuZ2lu
ZXdyaWdodC0wNCBQUkVTRU5UCjE4NTEtMDktMTEgRnJpIDExOjI5IEVOR0lORS1IQUxMIGtleT13
YXJkZW4gUFJFU0VOVAoxODUxLTA5LTE2IFdlZCAwNzo1OSBFTkdJTkUtSEFMTCBrZXk9ZW5naW5l
d3JpZ2h0LTA0IFBSRVNFTlQKMTg1MS0wOS0xNiBXZWQgMDk6MzIgVFVCRS1TSE9QIGtleT1hcHBy
ZW50aWNlLW1hc3RlciBQUkVTRU5UCjE4NTEtMDktMTYgV2VkIDE5OjIyIFJFQURJTkctUk9PTSBr
ZXk9MTg0OSBTRVNTSU9OLU9QRU4KMTg1MS0wOS0xNiBXZWQgMjA6MDQgUkVBRElORy1ST09NIGtl
eT0xODQ5IFNFU1NJT04tQ0xPU0UKMTg1MS0wOS0xNiBXZWQgMjA6MjggRUFTVC1ET09SIGtleT1j
bGVyay0wMiBQUkVTRU5UCjE4NTEtMDktMTcgVGh1IDA5OjEwIFdFU1QtRE9PUiBrZXk9cG9ydGVy
LTAzIFBSRVNFTlQKMTg1MS0wOS0xOCBGcmkgMTc6MzAgRUFTVC1HQUxMRVJZIGtleT1lbmdpbmV3
cmlnaHQtMTEgUFJFU0VOVAoxODUxLTA5LTE4IEZyaSAxOTowNyBSRUFESU5HLVJPT00ga2V5PTE4
NDkgU0VTU0lPTi1PUEVOCjE4NTEtMDktMTggRnJpIDE5OjQ0IFJFQURJTkctUk9PTSBrZXk9MTg0
OSBTRVNTSU9OLUNMT1NFCjE4NTEtMDktMTggRnJpIDE5OjUzIFdFU1QtRE9PUiBrZXk9cG9ydGVy
LTAyIFBSRVNFTlQKMTg1MS0wOS0xOSBTYXQgMDc6NDcgRUFTVC1ET09SIGtleT1wb3J0ZXItMDEg
UFJFU0VOVAoxODUxLTA5LTIzIFdlZCAxOTozNiBSRUFESU5HLVJPT00ga2V5PTE4NDkgU0VTU0lP
Ti1PUEVOCjE4NTEtMDktMjMgV2VkIDIwOjAxIFJFQURJTkctUk9PTSBrZXk9MTg0OSBTRVNTSU9O
LUNMT1NFCjE4NTEtMDktMjQgVGh1IDEwOjE2IEJPQVJELVJPT00ga2V5PWNsZXJrLTAyIFBSRVNF
TlQKMTg1MS0wOS0yNSBGcmkgMjE6MTQgV0VTVC1ET09SIGtleT1wb3J0ZXItMDIgUFJFU0VOVAox
ODUxLTA5LTI2IFNhdCAxNDowNSBFTkdJTkUtSEFMTCBrZXk9ZW5naW5ld3JpZ2h0LTA3IFBSRVNF
TlQKMTg1MS0wOS0yOCBNb24gMTM6NTUgQ09NUFVUSU5HLVJPT00ga2V5PWFwcHJlbnRpY2UtbWFz
dGVyIFBSRVNFTlQKMTg1MS0wOS0zMCBXZWQgMTQ6MjIgRU5HSU5FLUhBTEwga2V5PWVuZ2luZXdy
aWdodC0xMSBQUkVTRU5UCjE4NTEtMTAtMDEgVGh1IDA5OjAxIFdFU1QtRE9PUiBrZXk9cG9ydGVy
LTAxIFBSRVNFTlQKMTg1MS0xMC0wMyBTYXQgMTA6NTkgQk9BUkQtUk9PTSBrZXk9Y2xlcmstMDIg
UFJFU0VOVAoxODUxLTEwLTA1IE1vbiAxMToxNSBMT0RHRSBrZXk9cG9ydGVyLTAyIFBSRVNFTlQK
MTg1MS0xMC0wOCBUaHUgMTM6MTEgV0VTVC1ET09SIGtleT1wb3J0ZXItMDIgUFJFU0VOVAoxODUx
LTEwLTA5IEZyaSAxMDoyOCBDT01QVVRJTkctUk9PTSBrZXk9ZW5naW5ld3JpZ2h0LTA5IFBSRVNF
TlQKMTg1MS0xMC0wOSBGcmkgMjE6MjIgV0VTVC1ET09SIGtleT1wb3J0ZXItMDIgUFJFU0VOVAox
ODUxLTEwLTE0IFdlZCAxNDozMiBFTkdJTkUtSEFMTCBrZXk9ZW5naW5ld3JpZ2h0LTExIFBSRVNF
TlQKMTg1MS0xMC0xNCBXZWQgMTk6NDEgUkVBRElORy1ST09NIGtleT0xODQ5IFNFU1NJT04tT1BF
TgoxODUxLTEwLTE0IFdlZCAyMDoyMiBSRUFESU5HLVJPT00ga2V5PTE4NDkgU0VTU0lPTi1DTE9T
RQoxODUxLTEwLTE0IFdlZCAyMToyNyBFQVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4
NTEtMTAtMTUgVGh1IDEzOjI5IENPTVBVVElORy1ST09NIGtleT1hcHByZW50aWNlLW1hc3RlciBQ
UkVTRU5UCjE4NTEtMTAtMTUgVGh1IDE3OjM1IEJPQVJELVJPT00ga2V5PWNsZXJrLTAyIFBSRVNF
TlQKMTg1MS0xMC0yMSBXZWQgMTk6MzQgV0VTVC1ET09SIGtleT1wb3J0ZXItMDMgUFJFU0VOVAox
ODUxLTEwLTIyIFRodSAwODozMSBXRVNULURPT1Iga2V5PXBvcnRlci0wMSBQUkVTRU5UCjE4NTEt
MTAtMjIgVGh1IDExOjI4IFRVQkUtU0hPUCBrZXk9YXBwcmVudGljZS1tYXN0ZXIgUFJFU0VOVAox
ODUxLTEwLTIzIEZyaSAyMDowMyBSRUFESU5HLVJPT00ga2V5PTE4NDkgU0VTU0lPTi1PUEVOCjE4
NTEtMTAtMjMgRnJpIDIwOjQ3IFJFQURJTkctUk9PTSBrZXk9MTg0OSBTRVNTSU9OLUNMT1NFCjE4
NTEtMTAtMjcgVHVlIDExOjExIENPTVBVVElORy1ST09NIGtleT1lbmdpbmV3cmlnaHQtMDkgUFJF
U0VOVAoxODUxLTEwLTI4IFdlZCAxMzoyNSBUVUJFLVNIT1Aga2V5PWFwcHJlbnRpY2UtbWFzdGVy
IFBSRVNFTlQKMTg1MS0xMC0zMCBGcmkgMTU6MjkgQ09NUFVUSU5HLVJPT00ga2V5PWNsZXJrLTAz
IFBSRVNFTlQKMTg1MS0xMC0zMCBGcmkgMTk6MTQgUkVBRElORy1ST09NIGtleT0xODQ5IFNFU1NJ
T04tT1BFTgoxODUxLTEwLTMwIEZyaSAxOTo1OCBSRUFESU5HLVJPT00ga2V5PTE4NDkgU0VTU0lP
Ti1DTE9TRQoxODUxLTEwLTMxIFNhdCAxMDoxNSBMT0RHRSBrZXk9cG9ydGVyLTAzIFBSRVNFTlQK
B64
}

# The porters' visitor book: the reading room's Wednesday and Friday visits,
# each with an arrival and a departure.
decode_visitor_ledger() { # writes the porters' visitor book to $1
  base64 -d > "$1" <<'B64'
IyBQb3J0ZXJzJyBsb2RnZSAtLSB2aXNpdG9ycyB0byB0aGUgcmVhZGluZyByb29tLCBjb3BpZWQg
ZnJvbSB0aGUgcGFwZXIgYm9vay4KIyBkYXRlIHdlZWtkYXkgaW4gdGltZSBvdXQgdGltZSB2aXNp
dG9yCjE4NTEtMDctMDEgV2VkIGluIDE2OjA3IG91dCAxODowOCBLdXJlb3MKMTg1MS0wNy0wMyBG
cmkgaW4gMTc6MjYgb3V0IDE4OjEzIEt1cmVvcwoxODUxLTA3LTA4IFdlZCBpbiAxNjo1NyBvdXQg
MjA6MjEgS3VyZW9zCjE4NTEtMDctMTUgV2VkIGluIDE1OjMzIG91dCAyMDozMSBLdXJlb3MKMTg1
MS0wNy0xNyBGcmkgaW4gMTU6NTAgb3V0IDIxOjAwIEt1cmVvcwoxODUxLTA3LTIyIFdlZCBpbiAx
Njo1MCBvdXQgMjA6NDEgS3VyZW9zCjE4NTEtMDctMjkgV2VkIGluIDE2OjM1IG91dCAxOTo0MCBL
dXJlb3MKMTg1MS0wNy0zMSBGcmkgaW4gMTY6MDAgb3V0IDE4OjI3IEt1cmVvcwoxODUxLTA4LTA1
IFdlZCBpbiAxNTozNyBvdXQgMjA6MDAgS3VyZW9zCjE4NTEtMDgtMDcgRnJpIGluIDE3OjEwIG91
dCAxOToyNSBLdXJlb3MKMTg1MS0wOC0xMiBXZWQgaW4gMTY6MjAgb3V0IDIwOjA1IEt1cmVvcwox
ODUxLTA4LTE0IEZyaSBpbiAxNTo1MyBvdXQgMjA6MjcgS3VyZW9zCjE4NTEtMDgtMjEgRnJpIGlu
IDE3OjE2IG91dCAxODo0NCBLdXJlb3MKMTg1MS0wOC0yNiBXZWQgaW4gMTY6NTYgb3V0IDE5OjQ3
IEt1cmVvcwoxODUxLTA4LTI4IEZyaSBpbiAxNzowNSBvdXQgMTk6MzUgS3VyZW9zCjE4NTEtMDkt
MDIgV2VkIGluIDE3OjI3IG91dCAxODo0MiBLdXJlb3MKMTg1MS0wOS0wNCBGcmkgaW4gMTY6NTAg
b3V0IDIwOjE1IEt1cmVvcwoxODUxLTA5LTA5IFdlZCBpbiAxNzoyNyBvdXQgMTk6MDQgS3VyZW9z
CjE4NTEtMDktMTEgRnJpIGluIDE2OjA0IG91dCAxODo0OCBLdXJlb3MKMTg1MS0wOS0xNiBXZWQg
aW4gMTY6NDggb3V0IDIwOjM1IEt1cmVvcwoxODUxLTA5LTE4IEZyaSBpbiAxNzowMiBvdXQgMTk6
NTggS3VyZW9zCjE4NTEtMDktMjMgV2VkIGluIDE2OjQwIG91dCAyMDoxMiBLdXJlb3MKMTg1MS0w
OS0yNSBGcmkgaW4gMTc6Mjggb3V0IDIwOjExIEt1cmVvcwoxODUxLTEwLTAyIEZyaSBpbiAxNToz
MSBvdXQgMjA6NTUgS3VyZW9zCjE4NTEtMTAtMDcgV2VkIGluIDE1OjUwIG91dCAyMDo0MiBLdXJl
b3MKMTg1MS0xMC0wOSBGcmkgaW4gMTU6Mzggb3V0IDE4OjM3IEt1cmVvcwoxODUxLTEwLTE0IFdl
ZCBpbiAxNzoxNSBvdXQgMjA6NTAgS3VyZW9zCjE4NTEtMTAtMTYgRnJpIGluIDE3OjQwIG91dCAx
OToyOCBLdXJlb3MKMTg1MS0xMC0yMSBXZWQgaW4gMTY6NTcgb3V0IDIwOjIwIEt1cmVvcwoxODUx
LTEwLTIzIEZyaSBpbiAxNzozMCBvdXQgMjE6MTAgS3VyZW9zCjE4NTEtMTAtMjggV2VkIGluIDE2
OjEyIG91dCAyMDo1MCBLdXJlb3MKMTg1MS0xMC0zMCBGcmkgaW4gMTc6MjUgb3V0IDIwOjQ0IEt1
cmVvcwo=
B64
}

HERE="$(cd "$(dirname "$0")" && pwd)"
ROLL="$HERE/../lib/archive-roll.sh"
LC_ALL=C          # stat's file-type words are read back in English
export LC_ALL

# --------------------------------------------------------------- root guard --
# A classic move (Weeks 1 and 3 both log it): run the whole script under sudo
# instead of letting it ask for root itself. That stages root's home, not
# yours, and every check this week reads from your own bench. Refuse before
# anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This script asks for the house keys itself, once, exactly when"   >&2
  echo "  it needs them -- running it under sudo stages root's home"        >&2
  echo "  directory instead of yours, and nothing this week will find it"   >&2
  echo "  there. Nothing has been staged. Run it again as yourself:"        >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  # No root. The key and the log belong to uid 1849, but they sit in a room
  # you own, and what lets a file be removed is the write bit of the directory
  # it is in, not who owns the file.
  # A student may stop with a folder at u=x or u=rw (Task 1 step 5): give the owner
  # back full rights inside workbench/ first, or rm -rf would stop half way.
  chmod -R u+rwx "$REG/workbench" 2>/dev/null || true
  rm -rf "$REG"
  # enginehouse/ is shared. It goes only if this week leaves it empty and
  # Week 1's own marker is gone too -- the guard the other weeks use.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Registry struck. The key, the Warden's log, the porters' book and your"
  echo "workbench/ are gone."
  if [ -d "$ENGINEHOUSE" ]; then
    echo "~/enginehouse still holds other weeks' papers; they were not touched."
  fi
  echo "The house roll is untouched -- that entry belongs to the course and not"
  echo "to this week, and later work still rests on it. (bash ../lib/archive-roll.sh"
  echo "teardown removes it, once, at the end of term.)"
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------ what still wants doing
# Worked out before anything root happens, so a bench that cannot get root is
# left as it was found rather than half-staged.
need_roll=0
bash "$ROLL" check || need_roll=1

# ------------------------------------------------------------ the three papers
# Decoded before the root window, so a bench that cannot decode them is left
# exactly as it was found.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_key            "$tmp/spare-key"
decode_auth_ledger    "$tmp/auth-ledger.log"
decode_visitor_ledger "$tmp/visitor-ledger-1851.txt"
for f in spare-key auth-ledger.log visitor-ledger-1851.txt; do
  if [ ! -s "$tmp/$f" ]; then
    echo "report-for-duty: a sealed paper ($f) did not decode. Nothing has been" >&2
    echo "  staged. Take this to your instructor rather than working around it." >&2
    exit 1
  fi
done

# -------------------------------------------------------------- the house keys
stand_down() {
  echo "report-for-duty: this bench cannot get root -- either sudo is not"      >&2
  echo "  installed, or it wants a password prompt this session has no"         >&2
  echo "  terminal to give. Nothing has been staged: the registry is exactly"   >&2
  echo "  as you found it. Take this to your instructor rather than working"    >&2
  echo "  around it."                                                           >&2
  exit 1
}

echo "Before the registry can be staged, the house keys are wanted. They are"
echo "asked for once, for the whole of the following, and for nothing else:"
echo
if [ "$need_roll" -ne 0 ]; then
  echo "  * The roll. One dormant entry is restored to it (useradd, by"
  echo "    labs/lib/archive-roll.sh): no password, no home directory, no"
  echo "    login shell -- nothing can log in as it. Reversible by name, and"
  echo "    shared with later weeks, so no week's --reset takes it away."
fi
echo "  * Two papers are made over to uid $HOLDER_UID (chown): the spare key"
echo "    .spare-key and the Warden's log auth-ledger.log. Nothing else is."
echo "  * The spare key has its setuid bit set (chmod 4755), so that it lists"
echo "    as -rwsr-xr-x. It is a script that prints one line and exits; the"
echo "    kernel does not give a script anyone else's privileges. Nothing is"
echo "    compiled and nothing is started."
echo "  * The porters' visitor book is laid down as yours; the room that holds"
echo "    all three, ~/enginehouse/registry/, is yours too. No root is needed"
echo "    for either of those."
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
    echo "report-for-duty: the house roll was not restored, so the registry has" >&2
    echo "  been left unstaged rather than half-staged. The message above is"    >&2
    echo "  the roll office's -- take it to your instructor."                    >&2
    exit 1
  fi
  echo
fi

# ----------------------------------------------------------------- the registry
# The three old papers are yours to remove, no root needed (see --reset).
# Nothing else in the room is touched: workbench/ is the student's.
mkdir -p "$REG"
rm -f "$KEY" "$AUTH" "$VISITORS"
chmod 755 "$REG"
install -m 644 "$tmp/visitor-ledger-1851.txt" "$VISITORS"
sudo install -o "$HOLDER_UID" -g "$HOLDER_GID" -m 644 "$tmp/auth-ledger.log" "$AUTH"
sudo install -o "$HOLDER_UID" -g "$HOLDER_GID" -m 755 "$tmp/spare-key" "$KEY"
# chown clears a setuid bit, so the bit is set last.
sudo chmod 4755 "$KEY"

# ------------------------------------------------------------------ self-test
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
expect "$REG"      directory       "$me"                      755
expect "$KEY"      "regular file"  "$HOLDER_UID:$HOLDER_GID"  4755
expect "$AUTH"     "regular file"  "$HOLDER_UID:$HOLDER_GID"  644
expect "$VISITORS" "regular file"  "$me"                      644
# The three papers are checked above. Anything else in registry/ is the
# student's own (an editor's swap file, a saved tally): name it, never fail on it.
_extra="$(ls -A "$REG" | grep -vxE 'workbench|\.spare-key|auth-ledger\.log|visitor-ledger-1851\.txt' | tr '\n' ' ' || true)"
if [ -n "$_extra" ]; then
  echo "note: registry/ also holds your own: $_extra-- not part of the staging." >&2
  echo "      Move it into registry/workbench/ when you can." >&2
fi
if [ "$(ls -l "$KEY" | cut -c1-10)" != "-rwsr-xr-x" ]; then
  echo "self-test: the spare key does not list as -rwsr-xr-x" >&2; fail=1
fi
if ! find "$HOME" -xdev -perm -4000 -type f 2>/dev/null | grep -qxF "$KEY"; then
  echo "self-test: find -perm -4000 under your home does not find the spare key" >&2; fail=1
fi
if [ "$(sh "$KEY" | grep -c .)" -ne 1 ]; then
  echo "self-test: the spare key does not print exactly one line" >&2; fail=1
fi
# Each staged paper is byte for byte the payload that was just decoded.
for _p in "$tmp/auth-ledger.log:$AUTH" "$tmp/visitor-ledger-1851.txt:$VISITORS" "$tmp/spare-key:$KEY"; do
  if ! cmp -s "${_p%%:*}" "${_p#*:}"; then
    echo "self-test: ${_p#*:} is not the paper that was laid down" >&2; fail=1
  fi
done
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
   Work Order No. 1851-13 :: bench staged and verified
  ------------------------------------------------------------------
   Registry:  ~/enginehouse/registry/   three papers, laid out for you

   Nothing is running this week. The registry is files, not a
   process: nothing to lose on `wsl --shutdown`, a reboot or closing
   every Ubuntu window. The work order shows you where to look.
   (bash report-for-duty.sh --reset removes the registry. The house
   roll stays -- later weeks are standing on it.)
  ------------------------------------------------------------------

SLIP
