# homebrew-tap — Roadmap & εκκρεμότητες

Homebrew tap (`chrishham/tap`) με custom formulae· προς το παρόν μόνο το `netbridge-socks` (SOCKS5/HTTP proxy client για το NetBridge VDI tunnel). Οδηγίες χρήσης: `README.md`.

## Φάσεις

| Φάση | Τι | Κατάσταση |
|---|---|---|
| 1 | Αρχικό tap + formula `netbridge-socks` v1.0.0 | ✅ 2026-02-15 |
| 2 | Service wrapper με Homebrew bin dirs στο PATH, release 1.0.1 | ✅ 2026-02-17 |
| 3 | Νέα formulae / ενημερώσεις εκδόσεων | 🔄 (συνεχές· εκτίμηση: κατ' απαίτηση) |

## Αποφάσεις (να μην ξαναρωτηθούν)

- Το service τρέχει μέσω `brew services` (macOS & Linux) με config στο `$(brew --prefix)/etc/netbridge/config`.
- Το relay URL ορίζεται από τον χρήστη στο config· δεν υπάρχει default.

## Εκκρεμότητες χρήστη

—

## Εκκρεμότητες Claude

—

## Ιδέες / μελλοντικά

- (εκτίμηση) CI για `brew audit`/`brew test` στις formulae.
- (εκτίμηση) Αυτόματο bump formula όταν βγαίνει νέο release του netbridge.

## Ιστορικό

- 2026-02-15: Initial commit· formula `netbridge-socks` v1.0.0
- 2026-02-17: PATH fix στο service wrapper· release 1.0.1
- 2026-03: 1.0.2
- 2026-04: 1.0.3
- 2026-05: 1.1–1.2.3 — διαδοχικά releases του netbridge-socks
- 2026-06: 1.2.4
- 2026-08: 1.3–1.5.1 — υποστήριξη tray, autostart σε Linux, Linux deps (cairo, gi, system GTK3), fix GI_TYPELIB_PATH και uv/Python, README για tray vs headless service
- 2026-09: 1.6.0–1.6.3 — fix Linux autostart (opt_libexec, πάντα rewrite, απενεργοποίηση systemd)
- 2026-10: 1.7.0
- 2026-10-24: ROADMAP δημιουργήθηκε από ανασκόπηση repo/memory
- 2026-11-11: README: ενότητα WSL (headless/--no-tray, systemd για brew services, az login μέσα στο WSL)
- 2026-10-24: Συμπλήρωση ιστορικού releases 1.0.2–1.7.0· φάση 3 → 🔄 (συνεχές)· αφαίρεση placeholder todo
