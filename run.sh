#!/usr/bin/env bash
set -e -o pipefail

: "${CS_PATH:=$HOME/cs3231}"
: "${ASST_DIR:=asst3-src}"
: "${ASST_NAME:=ASST3}"
: "${ASST_PATH:=$CS_PATH/$ASST_DIR}"

defaultArgs='compile install-kernel kernel'
defaultTest='p /testbin/asst3'

main() {
  while [[ $# -gt 0 ]]; do
    arg="$1"

    case $arg in
    'help' | '-h' | '--help')
      printf 'OS Assignment Runner by @hellodavie\n\nUsage: run [clean | compile-userland | compile | install-kernel | kernel | debug | ([--]test <OS161-command>)]...\n\nExamples:\n  run\n  run debug\n  run compile install-kernel kernel\n  run compile install --test "p /testbin/asst2"\n'
      ;;
    'clean')
      cd "$ASST_PATH"/kern/compile/$ASST_NAME || exit 1
      bmake clean
      ;;
    'compile-userland')
      cd "$ASST_PATH"
      bmake
      bmake install
      ;;
    'compile')
      cd "$ASST_PATH"/kern/compile/$ASST_NAME || exit 1
      bmake depend
      bmake 2>&1 | "$ASST_PATH"/colorgcc.pl
      ;;
    'install-kernel')
      cd "$ASST_PATH"/kern/compile/$ASST_NAME || exit 1
      bmake install
      ;;
    'kernel')
      cd "$CS_PATH"/root || exit 1
      sys161 kernel
      ;;
    'test' | '--test' | 't' | '-t')
      cd "$CS_PATH"/root || exit 1
      shift
      sys161 kernel "${1:-$defaultTest}"
      ;;
    'bin' | '--bin' | 'b' | '-b')
      cd "$CS_PATH"/root || exit 1
      shift
      if [ -z "$1" ]; then
        sys161 kernel "$defaultTest"
      else
        sys161 kernel "p /testbin/$1"
      fi
      ;;
    'debug')
      cd "$CS_PATH"/root || exit 1
      os161-gdb --quiet kernel
      exit 0
      ;;
    *)
      echo "Unrecognised command: $arg"
      exit 1
      ;;
    esac

    shift
  done
}

if [ $# -eq 0 ]; then
  main $defaultArgs
else
  main "$@"
fi
