**stupidweasel – a stupid hack to weasel your mails out into the real world**

This is a stupid sendmail emulator that allows [Evolution](https://wiki.gnome.org/Apps/Evolution)
to be used as some kind of a manual mail transport on a system with no functional sendmail.
Evolution must be correctly configured.
Mails received by this script will be put into Evolution’s local Outbox.

How to use it
=============

Installing it
-------

Running `make install` will install _stupidweasel_ in `$HOME/bin`.
It is also okay to install it as a shared binary (in /usr/local/bin, maybe);
the script does not rely on where it is installed since Evolution configuration files
are always in predictable locations in your home directory.
You don’t need to keep the name _stupidweasel_,
but the name you choose should not end in _q_ or _rm_.

After installation, it is convenient to create a symbolic link that ends in _q_
and another that ends in _rm_.
For example, if you are used to _Zmailer_ you might want the aliases _mailq_ and _mailrm_:

    make install
    cd ~/bin
    ln -s stupidweasel mailq
    ln -s stupidweasel mailrm

It’s not necessary to create these symbolic links, but having them will make things more convenient.
In the above example, running `mailq` would be the same as running `stupidweasel --list`;
running `mailrm` would be the same as running `stupidweasel --delete`.


Configuring your text client
----------------------------

Before you can send mail through your favourite text client,
you will need to configure it so it knows where to find your “sendmail”.
In _mutt_, assuming your home directory is `/home/alice`, you would put the following in your .muttrc:

    set sendmail=/home/alice/bin/stupidweasel

_sendmail_’s `-N` option is recognized but silently ignored;
we have no control over the actual SMTP handshake so no influence over delivery status notifications.


Sending mails from a text client
-------

If you have installed and configured everything correctly, you should be able to use your text client normally;
the only difference is that to actually send any mail,
you must manually press the Send/Receive button in Evolution.

If you want to include a signature but you have multiple Evolutuion identities with multiple signatures,
you can create a .signature file with only this directive:

    (*$insert_signature_here*)

The script will replace this directive with the correct Evolution signature.
Make sure your plain-text signatures do not have the execute bit set;
the script assumes that any file with the execute bit set is a signature script.


Listing the contents of the Outbox
-------------------

If you want to see what is in Evolution’s Outbox,
you can use the command

    stupidweasel --list

Or, if you have created symlinks, you can use your “q” symlink. In the example, you could save keystrokes by typing

    mailq

Evolution’s Outbox also contains mails that have been queued using Evolution’s own offline mode.
The listing you get will make it clear which mails have been put into the Outbox by Evolution itself.

You can show a more detailed version of the listing by including the `-v` (or `--verbose`) option.
In the example installation, that would be

    mailq -v


Deleting mails from the Outbox
-------------------

If you want to delete a piece of mail from the Outbox,
you can use the command

    stupidweasel --delete ID_NUMBER_OF_MAIL_TO_DELETE

Or, if you have created symlinks, you can use your “q” symlink. In the example, you could save keystrokes by typing

    mailrm ID_NUMBER_OF_MAIL_TO_DELETE

You need to know the ID number of what you want to delete.
To get this number you use the `stupidweasel --list` command (or, in the example, `mailq`).

You can make the script give you confirmation after deleting mail by including the `-v` (or `--verbose`) option.
In the example installation, that could be something like

    mailrm -v 1595494621.549.somehost


How it works
============

The script tries its best to detect the correct Evolution account that corresponds to the address used.
This detected identity is placed in a synthesized X-Evolution-Identity header and injected in Evolution’s local Outbox
using [standard Maildir procedures](https://cr.yp.to/proto/maildir.html).
(If a suitable identity cannot be detected the script will exit with an error.)

The injected mail will be visible in Evolution as an unsent mail and can be sent by pressing the Send/Receive button
(sometimes twice).

Note about the X-Evolution-Identity header
----
Although in theory Evolution knows which server goes with which address,
in practice this knowledge is predetermined when you write your mail;
this knowledge is then
saved in an X-Evolution-Identity header,
before the mail is saved in Evolution’s Outbox.
Since we’re forgoing the GUI completely (except for sending),
this header will be missing.
This means
if we don’t generate this header Evolution will actually have *no* knowledge of which account to use.
In this case it will just pick a *random* account,
most likely a wrong one.


Bugs
====

Mutt generates a User-Agent header if configured to do so.
Evolution, on the other hand, generates an X-Mailer header (you have to wonder why!),
*even if* an existing User-Agent or X-Mailer header is present.
(If the mail originally had an X-Mailer header, Evolution will nuke it.)
There is nothing we can do to prevent Evolution from doing this.

Queue-listing mode assumes each mail goes to only one recipient.
This is of course wrong.

Delete mode will actually delete the maildir file from the Evolution Outbox.
The correct way to do it would be to rename the file to include a T (trashed) flag,
but Evolution seems to have some memory of what the name *ought* to be
so renaming the mail doesn’t actually seem to work any better than just deleting it.
