#!/usr/bin/env bash
#
# Summary: Create executable `man` in `shims/` and other `man` executables in all versions
#

set -e
[ -n "$PLENV_DEBUG" ] && set -x

# Create `man` in every version

write_version_specific_man() {
    local man_version_path=$1
    command -p cat > "$man_version_path" <<SH
#!/usr/bin/env bash

set -e
[ -n "\$PLENV_DEBUG" ] && set -x

PLENV_VERSION="\$(plenv-version-name)"
PLENV_COMMAND="\$(basename "\${0}")"
VERSION_ROOT_PATH="\${PLENV_ROOT}/versions/\${PLENV_VERSION}"

global_manpath="\$(MANPATH='' manpath)"
MANPATH="\${VERSION_ROOT_PATH}/man\${MANPATH:+:}\${MANPATH}"
MANPATH="\${MANPATH}\${global_manpath:+:}\${global_manpath}"
export MANPATH

# We assume this implementation of man replaces
# default man paths by \$MANPATH. Therefore, if \$MANPATH is set,
# this is user's specific choice. We respect it.
# This requires more logic:
# https://unix.stackexchange.com/questions/344603/how-to-append-to-manpath

expand_path() {
  if [ ! -d "\$1" ]; then
    return 1
  fi

  local cwd="\$PWD"
  cd "\$1"
  pwd
  cd "\$cwd"
}

remove_from_path() {
  local path_to_remove
  path_to_remove="\$(expand_path "\$1")"
  if [ -z "\$path_to_remove" ]; then
    echo "\${PATH}" && return
  fi

  local result=""
  local paths
  IFS=: read -r -a paths <<< "\$PATH"
  for path in "\${paths[@]}"; do
    path="\$(expand_path "\$path" || true)"
    if [ -n "\$path" ] && [ "\$path" != "\$path_to_remove" ]; then
      result="\${result}\${path}:"
    fi
  done
  echo "\${result%:}"
}

PATH="\$(remove_from_path "\${PLENV_ROOT}/versions/\${PLENV_VERSION}/bin")"
PATH="\$(remove_from_path "\${PLENV_ROOT}/shims")"
export PATH
PLENV_COMMAND_PATH="\$(command -v "\$PLENV_COMMAND" || true)"

exec "\$PLENV_COMMAND_PATH" "\$@"
SH
command -p chmod +x "$man_version_path"
}

versions_raw="$(plenv-versions --bare)"
# echo "versions_raw:" "${versions_raw}"
declare -a versions
declare line
while IFS= read -r line; do versions+=("$line"); done <<< "${versions_raw}"
# mapfile -t versions <<< "${versions_raw}"
# echo "versions:" "${versions[@]}"
for i in "${!versions[@]}"; do
    version="${versions[$i]}"
    # PLENV_VERSION="${versions[$i]}"
    PLENV_VERSION="${version}"
    # echo "PLENV_VERSION:$PLENV_VERSION" >&1
    VERSION_ROOT_PATH="${PLENV_ROOT}/versions/${PLENV_VERSION}"
    man_version_dir="${VERSION_ROOT_PATH}/bin"
    # echo "man_version_dir:$man_version_dir"
    # If your wanted a build without man pages,
    # the directory would not be there, so, no man page either!
    if [ -d "${man_version_dir}" ]; then
        man_version_path="${VERSION_ROOT_PATH}/bin/man"
        # echo "man_version_path:$man_version_path"
        write_version_specific_man "${man_version_path}"
    fi
done

# Create `man` in shims/
man_shim_path="${SHIM_PATH}/man"
command -p cat > "$man_shim_path" <<SH
#!/usr/bin/env bash
set -e
[[ -n "\$PLENV_DEBUG" ]] && set -x
PLENV_ROOT='$PLENV_ROOT' exec '$(command -v plenv)' exec "\${0##*/}" "\$@"
SH
command -p chmod +x "$man_shim_path"
