# Formal Specifications Checker for Java

A modified version of [the Eclipse IDE](https://www.eclipse.org/downloads/packages/release/2023-12/r)'s Java Development Tools component that performs syntax checking, typechecking, and run-time checking of preconditions and postconditions specified as part of the `@pre` and `@post` tags in the Javadoc comments for methods and constructors, and class invariants specified as part of the `@invar` tags in the Javadoc comments for classes and fields. (Note: run-time checking of class invariants is currently incomplete; currently, only the invariants of `this` are checked.)

The current version also checks grammatical well-formedness and well-typedness of the formal parts of `@throws`, `@may_throw`, `@inspects`, `@mutates`, and `@mutates_properties` clauses, and grammatical well-formedness of the formal parts of `@creates` clauses. It also evaluates `@throws` clauses and reports and error if an exception specified by a `@throws` clause whose condition holds is not thrown, but otherwise does not yet check these clauses at run time.

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

FSC4J is a modified version of the Java Development Tools component of [the Eclipse 2023-12 IDE](https://www.eclipse.org/downloads/packages/release/2023-12/r). First install Eclipse IDE for Java Developers 2023-12 (*FSC4J is not compatible with older or newer releases of Eclipse!*); then, in Eclipse's Help menu, choose *Install New Software...*. Then choose *Add...* to add the FSC4J software site:
- Name: `FSC4J`
- Location: `https://people.cs.kuleuven.be/~bart.jacobs/fsc4j-2023-12`

Then, below *FSC4J*, check *Eclipse Java Development Tools*. You can tell from the version number that this is an FSC4J version of this component. Then click *Next* and follow the on-screen instructions.

After restarting Eclipse, the FSC4J functionality should be active. Enter the following code (File -> New -> Java Project -> Enter name `fsc4jtest` -> Finish -> in the Package explorer (Window -> Show View -> Package Explorer), right-click the project and choose New -> Class. Enter name `Fsc4jTest` and click Finish. Replace the code in the editor (except for the `package` declaration, if any) by the code below); notice that `argss` is underlined:
```java
class Fsc4jTest {
    /** @pre | argss == null */
    public static void main(String[] args) {
    }
}
```
Now, replace `argss` by `args` and run the program; you will get an `AssertionError`. (If you do not get an error, open the Run Configuration and add `-ea` to the VM arguments so that assertions are enabled.)

## Debugging your code

Stepping through your program and inspecting the values of variables at each step using Eclipse's debugging functionality is an important technique for diagnosing crashes and other incorrect program behavior. Unfortunately, the code added to your program by FSC4J degrades the debugging experience. Therefore, we recommend that before starting a debugging session, you temporarily disable FSC4J by appending `_nofsc4j` to your package name using Eclipse's refactoring support. (Right-click on the package in the Package Explorer and choose *Refactor* -> *Rename*.) For example, if your project is in a package called `foo`, rename the package to `foo_nofsc4j`. FSC4J will ignore all FSC4J tags in files starting with a package declaration that contains `nofsc4j`. As a result, it will not add any code to your program and will not impact the debugging experience. After you are done debugging, restore your original package name so that you will again benefit from FSC4J's syntax checks, type checks, visibility checks, and run-time checks.

## FAQ

### How can I tell if the plugin is installed properly?

In Eclipse's About dialog (on Windows: Help -> About Eclipse; on Mac: Eclipse menu -> About Eclipse), choose Installation details. On the Installed Software tab, check the version number of Eclipse Java Development Tools; it should contains `fsc4j`. If not, installation of FSC4J was not successful.

### I am getting orange underlines all over my formal specifications!

This is the Eclipse spell checker. Disable it by hovering over an underlined word and choosing *Disable spell checking* from the menu that appears.

### When installing, I get a "Conflicting Dependency: Eclipse DSL Tools" error

FSC4J conflicts with the Eclipse DSL Tools, which are included with the Eclipse IDE for Java and DSL Developers, but not with the Eclipse IDE for Java Developers. Solution: uninstall the Eclipse DSL Tools in About Eclipse -> Installation Details -> Installed Software -> Eclipse DSL Tools -> Uninstall (or install the Eclipse IDE for Java Developers).

### I'm not seeing any run-time checking behavior!

Make sure assertions are enabled. Specify `-ea` on the JVM command line. In Eclipse, open your run configuration and add `-ea` under *VM arguments*.

Also check that FSC4J was installed successfully. In About Eclipse (in Eclipse's Help menu on Windows; in the Eclipse menu on macOS) -> Installation Details -> Installed Software, check that the version number of Eclipse Java Development Tools mentions `fsc4j`.

### When stepping through the run-time checks in the Eclipse debugger, all kinds of platform classes are shown

Filter those out by enabling Step Filtering. Right-click on the offending stack frame in the Threads view and choose `Edit Step Filters...`. Enable `java.*`, `jdk.*`, `sun.*`.

### When installing, I get "Updates are not permitted"

Make sure your user account has write access to the folder where you installed Eclipse.

## TODO
- Perform typechecking of `@creates` clauses
- When a method or constructor throws an exception, checks that there is a `@throws` or `@may_throw` clause that permits this
- Perform run-time checking of `@may_throw`, `@inspects`, `@mutates`, `@mutates_properties`, and `@creates` clauses
- Perform more complete run-time checking of `@invar` clauses. (Currently, only the invariants of `this` are checked.)
- CodeAssist (autocompletion) inside Javadoc
