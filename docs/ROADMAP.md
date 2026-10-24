# homebrew-tap — Roadmap & εκκρεμότητες

Homebrew tap (`chrishham/tap`) με custom formulae· προς το παρόν μόνο το `netbridge-socks` (SOCKS5/HTTP proxy client για το NetBridge VDI tunnel). Οδηγίες χρήσης: `README.md`.

## Φάσεις

| Φάση | Τι | Κατάσταση |
|---|---|---|
| 1 | Αρχικό tap + formula `netbridge-socks` v1.0.0 | ✅ 2026-02-15 |
| 2 | Service wrapper με Homebrew bin dirs στο PATH, release 1.0.1 | ✅ 2026-02-17 |
| 3 | Νέα formulae / ενημερώσεις εκδόσεων | 💤 (εκτίμηση: κατ' απαίτηση) |

## Αποφάσεις (να μην ξαναρωτηθούν)

- Το service τρέχει μέσω `brew services` (macOS & Linux) με config στο `$(brew --prefix)/etc/netbridge/config`.
- Το relay URL ορίζεται από τον χρήστη στο config· δεν υπάρχει default.

## Εκκρεμότητες χρήστη

—

## Εκκρεμότητες Claude

- [ ] Δεν βρέθηκαν TODO/FIXME ούτε ανοιχτή δουλειά στο repo.

## Ιδέες / μελλοντικά

- (εκτίμηση) CI για `brew audit`/`brew test` στις formulae.
- (εκτίμηση) Αυτόματο bump formula όταν βγαίνει νέο release του netbridge.

## Ιστορικό

- 2026-02-15: Initial commit· formula `netbridge-socks` v1.0.0
- 2026-02-17: PATH fix στο service wrapper· release 1.0.1
- 2026-10-24: ROADMAP δημιουργήθηκε από ανασκόπηση repo/memory
