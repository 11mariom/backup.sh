README
======

`backup.sh` is a simple shell script.

Dependencies:
-------------
   * `rdiff-backup`
   * `posix-sh`
   * `awk`

Configuration:
--------------
Is simply described in the script.

   * exclude - define what places rdiff-backup must exclude
   * o\_opt  - other options
   * b\_dir  - original files destination
   * d\_dir  - backup destination
   * log     - a directory for logs
   * disc    - partition needed to mount before making a backup

TODO:
-----
   * configuration in external file
   * (safe) parsing config file
   * ebuild

Any suggestions?
