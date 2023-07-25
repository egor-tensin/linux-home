linux-home
==========

My dotfiles.

The files are maintained in this repository and deployed on different machines
using [config-links].

[config-links]: https://github.com/egor-tensin/config-links

Deployment
----------

Go to the top directory and execute `./setup.sh`.
This uses [config-links] internally.

Issues
------

Some utilities (notably, GHC) may not work if its configuration files are
group-writable.
To fix this, run `chmod g-w` for every file & directory in this repository (you
can do this by running `links-chmod go-w`; this call is included in the
setup.sh script).

License
-------
Distributed under the MIT License.
See [LICENSE.txt] for details.

[LICENSE.txt]: LICENSE.txt
