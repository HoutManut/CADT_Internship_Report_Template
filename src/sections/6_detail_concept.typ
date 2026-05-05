= DETAIL CONCEPT

This chapter presents the detailed concept of the proposed *cdcIRM* system.
While the previous chapter focused on analysis and requirements, this chapter
translates those findings into a concrete design structure, including the
logical architecture, physical architecture, and the technologies and tools
required for implementation.

The purpose of this chapter is to define how the system is organized technically
before implementation, so that development remains consistent, maintainable,
and aligned with CDC operational needs.

== Logical Architecture

The logical architecture describes the software structure of the *cdcIRM* mobile
application and how its internal components interact. The system follows a
layered and modular design to separate responsibilities and simplify maintenance.

=== Architecture Style

The proposed architecture uses a *layered application design* with modular
features. Each layer has a specific role:

- *Presentation Layer* handles UI screens, widgets, and user interactions.
- *State Management Layer* manages UI state, asynchronous loading, and actions.
- *Domain Layer* contains business rules and workflows.
- *Data Layer* handles API communication, local storage, and model serialization.
- *Service Integration Layer* connects to OCR, notification, and optional AI services.

This design improves readability, testing, and future expansion.

=== Logical Components

// @typstyle off
#figure(
  table(
    columns: (28%, 72%),
    table.header([*Component*], [*Responsibility*]),

    [Authentication Module],
    align(left)[Handles login, token persistence, token refresh, logout, and access control for protected routes.],

    [User Profile Module],
    align(left)[Retrieves and stores authenticated user profile data such as name, role, email, and language preference.],

    [Inbox Module],
    align(left)[Displays email list, supports pagination, search, read/unread state, and navigation to message details.],

    [Email Compose Module],
    align(left)[Supports composing, replying, and forwarding messages with form validation and API submission.],

    [Contact Scan Module],
    align(left)[Captures image input and processes OCR results into structured contact fields.],

    [Contact Management Module],
    align(left)[Allows review, edit, save, and retrieve investor contact records.],

    [Follow-up Module],
    align(left)[Creates and manages reminders linked to contacts or email threads, including due status.],

    [Notification Module],
    align(left)[Schedules and displays reminder notifications for follow-up activities.],

    [Localization Module],
    align(left)[Provides Khmer/English language support and handles text resource loading.],

    [Shared Core Module],
    align(left)[Contains reusable utilities, API response wrappers, error handling, constants, and local storage services.],
  ),
  caption: "Logical components of the cdcIRM application",
)
// @typstyle on

=== Layer Interaction Flow

The following sequence summarizes how layers interact during a common user action,
such as logging in or opening the inbox:

1. The user triggers an action from the UI.
2. The presentation layer forwards the action to state management.
3. State management calls domain logic or a repository.
4. The repository accesses remote APIs or local storage.
5. The data result is mapped into app models.
6. State is updated and reflected back in the UI.

This pattern ensures that user interface code remains independent from backend
communication logic.

=== Data Flow Concept

The application uses JSON-based API communication and local persistence for
session-related data. Data flows through the system as follows:

- *Remote data:* backend API responses (JSON)
- *Model conversion:* snake_case JSON fields mapped to camelCase app models
- *State update:* parsed models stored in memory/state controllers
- *Local persistence:* tokens, preferences, and selected cached values stored locally
- *UI rendering:* widgets consume prepared state models

Date/time values should be converted from ISO 8601 strings into native date-time
objects in the model layer to ensure consistent formatting and sorting.

== Physical Architecture

The physical architecture describes the deployment environment and the hardware/software
elements that host and connect the *cdcIRM* system.

The project is primarily a *mobile client application* connected to CDC-managed backend
services over a secure network. The mobile app does not directly connect to the database;
instead, it communicates through APIs.

=== Deployment Overview

The physical architecture contains the following main nodes:

- *Mobile Device (Client):* Android or iOS device used by CDC staff
- *CDC Backend API Server:* Handles authentication, email operations, contacts, reminders, and tores user, contact, email metadata, and follow-up records
- *File/Attachment Storage (optional):* Stores or proxies attachment files
- *OCR Service:* Processes images for contact extraction
- *Notification Service:* Handles push or local reminder notifications
- *AI Service:* Provides smart drafting assistance

#figure(
  image("../media/empty.png", height: 30%),
  caption: "Physical architecture of the cdcIRM system (Placeholder)",
)

=== Physical Communication Flow

The high-level communication flow is:

+ User opens the mobile app and submits credentials.
+ Mobile app sends authentication request to the CDC backend API over HTTPS.
+ Backend validates credentials and returns access/refresh tokens.
+ Mobile app requests inbox, profile, contact, and follow-up data through APIs.
+ Backend reads/writes data to the database and returns JSON responses.
+ OCR and AI-related features call their respective services via backend.
+ Notification service triggers reminder alerts on the device.

=== Client Device Requirements

The mobile client should run on modern smartphones commonly used by CDC staff.
Minimum practical conditions include:

- Android or iOS device with stable internet connection
- Camera support for OCR/business card scanning
- Notification permission enabled for reminder features

=== Security Considerations in Physical Design

Because the application handles official communication and contact data, physical
deployment should consider the following security measures:

- HTTPS-only API communication
- Permission-based access control
- JWT-based session authentication
- Secure local storage for tokens
- Input validation and server-side authorization checks
- Controlled access to OCR/AI services
- Logging and auditability on backend services

These controls reduce the risk of unauthorized access and data leakage.

== Tools and Technology Requirements

This section defines the technologies and development tools used to design,
implement, test, and maintain the *cdcIRM* internship project.

The selected technologies were chosen based on:
- compatibility with mobile development goals
- maintainability for future CDC developers
- performance and developer productivity
- support for localization and modular architecture
=== Technologies

==== NestJS (TypeScript)

#figure(
  image("../media/technologies/NestJS.svg", width: 18%),
  caption: "NestJS logo",
)

NestJS is the primary backend framework used to build the *cdcIRM* server-side architecture.#footnote[https://nestjs.com] It was selected for its modular structure, which perfectly aligns with the project's monorepo requirement—separating the REST API, the background IMAP Worker, and shared utility libraries into distinct, maintainable packages. Its native dependency injection system simplifies the management of complex services like authentication, database connections, and mail provider adapters.

#pagebreak(weak: true)

==== Flutter (Dart)

#figure(
  image("../media/technologies/Flutter.svg", width: 13%),
  caption: "Flutter logo",
)

Flutter is the main framework used to develop the *cdcIRM* mobile application. It supports cross-platform development, allowing the same codebase to run on both Android and iOS devices with consistent UI and behavior.#footnote[https://flutter.dev] Crucially, its web compilation capabilities allow the application to be deployed as a high-performance *Telegram Mini App*, bridging native mobile and web-based workflows within a single unified codebase.

==== Firebase Cloud Messaging (FCM)

#figure(
  image("../media/technologies/Firebase.svg", width: 18%),
  caption: "Firebase logo",
)

Firebase Cloud Messaging is the push notification infrastructure used to alert officials of new incoming mail in real time.#footnote[https://firebase.google.com] Integrated deeply into both the NestJS Worker process and the Flutter client, FCM handles the reliable delivery of background alerts and foreground data messages. The client utilizes FCM routing logic to intercept notification taps and navigate the user directly to the relevant email detail screen.

==== IMAP Protocol (cPanel)

#figure(
  image("../media/technologies/cPanel.svg", width: 22%),
  caption: "cPanel logo",
)

The Internet Message Access Protocol (IMAP) is the underlying standard used by the backend Worker to communicate with the CDC's mail servers. The initial implementation is specifically tailored to connect to the CDC's cPanel-based email infrastructure.#footnote[https://www.cpanel.net] By consuming IMAP IDLE commands, the Worker listens for new mail events in real time, triggering downstream processing and push notifications without resorting to inefficient constant polling.

==== Telegram WebApp API

#figure(
  image("../media/technologies/Telegram.svg", width: 12%),
  caption: "Telegram logo",
)

The Telegram WebApp API is a specialized integration layer used to transform the Flutter web build into a native-feeling Telegram Mini App. It provides deep platform access, allowing the application to read the user's localized Telegram theme parameters to construct a valid Material color palette dynamically. It also enables native-like device features such as haptic feedback, theme change listeners, and safe area viewport expansion.

==== GoRouter (Dart)

// #figure(
//   image("../media/technologies/f_GoRouter.svg", height: 12%),
//   caption: "GoRouter logo",
// )

GoRouter is the declarative routing solution implemented in the Flutter application. It manages all screen transitions and enforces authentication boundaries through route-level guards. This ensures that unauthenticated users are strictly confined to the onboarding and login flows, while authenticated users are seamlessly routed into the main application shell based on their session state.

==== Freezed & json_serializable (Dart)

// #figure(
//   image("../media/technologies/g_Freezed.svg", height: 12%),
//   caption: "Freezed logo",
// )

Freezed, paired with json_serializable, is the code-generation stack used for all data modeling in the mobile application. It generates immutable value objects and robust JSON serialization/deserialization logic for complex backend responses (like email threads and contact entities). This eliminates an entire class of runtime parsing errors and ensures type safety when passing data across different providers and screens.

==== JSON Web Tokens (JWT)

// #figure(
//   image("../media/technologies/h_JWT.svg", height: 12%),
//   caption: "JSON Web Tokens logo",
// )

JWT is the stateless authentication standard securing all API communications between the Flutter client and the NestJS server. The project implements a strict dual-token strategy—using short-lived access tokens for request authorization and long-lived refresh tokens to silently obtain new access tokens. The backend maintains token revocation capabilities to support the session trust level system, allowing immediate session termination if anomalous activity is detected.

These Dart packages are used to define API models with reduced boilerplate and
safe JSON serialization. They improve code maintainability and ensure consistent
mapping between snake_case API fields and camelCase Dart properties.

==== Local Storage / Secure Storage

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Storage Logo Placeholder*

      ],
    )
  ],
)

Local storage is used to persist user preferences and session-related values on
the device. Sensitive data such as authentication tokens should be stored using
secure storage mechanisms to improve application security.

==== OCR Technology

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *OCR Logo Placeholder*

      ],
    )
  ],
)

OCR technology is used to extract contact information from business cards or ID
images captured with the mobile camera. This reduces manual data entry time and
improves workflow efficiency for staff handling investor contacts.

==== Notification Service

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Notification Logo Placeholder*

      ],
    )
  ],
)

The notification service is used to deliver follow-up reminders and important
alerts to users. It supports better task tracking by helping staff respond to
investor communications on time.

==== Flutter Localization (l10n / ARB)

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Localization Logo Placeholder*

      ],
    )
  ],
)

Flutter localization tools are used to support multilingual content in the app,
especially Khmer and English. This ensures the interface remains accessible and
appropriate for different users within the CDC environment.


=== Tools

==== Visual Studio Code / Android Studio

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *IDE Logo Placeholder*

      ],
    )
  ],
)

These development environments are used for writing, debugging, and organizing
the Flutter project source code. They provide features such as code completion,
terminal integration, and plugin support for Flutter development.

==== Flutter SDK

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Flutter SDK Logo Placeholder*

      ],
    )
  ],
)

The Flutter SDK provides the framework libraries, build tools, and command-line
utilities required to run and compile the mobile application. It is the core
toolchain used throughout the development process.

==== Git

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Git Logo Placeholder*

      ],
    )
  ],
)

Git is used for version control to track code changes and manage development
history. It helps maintain project stability and makes collaboration easier
when multiple contributors work on the same codebase.

==== GitHub / GitLab

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *GitHub / GitLab Logo Placeholder*

      ],
    )
  ],
)

A repository hosting platform is used to store and manage the project remotely.
It supports source backup, collaboration workflows, and issue tracking during
the internship development period.

==== Postman / Insomnia

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Postman / Insomnia Logo Placeholder*

      ],
    )
  ],
)

API testing tools are used to verify backend endpoints before integrating them
into the mobile application. They help inspect request payloads, responses, and
error handling behavior during development.

==== Android Emulator / iOS Simulator / Physical Device

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Device Testing Logo Placeholder*

      ],
    )
  ],
)

Testing environments are required to validate the application on different
platforms and screen sizes. Physical devices are especially important for
camera-based features such as OCR and real notification behavior.

==== Figma

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Figma Logo Placeholder*

      ],
    )
  ],
)

Figma is used to design and preview interface layouts before implementation.
It helps organize screens, user flows, and visual consistency for the mobile
application during planning and refinement.

==== Typst

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Typst Logo Placeholder*

      ],
    )
  ],
)

Typst is used to prepare this very internship project report. It offered structured formatting,
figures, and chapter organization. It provides a clean workflow for maintaining
technical documentation with consistent layout.

==== draw.io / Lucidchart / PlantUML

#figure(
  align(center)[
    #box(
      inset: 8pt,
      radius: 6pt,
      stroke: luma(180),
      fill: luma(248),
      [
        *Diagram Tool Logo Placeholder*

      ],
    )
  ],
)

Diagramming tools are used to create architecture, use case, and activity diagrams
for the report. These visual materials improve clarity and help explain system
structure and workflows more effectively.


=== Development Environment Requirements

A stable development environment should include:

- Flutter SDK properly configured
- Android SDK and emulator support
- Xcode (for iOS build/testing on macOS)
- Git installed and configured
- Access to CDC backend API test environment
- Access credentials for OCR/notification services (if enabled)

These requirements ensure the application can be built and tested reliably during
the internship period.
