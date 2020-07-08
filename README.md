This is a stupid sendmail emulator that allows Evolution to be used as some kind of mail transport on a system with no functional sendmail.
Evolution must be correctly configured.
Mails received by this script will be put into Evolution’s “Outbox”.

How it works
============

The script tries its best to detect the correct Evolution account that corresponds to the email address used.
This detected identity is placed in an X-Evolution-Identity header.
If a suitable identity cannot be detected the script will exit with an error.

Note:
Although in theory Evolution knows which address should use which server,
in practice this knowledge is saved in the X-Evolution-Identity header before the mail is put in Outbox.
Since we’re forgoing the GUI completely,
if we don’t generate this header Evolution will actually have *no* knowledge of which account to use.
In this case it will just pick a *random* account,
which is probably the wrong account to use.


How to use it
=============

Sending
-------

In .muttrc, set sendmail to the full path of where you installed this script.
The script must not be installed with a name that ends in “q” or “rm”.

In this mode, the script will analyze the email that it receives from standard input;
if a suitable Evolution identity is found,
the email will be queued in Evolution’s Outbox.

To actually send the mail, you must manually press the Send/Receive button in Evolution.

List queue contents
-------------------

Running the script with the -q or --list options will cause it to display a listing of the contents of the Evolution Outbox.
Note that the Outbox will also contain emails that have been queued using Evolution’s offline mode.

If the script is installed or symlinked to a name that ends in “q”, the script will run in list mode by default.

Delete queued email
-------------------

Running the script with the --delete option, followed by one or more email ID’s will cause the specified emails to be deleted from Outbox.
You can get a list of ID’s by running the script in list mode.

If the script is installed or symlinked to a name that ends in “rm”, the script will run in delete mode by default.


Bugs
====

Mutt generates a User-Agent header (if configured to do so).
Evolution generate an X-Mailer header *even if* an existing User-Agent header is present.
It’s not known whether converting the User-Agent header to X-Mailer header will prevent this or not.

Queue-listing mode assumes each email goes to only one recipient.
This is of course wrong.
