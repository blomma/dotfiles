# Shared shell helpers for profile installation and dotfile adoption.

validate_profile_name() {
    case "$1" in
        ''|[!a-zA-Z0-9]*|*[!a-zA-Z0-9_-]*) fail "invalid profile name: $1" ;;
    esac
}

report_dry_run() {
    printf 'Profile %s: dry-run complete; no changes made.\n' "$profile_name"
}

validate_profile_path() {
    case "$1" in
        ''|/*|*/|*//*|.|..|./*|../*|*/./*|*/../*|*/.|*/..|*$'\n'*)
            fail "invalid profile path: $1" ;;
        .git|.git/*|profiles|profiles/*|scripts|scripts/*|tests|tests/*)
            fail "repository infrastructure cannot be installed: $1" ;;
    esac
}

normalize_path() (
    set -f
    IFS=/
    normalized=
    for component in $1; do
        case "$component" in
            ''|.) ;;
            ..) normalized=${normalized%/*} ;;
            *) normalized=$normalized/$component ;;
        esac
    done
    printf '%s\n' "${normalized:-/}"
)

relative_path() {
    local from=$1 to=$2 prefix=
    while [[ "$to" != "$from/"* ]]; do from=${from%/*}; prefix=../$prefix; done
    printf '%s%s\n' "$prefix" "${to#"$from/"}"
}

profile_covers() {
    local selection=$2
    [ -f "$1" ] || return 1
    while :; do
        if grep -Fqx -- "$selection" "$1"; then return 0; fi
        case "$selection" in */*) selection=${selection%/*} ;; *) return 1 ;; esac
    done
}

# A selected file may already be exposed through a shared directory link.
# Never run Stow inside that directory, since it is part of the source tree.
entry_parent() {
    local path=$1 parent physical expected
    shared_parent=false
    parent=$(dirname -- "$target/$path")
    while [ "$parent" != "$target" ]; do
        if [ -L "$parent" ]; then
            physical=$(CDPATH= cd -- "$parent" && pwd -P) || fail "invalid target directory: $parent"
            expected=$repo/${parent#"$target/"}
            [ "$physical" = "$expected" ] || fail "target directory links outside its shared source: $parent"
            shared_parent=true
        elif [ -e "$parent" ] && [ ! -d "$parent" ]; then
            fail "target parent is not a directory: $parent"
        fi
        parent=$(dirname -- "$parent")
    done
}

stow_entry() {
    local stow_path=$1 stow_destination=$2 source_parent package stow_dir pattern
    shift 2
    source_parent=$(dirname -- "$repo/$stow_path")
    package=$(basename -- "$source_parent")
    stow_dir=$(dirname -- "$source_parent")
    pattern=$(basename -- "$stow_path" | sed 's/[][\\.^$*+?(){}|]/\\&/g')
    stow --dir "$stow_dir" --target "$stow_destination" --ignore="\A(?!(?:$pattern)(?:/|\z)).*" "$@" "$package"
}
