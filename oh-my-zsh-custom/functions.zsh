#!/usr/bin/env bash

# List and optionally remove node_modules recursively
nmr() {
    emulate -L zsh
    setopt pipefail nullglob

    # Find node_modules directories (pruned for speed)
    local -a dirs
    IFS=$'\n' dirs=($(command find . -type d -name node_modules -prune -print 2>/dev/null))

    if (( ${#dirs[@]} == 0 )); then
        print -- "No node_modules directories found under $(pwd)"
        return 0
    fi

    # Show list
    print -- "The following node_modules directories would be removed:"
    local i=1
    for d in "${dirs[@]}"; do
        print -- "  $i) $d"
        ((i++))
    done

    # Optional: show total size (can take some time on huge trees)
    if command -v du >/dev/null 2>&1; then
        print -- ""
        print -- "Computing total size (this may take a moment)..."
        # BSD/macOS du: -h; GNU du: -h works too
        command du -ch -- "${dirs[@]}" 2>/dev/null | tail -n 1 | sed 's/total$/total size/'
    fi

    # Ask for confirmation
    print -n -- "Proceed to delete these ${#dirs[@]} directorie(s)? [y/N] "
    local reply
    read -r reply
    case "$reply" in
        y|Y|yes|YES)
            print -- "Deleting..."
            # Use rm -rf safely on each path
            local ok=1
            for d in "${dirs[@]}"; do
                if [[ -d "$d" ]]; then
                    command rm -rf -- "$d" || ok=0
                fi
            done
            if (( ok )); then
                print -- "Done."
                return 0
            else
                print -- "Some deletions failed."
                return 1
            fi
            ;;
        *)
            print -- "Aborted. Nothing was deleted."
            return 0
            ;;
    esac
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}
