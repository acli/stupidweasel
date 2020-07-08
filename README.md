This is a stupid sendmail emulator that allows Evolution to be used as some kind of mail transport on a system with no functional sendmail.
Evolution must be correctly configured.
Mails received by this program will be put into Evolution's “Outbox”.

How it works
============

The script tries its best to detect the correct Evolution account that corresponds to the email address used.
This detected identity is placed in an X-Evolution-Identity header following the From header.

Although in theory Evolution knows which address should use which server,
in practice it saves this knowledge in the X-Evolution-Identity header before placing the mail in its Outbox.
Since we're forgoing the GUI,
if we don't generate this header Evolution will actually have *no* knowledge of which account to use.
In this case it will just pick a *random* account,
which is probably the wrong account to use.
