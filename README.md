This is a stupid sendmail emulator that allows [Evolution](https://wiki.gnome.org/Apps/Evolution)
to be used as some kind of a manual mail transport on a system with no functional sendmail.
Evolution must be correctly configured.
Mails received by this script will be put into Evolution’s local Outbox.

How it works
============

The script tries its best to detect the correct Evolution account that corresponds to the address used.
This detected identity is placed in a synthesized X-Evolution-Identity header and injected in Evolution’s local Outbox
using [standard Maildir procedures](https://cr.yp.to/proto/maildir.html).
(If a suitable identity cannot be detected the script will exit with an error.)

The injected mail will be visible in Evolution as an unsent mail and can be sent by pressing the Send/Receive button
(sometimes twice).

Note:
Although in theory Evolution knows which address should use which server,
in practice this knowledge is predetermined at composition time and
saved in an X-Evolution-Identity header,
before the mail is saved in Evolution’s Outbox.
Since we’re forgoing the GUI completely (except for sending),
if we don’t generate this header Evolution will actually have *no* knowledge of which account to use.
In this case it will just pick a *random* account,
which is probably the wrong account to use.


How to use it
=============

Sending
-------

In .muttrc, set `sendmail` to the full path of where you installed this script.
The script must not be installed with a name that ends in *q* or *rm*.

In this mode, the script will analyze the mail that it receives from standard input;
if a suitable Evolution identity is found,
the mail will be injected into Evolution’s Outbox.

To actually send the mail, you must manually press the Send/Receive button in Evolution.

List queue contents
-------------------

Running the script with either the `-q` or `--list` option will show you a listing of the contents of the Evolution Outbox.
Note that the Outbox also contains mails that have been queued using Evolution’s offline mode.

If the script is installed or symlinked to a name that ends in *q* (such as *mailq*),
the script will run in list mode by default.

Delete queued mail
-------------------

Running the script with the `--delete` option,
followed by one or more mail ID’s will cause the specified mails to be deleted from Outbox.
You can get a list of ID’s by running the script in list mode.

If the script is installed or symlinked to a name that ends in *rm* (such as *mailrm*),
the script will run in delete mode by default.


Bugs
====

Mutt generates a User-Agent header if configured to do so.
Evolution, on the other hand, generates an X-Mailer header, *even if* an existing User-Agent header is present.
It’s not known whether converting the User-Agent header to X-Mailer header will prevent this or not.

Queue-listing mode assumes each mail goes to only one recipient.
This is of course wrong.

Delete mode will actually delete the maildir file from the Evolution Outbox.
The correct way to do it would be to rename the file to include a T (trashed) flag,
but Evolution seems to have some memory of what the name *ought* to be
so renaming the mail doesn’t actually seem to work any better than just deleting it.
