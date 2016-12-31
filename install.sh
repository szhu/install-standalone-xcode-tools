#!/bin/bash
set -e

# Echo only if $VERBOSE
log() {
    [[ -z "$VERBOSE" ]] || echo "$@"
}

# Echo the command only if $VERBOSE, then run it
log-do() {
    log "$@"
    "$@"
}

# Formatted unconditional echo
info() {
    if [[ -z "$1" ]]; then
        echo
        return
    fi
    echo "$1"
    shift
    for line in "$@"; do echo "  $line"; done
}


dmg="$1"

if [[ -z "$dmg" ]]; then
    info "First, go to:" \
        "https://developer.apple.com/download/more/"
    info "Log in with your Apple ID and download:" \
        "Xcode 3.2.6 and iOS SDK 4.3 for Snow Leopard"
    info
    info "After it is downloaded, press Enter to select the file."
    info "(Or you can re-run the tool with the file as the first argument.)"
    read

    # Show the file chooser dialog as the current user, even when run with sudo,
    # to prevent the dialog from showing root's default location and sidebar.
    if [[ "$UID" -eq 0 ]]; then
        as_current_user=(sudo -u "$SUDO_USER")
    else
        as_current_user=
    fi
    [[ -n "$dmg" ]] ||
    dmg_raw="$(
        ${as_current_user[*]} osascript -l JavaScript -e "
        app = Application.currentApplication();
        app.includeStandardAdditions = true;
        console.log(app.chooseFile({
            withPrompt: 'Where is xcode_3.2.6_and_ios_sdk_4.3.dmg?',
            ofType: ['dmg', 'com.apple.disk-image-udif'],
        }));
        " 2>&1
    )"
    dmg=$(echo "$dmg_raw" | tail -1)
fi
info "Selected disk image:" "$dmg"

# http://osxdaily.com/2011/12/17/mount-a-dmg-from-the-command-line-in-mac-os-x/
log hdiutil attach "$dmg"
volume="$(
    hdiutil attach "$dmg" |
    python -c 'from sys import stdin; print stdin.read().splitlines()[-1].split("\t", 3)[-1]'
)"
info "Mounted volume:" "$volume"

[[ -n "$TMPDIR" ]] || TMPDIR="/tmp"
tmp="${TMPDIR%/}/xcodedevtools.$$"
log-do mkdir "$tmp"
info "Using tmpdir:" "$tmp"

info "Extracting (Stage 1/2)..."
if [[ ! -e "$volume/Packages/DeveloperTools.pkg" ]]; then
    info "Can't find the install package at:" "$volume/Packages/DeveloperTools.pkg"
    info "Perhaps you downloaded the wrong disk image."
    exit 1
fi
log-do xar -xf "$volume/Packages/DeveloperTools.pkg" -C "$tmp"

if [[ "$UID" -eq 0 ]]; then
    info "Extracting (Stage 2/2)..."
    log-do ditto -x "$tmp/Payload" /Developer
    info "Succcessfully installed to:" "/Developer"
else
    info "Installing (Stage 2/2)..."
    log-do ditto -x "$tmp/Payload" ~/Developer
    info "Succcessfully installed to:" "$HOME/Developer"
fi
info "To uninstall, just move this folder to the trash."

info
info "Cleaning up..."
log-do rm -rf "$tmp"
info "Deleted tmpdir."
log-do umount -f "$volume"
info "Unmounted volume."
