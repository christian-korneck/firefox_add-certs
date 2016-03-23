firefox_add-certs
===========

script to add new CA certificates to the Firefox trusted certificate store on Windows


Description
-------------
Unlike other  browsers, Firefox doesn't use the Windows certificate store, but comes with its own hardcoded list of trusted Certificate Authorities. New CA certificates can be added through the GUI and are stored in the user's Firefox profile.
This cmd script is a very thin wrapper around Mozilla's NSS certutil command line tool, that adds all CA certificates from a given folder as trusted to:
- the default Firefox profile (so that any newly created Firefox profile will automatically have them)
- the Firefox profiles of all users on the local Windows machine (appropriate write permissions to these user profiles needed)

The release download includes a build of the NSS `certutil.exe`.

Usage
-------------
- download and extract the ZIP file from the [release page](https://github.com/christian-korneck/firefox_add-certs/releases) (includes the NSS certutil.exe binaries)
- put all CA certificates that you want to add in the folder: `cacert\`. File extension needs to be `.pem`.
  - note: For testing, the CA folder includes the [CACert.org](http://www.cacert.org/) root and intermediate certificates. Remove them if you don't want to add them.
- run `add-certs.cmd` with admin privileges

Requirements
-------------
- the bundled certutil.exe might require [vcredist 12.0/2013 32bit](http://www.microsoft.com/en-us/download/details.aspx?id=40784)
- tested with Firefox 39.0, Windows 8.1
