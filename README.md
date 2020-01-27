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

First, make sure you have a recent [JDK](https://www.oracle.com/technetwork/java/javase/downloads/index.html) (version 10 or newer) installed. Then, follow the instructions below.

### Windows

Extract the [FSC4J distribution](https://github.com/fsc4j/fsc4j/releases/download/0_0_2/fsc4j_0_0_2-eclipse-java-2019-12-R-win32-x86_64.zip) to any location `X` on your computer and execute `X\eclipse\eclipse.exe`.

### MacOS

Download the [FSC4J distribution](https://github.com/fsc4j/fsc4j/releases/download/0_0_2/fsc4j_0_0_2-eclipse-java-2019-12-R-macosx-cocoa-x86_64.dmg), open it, and drag the Eclipse icon to the Applications icon. Then, open your Applications folder and double-click the Eclipse icon.

### Linux

Extract the [FSC4J distribution](https://github.com/fsc4j/fsc4j/releases/download/0_0_2/fsc4j_0_0_2-eclipse-java-2019-12-R-linux-gtk-x86_64.tar.gz) to any location `X` on your computer and execute `X/eclipse/eclipse`.

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
