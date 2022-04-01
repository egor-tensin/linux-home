linux-home
==========

My dotfiles.

The files are maintained in this repository and shared across different
machines using [config-links].

[config-links]: https://github.com/egor-tensin/config-links

Deployment
----------

Go to the top directory and execute `links-update` (from [config-links]).

Issues
------

Some utilities (notably, GHC) may not work if its configuration files are
group-writable.
To fix this, run `chmod g-w` for every file & directory in this repository (you
can do this using the supplied fix_permissions.sh script).

License
-------
Distributed under the MIT License.
See [LICENSE.txt] for details.

[LICENSE.txt]: LICENSE.txt
