param ($eclipseHome = ".")

set-strictmode -version latest
$ErrorActionPreference = "Stop"

if (!((test-path "$eclipseHome/plugins") -and (test-path "$eclipseHome/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info"))) {
  echo "The directory '$eclipseHome' does not appear to be a supported Eclipse installation. Please specify the path to a supported Eclipse installation on the command line."
  exit 1
}

$productName = "FSC4J 0.0.6"

echo "Installing $productName to '$eclipseHome'..."

pushd "$eclipseHome/plugins"

function download-file($url, $name) {
  if ((test-path $name)) {
    echo "Skipping the download of file '$name'; it is already present on disk."
  } else {
    echo "Downloading file '$name'..."
    (new-object System.Net.WebClient).DownloadFile("$url/$name", "$(pwd)/$name")
    echo "File '$name' downloaded successfully."
  }
}

download-file "https://github.com/fsc4j/fsc4j/releases/download/0_0_6" "org.eclipse.jdt.core_3.21.0.fsc4j_0_0_6.jar"
download-file "https://github.com/fsc4j/fsc4j/releases/download/0_0_2" "org.eclipse.jdt.debug_3.14.0.fsc4j_0_0_2.jar"

cd ../configuration/org.eclipse.equinox.simpleconfigurator

$jdtCoreLine = 'org.eclipse.jdt.core,3.21.0.fsc4j_0_0_6,plugins/org.eclipse.jdt.core_3.21.0.fsc4j_0_0_6.jar,4,false'
$jdtDebugLine = 'org.eclipse.jdt.debug,3.14.0.fsc4j_0_0_2,plugins/org.eclipse.jdt.debug_3.14.0.fsc4j_0_0_2.jar,4,false'

if (((cat bundles.info) -match '^org\.eclipse\.jdt\.core,') -eq $jdtCoreLine -and `
    ((cat bundles.info) -match '^org\.eclipse\.jdt\.debug,') -eq $jdtDebugLine) {
  echo "Skipping bundles.info edits; bundles.info already points to the $productName plugins."
} else {
  echo "Editing bundles.info to point to the $productName plugins..."
  $timestamp = get-date -format "yyyyMMddHHmmss"
  $bundlesInfoCopyName = "bundles.info.orig.$timestamp"
  cp bundles.info $bundlesInfoCopyName
  (cat $bundlesInfoCopyName) `
      -replace '^org\.eclipse\.jdt\.core,.*$', $jdtCoreLine `
      -replace '^org\.eclipse\.jdt\.debug,.$', $jdtDebugLine `
      | out-file bundles.info -encoding ascii
  echo "Done."
}

popd

echo "$productName was installed successfully."
