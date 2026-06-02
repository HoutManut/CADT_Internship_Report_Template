#import "../func/utils.typ": code-figure, under-construction

= DETAIL CONCEPT <ch_detail_concept>

This chapter presents the detailed concept of the *lorem* system. While the
previous chapter focused on analysis and requirements, this chapter translates
those findings into a concrete design structure: the logical architecture, key
design decisions, the data model, the data flow, the physical architecture, and
the technologies required for implementation.

== Logical Architecture

#lorem(34)

=== System Overview

#lorem(100)

#under-construction(
  "Component diagram",
)

#pagebreak(weak: true)

== Key Design Decisions

This section documents the decisions made before and during implementation that
shaped the system's architecture. Each entry records the rationale behind the
chosen approach; implementation details are covered in @ch_implementation.


== Data Model Design

#lorem(59)

_Throughout this chapter and @ch_implementation, table names are written in
`schema.table` notation; for example, `entity.person_entity` refers to the
`person_entity` table in the PostgreSQL `entity` schema, reflecting the
database's use of named schemas to group related tables by domain._

=== Entity Overview

The system's database organizes persistent data around five core entity groups.
@er_main_diagram shows their relationships.

#code-figure(
  [
    ```
    "ERD: entity-relationship diagram",
    ```
  ],
  caption: [[TODO] database entity-relationship diagram],
) <er_main_diagram>


#pagebreak(weak: true)

== Physical Architecture

#lorem(50)

#lorem(50)

=== Deployment Overview

The physical architecture consists of the following main nodes:


#under-construction(
  "Deployment diagram: physical nodes",
)

#pagebreak(weak: true)

== Tools and Technology Requirements

#lorem(50)

=== Common Technologies

==== Firebase Cloud Messaging (FCM)

Firebase Cloud Messaging is the push notification infrastructure used to alert
officials of new incoming mail in real
time.#footnote[https://firebase.google.com] Integrated into both the NestJS
Worker process and the Flutter client, FCM handles the reliable delivery of
background alerts and foreground data messages. The client uses FCM routing
logic to intercept notification taps and navigate the user directly to the
relevant email detail screen.

#figure(
  image("../media/technologies/Firebase.svg", width: 18%),
  caption: [Firebase logo],
)

==== JSON Web Tokens (JWT)

JSON Web Tokens are a compact, URL-safe standard for representing claims between
two parties. A signed token carries a verifiable payload without requiring a
server-side session lookup on every request, making it well suited for stateless
API authentication. A dual-token strategy using short-lived access tokens and
longer-lived refresh tokens is a common pattern for balancing security and user
experience.

#pagebreak(weak: true)
=== Backend Technologies

==== NestJS (TypeScript)

NestJS is a Node.js framework for building server-side applications in
TypeScript.#footnote[https://nestjs.com] It provides a modular architecture with
native dependency injection, decorator-based guards and interceptors, and
built-in support for REST APIs, WebSockets, and background workers, making it
suitable for complex backend systems that require clear separation of concerns.

#figure(
  image("../media/technologies/NestJS.svg", width: 18%),
  caption: [NestJS logo],
)

==== PostgreSQL

PostgreSQL is an open-source relational database known for its extensibility and
standards compliance. It supports advanced features including native full-text
search via `TSVECTOR`, semi-structured data storage via `JSONB`, and strong ACID
guarantees across complex relational schemas.

#figure(
  image("../media/technologies/PostgreSQL.svg", width: 16%),
  caption: [PostgreSQL logo],
)

==== Sequelize

Sequelize is a promise-based ORM for Node.js that supports multiple relational
databases including PostgreSQL.#footnote[https://sequelize.org] It provides
model definitions, associations, query building, and a migration system through
a TypeScript API, reducing the need to write raw SQL for most database
operations.

#figure(
  image("../media/technologies/Sequelize.svg", width: 16%),
  caption: [Sequelize logo],
)

==== Redis

Redis is an open-source in-memory data store used as a cache, database, and
message broker.#footnote[https://redis.io] Its sub-millisecond read and write
performance makes it well-suited for use cases requiring high throughput and low
latency, such as session storage, rate limiting, and job queue backends.

#figure(
  image("../media/technologies/Redis.svg", width: 16%),
  caption: [Redis logo],
)

==== BullMQ

BullMQ is a Node.js job queue library built on top of
Redis.#footnote[https://docs.bullmq.io] It provides named queues with support
for concurrency control, retry logic, job prioritization, and lifecycle events,
making it suitable for managing background task pipelines where reliability and
ordering are important.

#figure(
  image("../media/technologies/BullMQ.png", width: 39%),
  caption: [BullMQ logo],
)

==== ImapFlow

ImapFlow is a Node.js IMAP client library that provides a modern Promise-based
API for communicating with mail servers.#footnote[https://imapflow.com] It
includes first-class support for the IMAP IDLE extensio, which enables real-time
server-pushed mail event notifications without polling.

#figure(
  image("../media/technologies/imap_flow.png", width: 17%),
  caption: [ImapFlow logo],
)

// ==== class-validator and class-transformer

// class-validator is a decorator-based validation library for TypeScript
// that allows validation rules to be declared directly on class
// properties.#footnote[https://github.com/typestack/class-validator]
// class-transformer complements it by handling serialization and
// deserialization between plain JSON objects and typed class instances,
// including type coercion and property exclusion.


=== Frontend Technologies

==== Flutter (Dart)

Flutter is a cross-platform UI framework developed by Google that compiles a
single Dart codebase to native iOS, Android, and web
targets.#footnote[https://flutter.dev] Its hardware-accelerated rendering engine
draws UI directly to a canvas rather than relying on native components,
producing consistent visual output across all supported platforms.

#figure(
  image("../media/technologies/Flutter.svg", width: 13%),
  caption: [Flutter logo],
)

==== Telegram WebApp API //TODO: Refactor

The Telegram WebApp API allows web applications embedded inside Telegram to
access platform context such as the user's current theme parameters, viewport
dimensions, and native UI behaviors including haptic feedback and the hardware
back button.#footnote[https://core.telegram.org/bots/webapps]

#figure(
  image("../media/technologies/Telegram.svg", width: 12%),
  caption: [Telegram logo],
)

==== GoRouter

GoRouter is a declarative routing package for Flutter built on top of the
Navigator 2.0 API.#footnote[https://pub.dev/packages/go_router] It provides a
URL-based route tree with support for nested routes, route guards via redirect
callbacks, and deep link handling, making it suitable for applications with
complex navigation requirements and authentication boundaries.

==== Provider

Provider is a state management library for Flutter built on top of the
InheritedWidget mechanism.#footnote[https://pub.dev/packages/provider] It allows
application state to be exposed to the widget tree in a structured way, with
scoped rebuilds limited to widgets that explicitly depend on the changed value.

==== Flutter Localization (l10n / ARB)

Flutter's built-in localization framework manages multilingual string resources
via ARB files, with generated delegate classes providing type-safe access to
translated strings throughout the widget
tree.#footnote[https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization]
The active locale is resolved at runtime and can be changed without restarting
the application.

==== Freezed and json_serializable

Freezed is a code generation library for Dart that produces immutable value
classes with built-in equality, copying, and pattern
matching.#footnote[https://pub.dev/packages/freezed] Paired with
json_serializable, it generates type-safe JSON serialization and deserialization
logic from annotated class definitions, eliminating manual mapping between API
response shapes and application data models.

=== Development Tools

==== Visual Studio Code

Visual Studio Code is the primary development environment used for both the
Flutter client and the NestJS backend. It provides Flutter and Dart plugin
support including hot reload and widget inspection, as well as a strong
TypeScript and NestJS plugin ecosystem for backend development.

#figure(
  image("../media/technologies/Visual Studio Code.svg", width: 18%),
  caption: [Visual Studio Code logo],
)

==== NestJS CLI

The NestJS CLI is a command-line tool for scaffolding and managing NestJS
projects.#footnote[https://docs.nestjs.com/cli/overview] It provides commands
for generating modules, controllers, services, and guards following the NestJS
convention, and manages the monorepo build configuration natively.

// ==== Flutter SDK

// The Flutter SDK provides the framework libraries, build tools, Dart compiler,
// and command-line utilities required to run, test, and compile the mobile
// application for all three target platforms. The same SDK installation is
// used to produce the native iOS and Android builds as well as the web build
// deployed as a Telegram Mini App.


==== Git

Git is used for version control across both the Flutter and NestJS codebases.
Branch-based development allows features and fixes to be isolated from the main
branch until reviewed, and the commit history provides a traceable record of
design decisions made throughout the internship period.

#figure(
  image("../media/technologies/Git.svg", width: 18%),
  caption: [Git logo],
)

==== GitLab

.....#footnote[https://gitlab.com]

#figure(
  image("../media/technologies/GitLab.svg", width: 18%),
  caption: [GitLab logo],
)

==== Postman

Postman is used to design, test, and document backend API endpoints before
integrating them into the Flutter client. It is particularly useful for
verifying authentication flows, inspecting paginated response envelopes, and
testing error response shapes against the structured error format expected by
the client.

#figure(
  image("../media/technologies/Postman.svg", width: 18%),
  caption: [Postman logo],
)

==== Android Emulator / iOS Simulator / Physical Device

Emulators and simulators are used throughout development to validate layout and
behavior across Android and iOS screen sizes without requiring physical devices
for every test cycle. Physical devices are used specifically for features that
require real hardware: camera access for the OCR business card scanning flow,
accurate push notification behavior from FCM, and Telegram Mini App rendering
within an actual Telegram installation.

#align(
  center,
  grid(
    columns: (35%, 5%, 35%),
    align: center,
    figure(
      image("../media/technologies/android-studio-icon.webp", width: 70%),
      caption: [Android Studio logo],
    ),
    [],
    figure(
      image("../media/technologies/simulator-2022-11-09.webp", width: 70%),
      caption: [XCode logo],
    ),
  ),
)

==== Figma

Figma is used to design and iterate on screen layouts before implementation. UI
mockups for the inbox shell, compose view, contact detail screen, and onboarding
flow were produced in Figma and used as references during Flutter widget
development, reducing back-and-forth between design and implementation.

#figure(
  image("../media/technologies/Figma.svg", width: 12%),
  caption: [Figma logo],
)

#pagebreak(weak: true)

==== Typst

Typst is used to author this internship report. Its code-based document model
allows figures, tables, citations, and cross-references to be managed
programmatically, and its fast compilation cycle makes iterative drafting
practical throughout the internship period. #footnote[https://typst.app]

#figure(
  image("../media/technologies/typst-logo.png", width: 40%),
  caption: [Typst logo],
)

==== draw.io / Lucidchart / PlantUML

Diagramming tools are used to create architecture, use case, and activity
diagrams for the report. These visual materials improve clarity and help explain
system structure and workflows more effectively.

#under-construction("draw.io / Lucidchart / PlantUML logo")

#pagebreak(weak: true)

=== Development Environment Requirements

#lorem(100)
