# plenv-man

A [plenv](https://github.com/tokuhirom/plenv) plugin to help read man pages from different Perl versions.

## Installation

```sh
mkdir -p ${PLENV_ROOT}/plugins
git clone https://github.com/mikkoi/plenv-man.git ${PLENV_ROOT}/plugins/plenv-man
mkdir -p ${PLENV_ROOT}/plenv.d/exec
cp ${PLENV_ROOT}/plugins/plenv-man/plenv.d/man.bash ${PLENV_ROOT}/plenv.d/exec/man.bash
```

## Usage

```
$ plenv man perl
$ plenv man 3 open
$ plenv man --version 5.34.1 perldelta
$ plenv man --version 5.34.1 --executable manpath -g -d
```

## AUTHOR

Mikko Koivunalho

## LICENSE

See [LICENSE](./LICENSE).
