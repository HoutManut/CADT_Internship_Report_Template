#import "../../func/utils.typ": code-figure

== Project Structure

=== Backend Monorepo (NestJS)

#lorem(100)

#code-figure(
  // For the lines to work, install the `Fira Code` font
  // Any longer than this line will be wrapped
  // -----------------------------------------------------------------------|
  [```folder
  api/
  ├── apps/
  │   ├── api/src/
  │   │   ├── routes/v1/  # stuff
  │   │   └── .../        # stuff
  │   └── worker/src/
  │       └── .../        # stuff
  └── libs/
      └── shared/src/
          ├── models/        # Sequelize model classes
          └── domain/        # domain objects
  ```],
  caption: [Backend monorepo directory structure],
) <backend_dir_tree>

Each package has a distinct responsibility, as shown in @backend_dir_tree:

- *`apps/api`*: #lorem(60)

- *`apps/worker`*: #lorem(47)

- *`libs/shared`*: #lorem(40)

#figure(
  table(
    columns: (auto, 1fr),
    align: left,
    table.header([*Module*], [*Responsibility*]),
    [`auth/`],
    [Login, logout, OTP, OAuth session management; token and refresh token
      issuance],

    [`auth/register/`], [New user self-registration flow],
    [`auth/session/`], [Session listing and individual session revocation],
    [`auth/telegram/`], [Telegram Mini App authentication handshake],
    [`data/`],
    [Read-only reference data: departments, roles, genders, countries],

    [`entities/persons/`],
    [Person entity CRUD including profile picture and contact handles],

    [`entities/companies/`], [Company entity CRUD including logo upload],
    [`mail-accounts/`],
    [Link, unlink, and list mail accounts; manage per-account grants],

    [`threads/`],
    [Thread listing with cursor pagination, unread count, and search],

    [`messages/`], [Fetch, compose, reply to, and forward individual messages],
    [`notification-tokens/`], [Register and deregister FCM device tokens],
  ),
  caption: [API resource modules and their responsibilities],
) <api_modules_breakdown>

=== Mobile Application (Flutter)

The Flutter project uses a layer-first structure under `lib/`, separating
infrastructure from feature screens and reusable UI components into four
top-level directories: `core/`, `ui/`, `shared/`, and `telegram/`.

#code-figure(
  [```folder
  mobile/lib/
  ├── core/
  │   ├── api/          # HTTP client + 5 interceptors
  │   ├── providers/    # global state: auth, theme, locale, notifications
  │   ├── repositories/ # data access layer
  │   ├── routes/       # GoRouter config, route constants, transitions
  │   ├── services/     # deep link handling, haptic feedback
  │   ├── storage/      # secure storage, shared preferences, Hive cache
  │   ├── models/       # Freezed + json_serializable API response models
  │   └── l10n/         # ARB localization files
  ├── ui/
  │   ├── home/         # app scaffold, inbox screen, investor listing
  │   ├── login/
  │   ├── message/
  │   ├── registration/
  │   └── splash/
  ├── shared/
  │   ├── components/   # reusable widgets
  │   ├── theme/        # Material theme definitions
  │   └── utils/
  └── telegram/         # Telegram Mini App integration (stub/real split)
  ```],
  caption: [Flutter project structure under lib],
) <flutter_dir_tree>

Each top-level directory serves a distinct concern, as shown in
@flutter_dir_tree:

- *`core/`*: All infrastructure independent of any specific screen.
  - *HTTP client*: Stacks five Dio interceptors for token attachment, silent
    refresh on 401, locale headers, offline detection, and request logging.
  - *Storage*: Separated by security level; `secure_storage.dart` for tokens,
    `local_storage.dart` for preferences, and `hive_storage.dart` for structured
    API response cache.
  - *State*: Global `ChangeNo->tifier` providers registered at the application
    root; feature-level state lives in per-screen controller classes under
    `ui/`.

- *`ui/`*: Feature screens organized by domain. Each subdirectory contains a
  screen widget, a controller class, and a `widgets/` folder for screen-specific
  components.

- *`shared/`*: Reusable widgets, Material theme definitions, and utility
  functions shared across multiple screens.

- *`telegram/`*: Telegram Mini App integration behind an abstract interface.
  `telegram_real.dart` is compiled for the web target and calls the JavaScript
  WebApp API; `telegram_stub.dart` provides no-op implementations for iOS and
  Android, so the rest of the application has no platform-conditional branches.
