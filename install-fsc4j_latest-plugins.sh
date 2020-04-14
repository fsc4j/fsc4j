set -e
set -o pipefail

if [[ -n $1 ]]; then
  ECLIPSEHOME=$1
else
  ECLIPSEHOME=/Applications/Eclipse.app
fi

is_eclipse_dir() {
  [[ -f "$1/Contents/Eclipse/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info" && -d "$1/Contents/Eclipse/plugins" ]]
}

if ! is_eclipse_dir "$ECLIPSEHOME"; then
  echo "Directory '$ECLIPSEHOME' does not appear to be a supported Eclipse installation. Please specify the path to a supported Eclipse installation on the command line."
  exit 1
fi

PRODUCT_VERSION="0.1.4"
JDT_CORE_VERSION="0_1_4"
JDT_DEBUG_VERSION="0_0_2"

PRODUCT="FSC4J $PRODUCT_VERSION"

echo ""
echo "Installing $PRODUCT into '$ECLIPSEHOME'..."

download_if_not_exists() {
  if ! [[ -e $2 ]]; then
    echo ""
    echo "Downloading $PRODUCT plugin $2..."
    echo ""
    curl --fail-early -f -L -O $1/$2
  else
    echo ""
    echo "Skipping download of $PRODUCT plugin $2; it is already present."
  fi
}

pushd -q $ECLIPSEHOME/Contents/Eclipse/plugins

download_if_not_exists https://github.com/fsc4j/fsc4j/releases/download/$JDT_CORE_VERSION org.eclipse.jdt.core_3.21.0.fsc4j_$JDT_CORE_VERSION.jar
download_if_not_exists https://github.com/fsc4j/fsc4j/releases/download/$JDT_DEBUG_VERSION org.eclipse.jdt.debug_3.14.0.fsc4j_$JDT_DEBUG_VERSION.jar

cd ../configuration/org.eclipse.equinox.simpleconfigurator

JDT_CORE_LINE=org.eclipse.jdt.core,3.21.0.fsc4j_$JDT_CORE_VERSION,plugins/org.eclipse.jdt.core_3.21.0.fsc4j_$JDT_CORE_VERSION.jar,4,false
JDT_DEBUG_LINE=org.eclipse.jdt.debug,3.14.0.fsc4j_$JDT_DEBUG_VERSION,plugins/org.eclipse.jdt.debug_3.14.0.fsc4j_$JDT_DEBUG_VERSION.jar,4,false

if [[ `grep '^org\.eclipse\.jdt\.core,' bundles.info` = $JDT_CORE_LINE && `grep '^org\.eclipse\.jdt\.debug,' bundles.info` = $JDT_DEBUG_LINE ]]; then
  echo ""
  echo "Skipping bundles.info edits; it already points to the $PRODUCT plugins."
else
  echo ""
  echo "Editing bundles.info to point to the $PRODUCT plugins..."
  sed -i.orig.`date +%Y%m%d%H%M%S` 's:^org\.eclipse\.jdt\.core,.*$:'$JDT_CORE_LINE':;s:^org\.eclipse\.jdt\.debug,.*$:'$JDT_DEBUG_LINE':' bundles.info
  echo "Done."
fi

cd ../..

echo ""

if [[ $(sed -n -e N -e '/^-showlocation\nFSC4J '$PRODUCT_VERSION'$/ {
  c\
    ok
  q
}' -e q eclipse.ini) = ok ]]; then
  echo 'Skipping update of eclipse.ini; window title already set to show "FSC4J '$PRODUCT_VERSION'".'
else
  echo 'Updating eclipse.ini: setting the Eclipse window title to show "FSC4J '$PRODUCT_VERSION'"...'
  # Remove existing -showlocation option, if any
  sed -i '' -e N -e '2 { /^-showlocation\nFSC4J/ d; }' eclipse.ini
  sed -i '' -e '1 i\
    -showlocation\
    FSC4J '$PRODUCT_VERSION'
  ' eclipse.ini
fi

cd ../../..

if xattr -p com.apple.quarantine Eclipse.app > /dev/null 2>&1; then
  echo ""
  echo "Removing the com.apple.quarantine attribute..."
  echo "NOTE: To remove this attribute, you need to enter your password."
  CMD="sudo xattr -dr com.apple.quarantine Eclipse.app"
  echo "$CMD"
  eval $CMD
else
  echo ""
  echo "Skipping removal of com.apple.quarantine attribute; it has already been removed."
fi

popd -q
echo ""
echo "$PRODUCT installed successfully"
echo ""
