#!/usr/bin/env bash

Appify="$(basename "$0")"

if [ ! "$1" -o "$1" = "-h" -o "$1" = "--help" ]; then cat <<EOF
    Appify v5 for Mac OS X
    Creates the simplest possible Mac OS X app from a shell script.

    Takes a shell script as its first argument:

        $Appify path/to/my-script

    If you want to give your app a custom name, use the second argument:

        $Appify my-demo "This is my awesome DEMO"

    Once your app is created, $Appify will tell you the path to your Info.plist.
    You should customize the Bundle Identifier and Get Info String at least.

    MIT License
    Copyright © 2010-2011 Thomas Aylott <http://subtlegradient.com>
    Copyright © 2011 Mathias Bynens <http://mathiasbynens.be>
    Copyright © 2011 Sencha Labs Foundation

EOF
exit; fi


# Options
appify_SRC="$1"
appify_FILE="$(basename $appify_SRC)"
appify_NAME="${2:-$(echo "$appify_FILE"| sed -E 's/\.[a-z]{2,4}$//' )}"
appify_ROOT="$appify_NAME.appify/Contents/MacOS"
appify_INFO="$appify_NAME.appify/Contents/Info.plist"


# Create the bundle
if [[ -a "$appify_NAME.appify" ]]; then
    echo "$PWD/$appify_NAME.appify already exists :(" 1>&2
    exit 1
fi
mkdir -p "$appify_ROOT"


# Copy the source into the bundle as the CFBundleExecutable
if [ -f "$appify_SRC" ]; then
    cp  "$appify_SRC" "$appify_ROOT/$appify_FILE"
    echo "Copied $appify_ROOT/$appify_FILE" 1>&2

else
    # Create a new blank CFBundleExecutable
    cat <<-EOF > "$appify_ROOT/$appify_FILE"
#!/usr/bin/env bash
echo "This ('\$0') is a blank appified script." 1>&2
exit 1
EOF
    echo "Created blank '$appify_ROOT/$appify_FILE' be sure to edit this file to make it do things and stuff" 1>&2
fi
chmod +x "$appify_ROOT/$appify_FILE"


# Create the Info.plist
cat <<-EOF > "$appify_INFO"
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>CFBundlePackageType</key><string>APPL</string><key>CFBundleInfoDictionaryVersion</key><string>6.0</string>

    <key>CFBundleName</key>                      <string>$appify_NAME</string>
    <key>CFBundleExecutable</key>                <string>$appify_FILE</string>
    <key>CFBundleIdentifier</key> <string>appified.$USER.$appify_FILE</string>

    <key>CFBundleVersion</key>            <string>0.1</string>
    <key>CFBundleGetInfoString</key>      <string>0.1 appified by $USER at `date`</string>
    <key>CFBundleShortVersionString</key> <string>0.1</string>

</dict></plist>
EOF


# Appify!
if [[ -a "$appify_NAME.app" ]]; then
    echo "$PWD/$appify_NAME.app already exists :(" 1>&2
    exit 1
fi
mv "$appify_NAME.appify" "$appify_NAME.app"


# Success!
echo "Be sure to customize your $appify_INFO" 1>&2
echo "$PWD/$appify_NAME.app"
