Coding Practices
================

Code Style
----------

* Install the IntelliJ [code style] and [inspections]. Format the source code with these settings in our own projects. Resolve the warnings
  indicated by the inspections.
* In Dataverse try to minimize code changes due to reformatting, so only apply formatting to code that you have changed anyway.
* In the POM file keep the order the of the elements as follows (note that some are optional):
    * `modelVersion`
    * `parent`
    * `groupId`
    * `artifactId`
    * `version`
    * `name`
    * `url`
    * `description`
    * `inceptionYear`
    * `properties`
    * `scm`
    * `dependencyManagement`
    * `dependencies`
    * `build`
    * `repositories`
    * `distributionManagement`
    * `profiles`

### Lombok

Use [Lombok] for:

* Adding loggers with the `@Slf4j` annotation (this names the logger after the fully qualified class name automatically).
* Creating getters, setters and constructors on value objects (i.e. the main purpose of the object is to store values and not to perform operations).

Dependency Management
---------------------
Dependency management of Java projects is done with Maven. Projects should inherit from `dans-dropwizard-project`. The first
thing that most projects will include is `io.dropwizard:dropwizard-core`.

Testing
-------

* Unit test names should be as descriptive as possible. Since this will often involve creating long test names, use `snake_case` instead of `camelCase` here.
* Unit tests will often need to write some temporary data to disk. The location for this is `<project-dir>/target/test/<ClassNameOfUnitTest>`. By working under
  `target` we make sure the unit tests don't interfere with the project itself or the test files we are using for [debugging](#debugging).
* Unit tests should clear their temporary directory **before** the tests start, but leave everything on disk after finishing. This allows you to diagnose
  any problems with a test by running it and inspecting its temporary directory.

Debugging
---------

* For debugging use [dans-dev-tools]{:target=_blank}. Start the program with the `start-*debug.sh` helper scripts and then attach IntelliJ to the VM.
* When debugging you will often want to use temporary test data or configure certain directories for the application under test to use. This is the
  purpose of the `<project-dir>/data` folder.

Packaging and Installation
--------------------------

Documentation
-------------
Each module has its associated documentation site, which is published at io.github.com. The archetype sets up the project with a skeleton site. Use
the `start-mkdocs.sh` script in [dans-dev-tools]{:target=_blank} to start the site locally and see what it looks like after you have made your changes.

Each documentation site follows a standard lay-out and includes the following:

* `index.md`, including these sections:
    * SYNOPSIS - overview of the main command line usage
    * DESCRIPTION - most of your docs should go here
    * ARGUMENTS - a copy of the command line help
    * EXAMPLES (optional) - if relevant
    * INSTALLATION AND CONFIGURATION - boilerplate text about how to install and configure. The configuration settings should be
      documented not here, but in comments in the configuration file.
    * BUILDING FROM SOURCE - boilerplate text about how to build the project
* `dev.md` (optional) - documentation that is only relevant for developers of this module.
* More pages can be added. In general start by adding documentation to the DESCRIPTION section of `index.md`. At the point where
  `index.md` is becoming very large you may start moving the fine print to separate pages and link to those from the DESCRIPTION  
  section.

### JavaDocs

If the project is a library it should include JavaDocs. Extensive code examples are best relegated to separated pages, outside
the JavaDocs, so that you can make full use of the extended Markdown support of mkdocs. You can then link to those from the JavaDocs.


[code style]: dans-intellij-codestyles.xml

[inspections]: dans-intellij-inspections.xml

[dans-dev-tools]: https://github.com/DANS-KNAW/dans-dev-tools#startsh-scripts

[Lombok]: https://projectlombok.org/