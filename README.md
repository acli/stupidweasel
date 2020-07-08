This is a stupid sendmail emulator that allows Evolution to be used as some kind of mail transport on a system with no functional sendmail.
Evolution must be correctly configured.
Mails received by this program will be put into Evolution’s “Outbox”.

How it works
============

The script tries its best to detect the correct Evolution account that corresponds to the email address used.
This detected identity is placed in an X-Evolution-Identity header.
If a suitable identity cannot be detected the program will exit with an error.

Note:
Although in theory Evolution knows which address should use which server,
in practice this knowledge is saved in the X-Evolution-Identity header before the mail is put in Outbox.
Since we’re forgoing the GUI completely,
if we don’t generate this header Evolution will actually have *no* knowledge of which account to use.
In this case it will just pick a *random* account,
which is probably the wrong account to use.

Bugs
====

Mutt generates a User-Agent header (if configured to do so).
Evolution generate an X-Mailer header *even if* an existing User-Agent header is present.
It’s not known whether converting the User-Agent header to X-Mailer header will prevent this or not.

Queue-listing mode assumes each email goes to only one recipient.
This is of course wrong.
