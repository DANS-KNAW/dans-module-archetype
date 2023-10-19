DANS module design
==================

This document describes the design of a DANS module. By following a standard design and coding style we hope to make it easier for developers to understand
each other's code and to make it easier to maintain and extend the code. The design builds on the Dropwizard conventions but go beyond that, filling in the
blanks where Dropwizard is silent and adding some extra conventions that are specific to DANS.

Project structure
-----------------

Projects use the standard Maven project structure. The main source code is in `src/main/java`, the test code in `src/test/java`. The main resources are in
`src/main/resources`, the test resources in `src/test/resources`. The `pom.xml` file is in the root of the project.

DANS specific additions are documented in the table below.

| Directory                      | Description                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------|
| `data/`                        | Contains data files that are used for testing and debugging. **Ignored by Git.**         |
| `docs/`                        | Contains static files for the documentation site.                                        |
| `etc/`                         | Contains configuration files for local testing. **Ignored by Git.**                      |
| `src/main/assembly/dist`       | Contains static files that are used in the creation of the (RPM) distribution package.   |
| `src/main/rpm`                 | RPM scriplets. (Normally, these do not need to be modified.)                             |
| `src/test/resources/debug-etc` | Contains a version of the configuration files that is geared towards debugging locally.  |
| `src/test/resources/test-etc`  | (Optional) contains one of more versions of the configurtion files used in unit testing. |                              

Java packages
-------------

The main package of a module is `nl.knaw.dans.<module-name>`, where `<module-name>` is the name of the module in lowercase, sometimes shortened a bit. Under
this main package we use the [Dropwizard convention]{:target=_blank} with one addition: the classes that capture the configuration settings of the module are in
the `nl.knaw.dans.<module-name>.config` package.

Although Dropwizard does document the intended use of each package the documentation is not very detailed. The table below describes the intended use of each
package in more detail.

| Package name | Description                                                                                                  |
|--------------|--------------------------------------------------------------------------------------------------------------|
| `api`        | Generated [DTO classes](#data-transfer-object-dto-classes).                                                  |  
| `client`     | Client classes for external services.                                                                        |
| `config`     | Configuration classes.                                                                                       |
| `core`       | The core functionality of the module, including domain classes, some of which<br/> may be database entities. |
| `db`         | Data Access Object (DAO) classes.                                                                            |
| `health`     | Health check classes.                                                                                        |
| `resources`  | Implementations of the microservices HTTP API endpoints                                                      |
| `views`      | View classes for rendering an html UI based on a template <br/> (present in some Dropwizard examples).       |

* The `core` package is the most important one. It contains the domain classes and the business logic. The other packages are there to support the `core`. The
  core package may contain a `services` subpackage which contains classes that implement other supporting services. See the section below
  on [Services](#services) for more information.
* `db` should **only** contain DAO classes. These classes should be as simple as possible. They should not contain any business logic. Basically, DAOs are just
  a thin layer on top of the database that deal with finding, creating, updating and deleting entities. Typical methods on a DAO
  are `findById`, `findAll`, `create`, `update` and `delete`.
* Database entities are simply domain classes that are persisted in the database. They are annotated with JPA annotations so that they can be persisted by the
  DAO classes. The DAO classes are responsible for creating, updating and deleting entities. Entities are located in the `core` package because they define domain
  concepts.
* The `resources` package contains the implementation of HTTP endpoints, both API and UI (if present). The API receives and sends back DTOs. Resources should
  also **not** implement business logic.
* The `views` package contains the classes that render the UI. They are called from the resources and use templates to render the UI. This way of creating a UI
  is called server-side rendering. The alternative is to use a JavaScript framework to render the UI on the client side. This is called client-side rendering.
  We will probably use server-side rendering only for very simple UIs.

Generated classes
-----------------
A number of classes are generated from the OpenAPI specification of the module's API, which is defined in a separate project called `<module-name>-api`. If the
microservice calls other microservices, the client code for those microservices is also generated, if possible.

Generated code is not part of the code base, but is generated during the build process. The generated code is located under the `target` directory (
in `target/generated-sources/openapi`).

### Data Transfer Object (DTO) classes

DTO classes define the messages that are sent to and from the microservice. They are usually serialized to and from JSON. The
DTO classes for the microservice are in the `nl.knaw.dans.<module-name>.api` package. The DTO classes for the client classes are in
the `nl.knaw.dans.<client-module-name>.client.api` package.

### Resource interfaces

Resource interfaces define the API endpoints of the microservice. They must be implemented by the resource classes. Both live in the same package namely
`nl.knaw.dans.<module-name>.resources`. However, the resource *interfaces* are generated from the OpenAPI specification and therefore their source files are
located under `target/generated-sources/openapi/` (and not `src/main/java`).

### Client classes

Client classes allow the microservice to call other microservices without having to deal with the details of the HTTP protocol. The generated client code
provides the same DTOs and basically the same resource classes as the microservice itself. The client classes are located in
the `nl.knaw.dans.<client-module-name>.client`. In order to stress the correspondence between the client and the microservice subpackage names are the same:

* `api` - DTO classes
* `resources` - API endpoints

In some cases it makes sense to define a handwritten client class in `src/main/java/<client-module-name>/client`. For example, if the client class needs to do
some extra processing on the DTOs before sending them to the microservice. Another reason could be to provide a façade for a number of endpoints.

Services
--------
Services are classes that implement some supporting functionality that is used by the core of the module. This functionality is usually a bit more generic than
the rest of the core. The service class serves to isolate the core from the details of the implementation of the service. For example, a service may implement
the functionality to send an email. The core may use this service to send an email message to a user, but it does not need to know how the email is sent. This
also makes it easier to unit-test the main core classes, because the service can be mocked.

That said, the boundary between the core and the services is not always clear-cut. That is why the services are located in
the `nl.knaw.dans.<module-name>.core.services`. This makes it clear that these classes are part of the core, but not the main core classes. The classes in
`services` should from time to time be reviewed to see if they can be moved to a separate library. It is a good practise to define an interface for each
service and to use that interface in the core classes. This makes it easier to move the service to a separate library later on.

Typical services are: reading XML files, sending emails, managing a task queue, etc.

In essence, the classes in `client` and `db` are also services. However, because they are more clearly separate from the core, they are not located in the
`core.services` package.

Application and configuration
-----------------------------

The application class is located in the `nl.knaw.dans.<module-name>` package. It is called `<Module-name>Application` and extends `io.dropwizard.core.Application`.
Its purpose is to initialize the application. This means it will create all the bits and pieces that are needed to run the application and connect them
together. It should not do anything else.

The configuration class is located in the `nl.knaw.dans.<module-name>.config` It is called `<Module-name>Configuration` and
extends `io.dropwizard.Configuration`. The configuration is serialized as YAML and is used to configure the application. It is a tree structure with every
level corresponding to a bean class. Since this can amount to a lot of classes, the configuration is usually split up in multiple files, and the helper files
should also be located in the `nl.knaw.dans.<module-name>.config` package.

API definition
--------------

The API is defined in an OpenAPI file. The file is located in a separate project called `<module-name>-api`. The reason why the API is defined in a separate 
project is that is can be distributed as a Maven artifact. This allows other projects to use the API definition to generate client code for the microservice.
The API project is very simple and serves only to create a JAR file with the OpenAPI file in it.

Command line interface
----------------------

Most services will have a command line interface (CLI) that an administrator can use to issue commands to the service. The CLI is implemented in Python code. 
The client code for the CLI is generated from the OpenAPI specification of the API. 

<!-- Link references -->

[Dropwizard convention]: https://www.dropwizard.io/en/latest/manual/core.html#organizing-your-project




