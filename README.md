Install Standalone Developer Tools from Xcode 3.2.6
===================================================

Starting with Xcode 4, Apple started distributing developer tools like FileMerge
inside the Xcode app; you must download Xcode from the Mac App Store to install
these tools. This is inconvenient for developers who do not need Xcode:

 - Xcode takes a long time to download.
 - Xcode takes up a lot of space, since it includes a few iOS boot images.
 - Merely installing Xcode will cause the default "Open With:" file associations
   for many scripts to be changed to Xcode, and the associate for each type of
   script must be changed back manually.

Furthermore, Property List Editor is now part of Xcode and is no longer its own
app. Xcode's integrated property list editor has more features, but Xcode takes
a long time to start up and uses a lot of memory. Standalone Property List
Editor takes less than a second to start up.

Fortunately, the standalone developer tools included with Xcode 3.2.6 still work
up to Mac OS 10.11, and some of them (unfortunately, not Property List Editor)
still work in 10.12. This repo provides an easy way to install these tools
without installing the rest of the Xcode package.

To install the developer tools, first go to
[https://developer.apple.com/download/more/](https://developer.apple.com/download/more/).
Log in with your Apple ID and download "Xcode 3.2.6 and iOS SDK 4.3 for Snow
Leopard".


Then, to install for the current user, to `~/Developer`:

```sh
curl -fsSL https://goo.gl/RBK09o | /bin/bash
```

Or, to install for all users, to `/Developer`, run with `sudo`:

```sh
curl -fsSL https://goo.gl/RBK09o | /usr/bin/sudo /bin/bash
```

To uninstall, just move `/Developer` or `~/Developer` to the trash. The
installer does not install files anywhere else.

That's all. Enjoy! -[@szhu](https://github.com/szhu)
