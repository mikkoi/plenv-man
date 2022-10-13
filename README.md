# plenv-man

A [plenv](https://github.com/tokuhirom/plenv) plugin to help read man pages from different Perl versions.


## Usage

```
$ plenv man perl
$ plenv man 3 open
$ plenv man --version 5.34.1 perldelta
$ plenv man --version 5.34.1 --executable manpath -g -d
```


## The Explicit Way, Using Plenv Command `plenv man`.

EXAMPLES

Read man page of currently active perl:

```sh
plenv man perl
```

You can use any arguments you would normally give to `man`:

```sh
plenv man 3 open
```

Read man page of any installed perl version:

```sh
plenv man --version 5.34.1 perldelta
```

Instead of `man`, run any command which makes use of $MANPATH environmental variable:

```sh
plenv man --version 5.34.1 --executable manpath -g -d
```


## Installation

```sh
mkdir -p ${PLENV_ROOT}/plugins
git clone https://github.com/mikkoi/plenv-man.git ${PLENV_ROOT}/plugins/plenv-man
```

## The Implicit Way, Using Plenv Hook.

The implicit way creates a pseudo-`man` command in `${PLENV_ROOT}/shims/`
and other pseudo commands in all v`${PLENV_ROOT}/versions/<version>/bin/`
directories. There are created by hooking into `plenv rehash` command.
When running `man`, these shims set the correct `$MANPATH` variable contents
and then call system `man`.

### Installation

```sh
mkdir -p ${PLENV_ROOT}/plugins
git clone https://github.com/mikkoi/plenv-man.git ${PLENV_ROOT}/plugins/plenv-man
mkdir -p ${PLENV_ROOT}/plenv.d/rehash
cp ${PLENV_ROOT}/plugins/plenv-man/plenv.d/rehash/man.bash ${PLENV_ROOT}/plenv.d/rehash/
plenv rehash
```

## AUTHOR

Mikko Koivunalho

## LICENSE

See [LICENSE](./LICENSE).
