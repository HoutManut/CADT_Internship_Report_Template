= PROJECT ANALYSIS

The system analysis phase involved translating the CDC’s institutional goals into a set of technical mandates. This section outlines the functional and non-functional requirements that governed the development of the cdcIRM platform.

== Requirements Specification
=== Functional Requirements
Functional requirements define the specific actions and behaviors the application must perform to satisfy user needs:

// @typstyle off
#figure(
  table(
    columns: (1fr, 4fr, 8fr),
    inset: 6pt,
    align: center + horizon,
    table.header([*ID*], [*Feature*], [*Description*]),

    [1],
    [Email Linking],
    align(left)[Allow the user to link their mailboxes from various email providers],

    [2],
    [Inbox Listing],
    align(left)[The system shall display a list of email messages with essential metadata such as sender, subject, timestamp, and status (read/unread).],

    [3],
    [Investor Contact Scanning],
    align(left)[The system shall capture an image from the device camera and extract contact data such as name, company, phone number, and email address.],

    [4],
    [Investor Contact Review and Edit],
    align(left)[The system shall allow users to review and correct OCR results before saving them.],

    [5],
    [Investor Contact Storage],
    align(left)[The system shall save validated contact information into the system for future communication use.],

    [6],
    [AI Assistance],
    align(left)[The system shall support AI-based drafting or response suggestions for selected email messages.],

    [7],
    [Notification Handling],
    align(left)[The system shall notify users about pending follow-ups, important messages, or system events.],

    [8],
    [Language Preference],
    align(left)[The system shall support application localization and allow switching between Khmer and English.],
  ),
  caption: "Functional requirements of the cdcIRM system",
) <fr_table>
// @typstyle on

#pagebreak(weak: true)

=== Non-Functional Requirements
- *Multi-lingual Support:* The system must allow users to toggle between Khmer and English instantly, ensuring all system messages, data categories, and UI labels are localized.
- *Security (Contextual Trust):* The system must implement token-based authentication (JWT) and a "Trust Engine" that evaluates session metadata (IP, location, and device ID) to protect sensitive government data.
- *Performance (Cursor-Based Pagination):* To handle high-velocity email feeds without latency, the system must utilize cursor-based pagination to ensure a stable and fluid scrolling experience.
- *Scalability (Adapter Architecture):* The backend must be provider-agnostic, utilizing the Adapter Design Pattern to allow the integration of new email services without structural code changes.
- *Usability:* The interface must adhere to the provided design documentation provided by the company to ensure consistent design and facilitate the usability of CDC staffs.

// @typstyle off
#figure(
  table(
    columns: (1fr, 4fr),
    inset: 6pt,
    align: center + horizon,
    table.header([*Feature*], [*Description*]),

    [Usability],
    align(
      left,
    )[The user interface should be simple, readable, and optimized for mobile use by non-technical and technical staff alike. Important actions should be reachable with minimal taps.],

    [Security],
    align(
      left,
    )[The system should use token-based authentication (JWT), secure API communication over HTTPS, and protected local storage for sensitive session data.],

    [Reliability],
    align(
      left,
    )[The system should handle network failures gracefully by providing clear feedback and retry options without crashing.],

    [Maintainability],
    align(
      left,
    )[The codebase should follow a modular architecture with clear separation between data models, services, state management, and UI components.],

    [Scalability],
    align(
      left,
    )[The design should support future additions such as calendar integration, investor tagging, analytics, and advanced AI modules.],

    [Compatibility],
    align(left)[The mobile application should run on modern Android and iOS devices used by CDC staff.],

    [Localization],
    align(
      left,
    )[The system should support Khmer and English text resources and be designed to allow adding more languages in the future.],
  ),
  caption: "Non-functional requirements",
) <nfr_table>
// @typstyle on

== Use Case Analysis
To understand the interaction between CDC officials and the cdcIRM ecosystem, the following primary use cases were identified:

=== Account Linking
#figure(
  image("../media/empty.png", height: 30%),
  caption: "Account Linking Use Case Diagram",
)<UC-1>
@UC-1 Outlines CDC official authenticates via the CDC internal portal and links their professional Gmail or Outlook account via a secure OAuth2 handshake.

=== Scanning Business Cards
#figure(
  image("../media/empty.png", height: 30%),
  caption: "Business Card Scanning Use Case Diagram",
)<UC-2>
@UC-2 During an investment forum, an official scans an investor's business card using the OCR module, which automatically populates the CDC's centralized investor database.


=== Primary Actor
The primary actor of the system is:

- *CDC Staff User:* Authorized officer using the mobile application for investor communication and follow-up management.

=== Supporting Actors / External Systems
- *CDC Backend API:* Provides authentication, user profile, email synchronization, and contact-related services.
- *OCR Engine:* Extracts text from captured business card or ID images.
- *Notification Service:* Delivers local or push notifications for reminders and updates.
- *AI Service:* Generates drafting suggestions and follow-up assistance.

=== Use Case Diagram (Conceptual)

The formal use case diagram can be inserted as a figure in the final report. For documentation clarity,
the actor-to-use-case relationships are listed below.

#{
  show raw.where(block: false): it => {
    box(
      fill: none,
      inset: (x: 3pt),
      text(fill: oklab(30%, -0.000, -0.050), it.text, font: "Fira Code Retina"),
    )
  }
  [
    - *CDC Staff User* `->` Login, View Inbox, Read Email, Compose Email
    - *CDC Staff User* `->` Scan Contact, Save Contact, Create Follow-up, Receive Reminder
    - *CDC Staff User* `->` AI Draft Suggestion
    - *CDC Backend API* `<->` Authentication, Email Sync, Contact Storage
    - *OCR Engine* `<->` Scan Contact
    - *Notification Service* `<->` Receive Reminder
    - *AI Service* `<->` AI Draft Suggestion
  ]
}

// TODO
#figure(
  image("../media/empty.png", height: 30%),
  caption: "Use case diagram of cdcIRM (Placeholder)",
) <use_case_diagram>

== Process Flow and Activity Concepts

This section describes the main activity flow of the application from login to communication and follow-up.

=== Core Workflow (Narrative)

1. The user opens the application and signs in using CDC credentials.
2. The system validates credentials through the backend and stores a secure session token.
3. The inbox is loaded and synchronized with the backend email service.
4. The user may read emails, compose new messages, or scan a contact card.
5. If scanning is used, OCR extracts text and returns candidate contact fields.
6. The user reviews and edits extracted data before saving.
7. The user can create a follow-up reminder for an investor conversation.
8. The system schedules a reminder and notifies the user at the specified time.

=== Activity Diagram (Conceptual)

// TODO
#figure(
  image("../media/empty.png", height: 30%),
  caption: "Activity Diagram for Main User Workflow (Placeholder)",
) <activity_diagram>

== Data and Database Design

Although the internship project focuses on mobile application development, a clear data model is required
to ensure smooth integration with backend APIs and future expansion. The database design presented here
represents the conceptual structure of the main entities used by the system.

=== Main Entities

The system revolves around the following core entities:

- *User:* CDC staff account and profile information
- *Message:* Email metadata and content
- *Entity:* Investor or company details
- *Attachment (optional):* File metadata associated with emails
- *Audit Fields:* Created/updated timestamps for traceability

=== Conceptual Entity Relationships

- One *User* can access many *Mailboxes*
- One *User* can create many *Follow-up Reminders*
- One *Entity* can be linked to many *Email Messages*
- One *Email Message* can contain multiple *Attachments*
- One *Follow-up Reminder* may reference a *Entity* and/or an *Email Message*

// TODO
#figure(
  image("../media/empty.png", height: 30%),
  caption: "Database Table (Placeholder)",
) <database_table_diagram>

=== Database Design Considerations

The following design principles are important for this project:

- *Normalization:* Separate contacts, emails, and reminders to avoid duplicate data.
- *Traceability:* Include timestamps for creation and updates.
- *Extensibility:* Keep optional fields flexible for future modules (e.g., investor tags, categories, priority).
- *Security:* Avoid storing sensitive tokens or secrets directly in business tables.
- *Integration-first:* The mobile app may not directly access the database, but entity design should align with backend API responses.

=== Sample Data Dictionary (Selected Fields)

#figure(
  table(
    columns: (22%, 18%, 20%, 40%),
    table.header([*Table*], [*Field*], [*Type*], [*Description*]),

    [user], [id], [UUID / String], [Unique identifier of CDC staff user.],
    [message], [thread_id], [String], [Groups related messages into one conversation thread.],
    [message], [is_read], [Boolean], [Read/unread state for UI display.],
  ),
  caption: "Selected Data Dictionary",
) <data_dictionary>

== System Architecture

The project follows a Decoupled Architecture to ensure maintainability and scalability.

== Project Timeline

// @typstyle off
#figure(
  align(center)[
    #set text(size: 10pt)

    #let task-row(..weeks) = (
      ..weeks
        .pos()
        .map(w => {
          if w == [x] {
            table.cell(fill: rgb("#fede6a"))[]
          } else {
            []
          }
        }),
    )

    #table(
      columns: (25%, ..(3.125%,) * 24),
      table.header(
        table.cell(align: center, rowspan: 2)[#strong[Tasks]],
        table.cell(align: center, colspan: 24)[#strong[Weeks]],
        ..range(1, 25).map(i => table.cell(align: center)[#strong[#i]]),
      ),

      // Tasks
      table.cell(align: left)[Requirement Analysis],
      ..task-row([x], [x], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ]),

      table.cell(align: left)[Setup Project],
      ..task-row([ ], [ ], [x], [x], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ]),

      table.cell(align: left)[Development Phase],
      ..task-row([ ], [ ], [ ], [ ], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [ ], [ ]),

      table.cell(align: left)[Testing],
      ..task-row([ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x]),

      table.cell(align: left)[Bug Fixes and UAT],
      ..task-row([ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [ ], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x]),

      table.cell(align: left)[Documentation],
      ..task-row([x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x], [x]),
    )
  ],
  caption: "Activities timeline",
) <activity_table>
// @typstyle on

// #include "../components/timeline.typ"

(DRAFT) @activity_table Outlines the timeline for the entire Internship 2 project span.
For the first month, I spent most of the time initializing the project—including the file structure, dependencies and others.

== Analysis of Technical Architecture

To support maintainability and future growth, the mobile application adopts a layered architecture.

=== Proposed Application Layers

- *Presentation Layer:* Flutter UI screens, widgets, and user interactions
- *State Management Layer:* Handles screen state, loading state, and user actions
- *Domain/Logic Layer:* Business rules such as validation, reminder logic, and workflow handling
- *Data Layer:* API clients, local storage, serialization, and repository implementations
- *External Services Layer:* OCR, AI assistance, notification service, and backend APIs

This separation improves:
- Code readability
- Testing capability
- Feature scalability
- Team collaboration during future maintenance

=== API and Data Exchange Considerations

The backend communication is expected to use JSON-based REST APIs. During analysis, the following
integration concerns were considered:

- Authentication token refresh and secure storage
- Standardized API response format (success/error)
- Consistent date-time parsing (ISO 8601)
- Pagination for inbox and contact lists
- Snake_case API keys mapped to camelCase mobile models
- Error handling for unstable network conditions

These considerations influenced the model and service design in the implementation phase.
