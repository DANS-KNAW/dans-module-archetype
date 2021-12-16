dans-module-archetype
=====================

Generate a skeleton DANS Module.

SYNOPSIS
--------

       generate-dans-module.sh

DESCRIPTION
-----------

Creates a DANS module based on [DropWizard]({{ dropwizard }}). It uses the [maven archetype plugin]({{ mvn_arch_plugin }}).


ARGUMENTS
----------

The `generate-dans-module.sh` script will interactively query you for argument values.

EXAMPLES
--------

This assumes that you have copied the `generate-dans-module.sh` script to a directory that is on your `$PATH`. On the Mac that could be `/usr/local/bin`

```bash
$ cd ~/git/my-test-projects
$ generate-dans-module.sh
> dans-module-archetype version? (default = 2.0.6): [Enter]
> Module artifactId (e.g., easy-test-module): easy-hello-world [Enter]
> Name module's main package (i.e. the one under nl.knaw.dans.easy): hello [Enter]
> Description (one to four sentences): Simple example \ [Enter]
  that demonstrates that this generation script works. [Enter]
> [INFO] Scanning for projects...
  [INFO]
  [INFO] ------------------------------------------------------------------------
  [INFO] Building Maven Stub Project (No POM) 1
  [INFO] ------------------------------------------------------------------------
  ... <more output>
  Confirm properties configuration:
  groupId: nl.knaw.dans.easy
  artifactId: easy-hello-world
  version: 1.x-SNAPSHOT
  package: nl.knaw.dans.easy.hello
  description: Simple example that demonstrates that this generation script works.
  javaName: EasyHelloWorld
  moduleSubpackage: hello
  name: EASY Hello World
   Y: : [Enter]
> ... <more output>
  [INFO] BUILD SUCCESS
  [INFO] ------------------------------------------------------------------------
  [INFO] Total time: 2.333 s
  [INFO] Finished at: 2017-05-21T10:15:21+02:00
  [INFO] Final Memory: 30M/308M
  [INFO] ------------------------------------------------------------------------
$ cd easy-hello-world [Enter]
$ rm init-project.sh [Enter]
```

Now, you are all set to start developing, except ...

### Delete what you do not use!

The skeleton project contains stubs for a daemon with an HTTP interface and a command line application, and by the time you read this, possibly more stubs. *It
is important to delete the parts that you are not going to use*, to avoid clutter. Yes, even if you may use it in the future, just delete the stuff! For
example: if you only need a command line application, you should delete

* the daemon scripts in `src/main/assembly/install`,
* maybe some other things as well: check!

INSTALLATION AND CONFIGURATION
------------------------------

* Add `https://maven.dans.knaw.nl/releases/` as a plug-in repository if you want to use a release version of this plug-in.
* Clone and build the project if you want to use a snapshot.

DEVELOPMENT
-----------

### Building from source

Prerequisites:

* Maven 3.3.3 or higher

Steps:

        git clone https://github.com/DANS-KNAW/dans-module-archetype.git
        cd dans-module-archetype
        mvn install
