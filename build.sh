#!/usr/bin/env bash

set -e

# Move to this script's directory.
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

case $1 in
  plain|debug|debugoptimized|release|minsize)
    BUILDTYPE=$1
    shift
    ;;
  *)
    BUILDTYPE=release
    ;;
esac

BUILDDIR=build/${BUILDTYPE}

MESON=$(PATH="${PATH}:${HOME}/.local/bin" command -v meson)

if [ -f "${BUILDDIR}/build.ninja" ]
then
  "${MESON}" configure "${BUILDDIR}" -Dbuildtype="${BUILDTYPE}" -Dprefix="${INSTALL_PREFIX:-/usr/local}" "$@"
else
  "${MESON}" "${BUILDDIR}" --buildtype "${BUILDTYPE}" --prefix "${INSTALL_PREFIX:-/usr/local}" "$@"
fi

"${MESON}" compile -C "${BUILDDIR}"
[ -n "${INSTALL_PREFIX}" ] && "${MESON}" install -C "${BUILDDIR}"
