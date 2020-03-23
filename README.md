# Formal Specifications Checker for Java

A modified Eclipse IDE that performs syntax checking, typechecking, and run-time checking of preconditions and postconditions specified as part of the `@pre` and `@post` tags in the Javadoc comments for methods and constructors.

## Example

```java
class GameCharacter {

    private int health;
    
    public int getHealth() { return health; }
    
    /**
     * @pre The specified initial health is nonnegative.
     *    | 0 <= initialHealth
     * @post This game character's health equals the specified initial health.
     *    | getHealth() == initialHealth
     */
    public GameCharacter(int initialHealth) {
        health = initialHealth;
    }
    
    /**
     * @pre The specified amount of health is nonnegative
     *    | 0 <= amount
     * @post This game character's health equals its old health minus the specified amount of health.
     *    | getHealth() == old(getHealth()) - amount
     */
    public void takeDamage(int amount) {
        health -= amount;
    }
}

class Main {

    public static void main(String[] args) {
        new GameCharacter(100).takeDamage(50);
    }
}
```

## Features
- Indicates compilation errors as you type. Compilation errors include syntax errors and type errors, as well as references inside Javadoc comments to elements that are not visible to all clients (such as references to private fields in the Javadoc for a public method) and side-effecting constructs (in particular: assignments) inside Javadoc comments.
- When renaming a program element referenced from a Javadoc comment using the Eclipse Rename refactoring, the Javadoc comment is updated appropriately.
- Run-time checks are performed only if assertions are enabled. Specify `-ea` on the JVM command line to enable assertions.

## Installation instructions

First, make sure you have a recent [JDK](https://www.oracle.com/technetwork/java/javase/downloads/index.html) (64-bit, version 10 or newer) installed. Then, follow the instructions below.

### Windows

If you already have the Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J installed, open the Eclipse home folder (this is the folder containing the `eclipse` application as well as subfolders called `configuration` and `plugins`, among other ones) in Windows Explorer and right-click inside the Windows Explorer window while holding down the Shift key. In the pop-up menu, choose _Open PowerShell window here_. Then, paste the following command into the PowerShell window:

    iex ((new-object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fsc4j/fsc4j/master/install-fsc4j_latest-plugins.ps1'))

This will run a script that installs the latest FSC4J plugins into your existing Eclipse installation.

If you did not yet install Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J, first download and extract the [Eclipse IDE for Java Developers version 2019-12 `.zip` file (_not_ the installer)](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2019-12/R/eclipse-java-2019-12-R-win32-x86_64.zip).

Note: if you get a `Java was started but returned exit code=13` error message, this probably means you installed a 32-bit JDK. Uninstall the 32-bit JDK and install a 64-bit ("x64") JDK, or install a 64-bit JDK and [edit](https://www.eclipse.org/forums/index.php/t/198527/) `eclipse.ini` to point to the 64-bit JDK.

### MacOS

If you already have the Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J installed, simply open a Terminal (which you can find in Applications -> Utilities) and run the following command:

    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/fsc4j/fsc4j/master/install-fsc4j_latest-plugins.sh)"

This will run a script that installs the latest FSC4J plugins into your existing Eclipse installation. If your Eclipse installation still has the `com.apple.quarantine` attribute, the script will prompt for your password so that it can remove the attribute.

Note: this procedure assumes that you installed Eclipse into the default location `/Applications/Eclipse.app`. If you installed it somewhere else, run the following commands:

    curl -fsSLO https://raw.githubusercontent.com/fsc4j/fsc4j/master/install-fsc4j_latest-plugins.sh
    zsh install-fsc4j_latest-plugins.sh /path/to/your/Eclipse/installation

If you did not yet install Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J, first download and install the [Eclipse IDE for Java Developers version 2019-12 `.dmg` package (_not_ the installer)](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2019-12/R/eclipse-java-2019-12-R-macosx-cocoa-x86_64.dmg).

### Linux

If you already have the Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J installed, simply open a Terminal, navigate to the home folder of your Eclipse installation (this is the folder containing subfolders called `configuration` and `plugins`, among other ones) and run the following command:

    bash -c "$(wget -O - https://raw.githubusercontent.com/fsc4j/fsc4j/master/install-fsc4j_latest-plugins-linux.sh)"

This will run a script that installs the latest FSC4J plugins into your existing Eclipse installation.

If you did not yet install Eclipse IDE for Java Developers version 2019-12 or an earlier version of FSC4J, first download and install the [Eclipse IDE for Java Developers version 2019-12 `.tar.gz` archive (_not_ the installer)](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2019-09/R/eclipse-java-2019-09-R-linux-gtk-x86_64.tar.gz).

## FAQ

### I'm not seeing any run-time checking behavior!

Make sure assertions are enabled. Specify `-ea` on the JVM command line. In Eclipse, open your run configuration and add `-ea` under *JVM arguments*.

### When stepping through the run-time checks in the Eclipse debugger, all kinds of platform classes are shown

Filter those out by enabling Step Filtering. Right-click on the offending stack frame in the Threads view and choose `Edit Step Filters...`. Enable `java.*`, `jdk.*`, `sun.*`.

## TODO
- Exceptional postconditions (`@throws` tags)
- Class invariants
- Currently, specifications of abstract methods are type-checked but not checked at run time. Generate run-time checks at dynamically-bound call sites to check the statically resolved spec. Report violations of behavioral subtyping.
- CodeAssist (autocompletion) inside Javadoc
