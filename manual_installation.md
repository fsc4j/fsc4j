# Manual installation instructions

Note: most people do not need to read this. The [automated installation instructions](README.md) are the recommended way to install FSC4J. You need to read this only if they do not work for you.

## Manual installation steps

### Background: what is FSC4J?

FSC4J consists of _replacements_ for two of the core Eclipse Java Development Tooling (JDT) _plugins_: `org.eclipse.jdt.core` and `org.eclipse.jdt.core.compiler.batch`.

Which plugins are loaded when you start Eclipse is determined by the `bundles.info` file in the `org.eclipse.equinox.simpleconfigurator` subfolder of the `configuration` folder in your Eclipse installation's home folder. (The home folder is the folder that contains the `eclipse.ini` file and the `plugins` and `configuration` subfolders, amongst other things.)

### Step 1: download the latest FSC4J plugins into the `plugins` folder

First, download the latest `org.eclipse.jdt.core` and `org.eclipse.jdt.core.compiler.batch` plugins from [here](https://github.com/fsc4j/fsc4j/releases) into the `plugins` subfolder of your Eclipse installation's home directory. (As of this writing, the latest version of the FSC4J `org.eclipse.jdt.debug` plugin is [version 0.8.4](https://github.com/fsc4j/fsc4j/releases/tag/0_8_4).)

*Note: if the procedure on this page does not work for you, try removing the original `org.eclipse.jdt.core` and `org.eclipse.jdt.core.compiler.batch` plugins from the `plugin` folder so that only the FSC4J versions of these plugins are present in this folder.*

### Step 2: update `bundles.info` to point to these plugins

Open the `bundles.info` file in the `org.eclipse.equinox.simpleconfigurator` subfolder of the `configuration` subfolder of your Eclipse home folder into any plain text editor, such as Notepad on Windows or TextEdit on macOS.

- Find the line starting with `org.eclipse.jdt.core,` and replace it with

      org.eclipse.jdt.core,A.B.0.vfsc4j_X_Y_Z,plugins/org.eclipse.jdt.core_A.B.0.vfsc4j_X_Y_Z.jar,4,false

  where `A.B` and `X_Y_Z` are the version number of the FSC4J `org.eclipse.jdt.core` plugin you downloaded.

- Find the line starting with `org.eclipse.jdt.core.compiler.batch,` and replace it with

      org.eclipse.jdt.core.compiler.batch,A.B.0.vfsc4j_X_Y_Z,plugins/org.eclipse.jdt.core.compiler.batch_A.B.0.vfsc4j_X_Y_Z.jar,4,false

  where `A.B` and `X_Y_Z` are the version number of the FSC4J `org.eclipse.jdt.core.compiler.batch` plugin you downloaded.

### Step 3 (macOS only): remove the quarantine attribute

macOS refuses to start Eclipse after you modified it. To fix this, remove the quarantine attribute, by opening a Terminal (an application which you can find in Applications -> Utilities) and entering the following command:

    sudo xattr -dr com.apple.quarantine /Applications/Eclipse.app

### Step 4: you're done!

If you now start the modified Eclipse, the FSC4J functionality should be active. To check which version of FSC4J you are running, choose _About Eclipse_ (in the _Help_ menu (Windows) or the _Eclipse_ menu (macOS)) -> _Installation details_ -> _Plugins_, and enter `jdt.core` into the _Filter_ field.
