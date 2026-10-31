#!/bin/sh
# ----------------------------------------------------------------------------
# Apache Maven Wrapper Executable Script (Self-contained / only-script style)
# ----------------------------------------------------------------------------

set -e

# Resolve APP_HOME
PRG="$0"
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`"/$link"
  fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

# Read distributionUrl
DIST_URL="https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.6/apache-maven-3.9.6-bin.zip"
WRAPPER_PROPS="$APP_HOME/.mvn/wrapper/maven-wrapper.properties"
if [ -f "$WRAPPER_PROPS" ]; then
  CONF_URL=$(grep "^distributionUrl" "$WRAPPER_PROPS" | cut -d'=' -f2- | tr -d '\\\r ')
  if [ -n "$CONF_URL" ]; then
    DIST_URL="$CONF_URL"
  fi
fi

# Determine zip filename and distribution name
ZIP_NAME=$(basename "$DIST_URL")
DIST_NAME="${ZIP_NAME%-bin.zip}"
DIST_NAME="${DIST_NAME%.zip}"

# Target directory under ~/.m2/wrapper/dists
TARGET_DIR="$HOME/.m2/wrapper/dists/$DIST_NAME"
MAVEN_HOME="$TARGET_DIR/$DIST_NAME"

if [ ! -d "$MAVEN_HOME" ]; then
  mkdir -p "$TARGET_DIR"
  ZIP_PATH="$TARGET_DIR/$ZIP_NAME"
  if [ ! -f "$ZIP_PATH" ]; then
    echo "Downloading Maven distribution from: $DIST_URL"
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL -o "$ZIP_PATH" "$DIST_URL"
    elif command -v wget >/dev/null 2>&1; then
      wget -q -O "$ZIP_PATH" "$DIST_URL"
    else
      echo "Error: curl or wget is required to download Maven." >&2
      exit 1
    fi
  fi
  echo "Unpacking Maven to: $TARGET_DIR"
  unzip -q -o "$ZIP_PATH" -d "$TARGET_DIR"
fi

# Run Maven
exec "$MAVEN_HOME/bin/mvn" "$@"
