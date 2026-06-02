#import "../func/utils.typ": under-construction


= PROJECT ANALYSIS AND CONCEPTS <ch_project_analysis>

#lorem(80)

== Requirements Specification

#lorem(17)

=== Functional Requirements

The functional scope is ........ @fr_table lists the functional requirements
across these domains.

// NOTE:
// table usually auto split at the end of pages,
// except if the table is wrapped with #figure then
// it would not break and overflow.
// in this case, we will have to manually break the table
// and leave the trailing table without a figure
#figure(
  table(
    columns: (auto, 2fr, 3fr),
    inset: 6pt,
    align: (center + horizon, center + horizon, left),
    table.header([*ID*], [*Feature*], [*Description*]),

    [FR-01], [#lorem(3)], [#lorem(24)],

    [FR-02], [#lorem(3)], [#lorem(34)],

    [FR-03], [#lorem(3)], [#lorem(32)],
  ),
  caption: [Functional requirements of the lorem system],
) <fr_table>

// Part of the table above
#pagebreak(weak: true)
#table(
  columns: (auto, 2fr, 3fr),
  inset: 6pt,
  align: (center + horizon, center + horizon, left),
  table.header([*ID*], [*Feature*], [*Description*]),

  [FR-04], [#lorem(3)], [#lorem(46)],

  [FR-05], [#lorem(3)], [#lorem(31)],

  [FR-06], [#lorem(3)], [#lorem(14)],

  [FR-07], [#lorem(3)], [#lorem(22)],
)
#pagebreak(weak: true)

=== Non-Functional Requirements

@nfr_table #lorem(35)

// @typstyle off
#figure(
  table(
    columns: (auto, auto),
    inset: 6pt,
    align: (center + horizon, left),
    table.header([*Feature*], [*Description*]),

    [Security],
    [The backend should enforce JWT authentication, HTTPS, rate limiting, input validation, returning structured error codes that do not leak internal details. The client should keep tokens in platform secure storage.],

    [Performance],
    [The backend should enforce server-side pagination on all list endpoints to prevent unbounded data transfer and offload attachment delivery to the CDN so large transfers do not degrade API response times.],

    [Reliability and Availability],
    [The backend should maintain persistent IMAP IDLE connections with automatic reconnection. The client should handle network failures gracefully with clear feedback and retry options.],

    [Maintainability],
    [Both codebases should follow a modular architecture: NestJS modules, controllers, and guards on the backend, and a clear separation of data models, services, state management, and UI on the client.],

    [Scalability],
    [The design should support future additions such supporting additional providers, investor tagging, analytics, and advanced AI modules.],

    [Usability and Localization],
    [The mobile interface should be simple, readable, and optimized for non-technical and technical staff, with important actions reachable in minimal taps, and should support Khmer and English with room for more languages.],

    [Testability and Delivery],
    [The backend should include automated end-to-end and integration tests for critical flows (authentication, mail fetching, permission resolution, contact creation), with delivery managed through a CI pipeline and automated database migrations.],
  ),
  caption: "Non-functional requirements",
) <nfr_table>
// @typstyle on

== Use Case Analysis
#lorem(40)

=== User Account

@UC-1 #lorem(47)

#figure(
  image("../media/diagrams/auth_use_case.png", height: 280pt),
  caption: [User account use case diagram],
) <UC-1>

#pagebreak(weak: true)

== Process Flow and Activity Concepts

This section describes the main activity flow of the system from login to
communication and follow-up, covering both client-side interactions and backend
processing steps.

=== Core Workflow

+ #lorem(31)
+ #lorem(26)
+ #lorem(29)
+ #lorem(16)
+ #lorem(32)
+ #lorem(28)
+ #lorem(27)

=== Activity Diagram

// TODO
#figure(
  [
    #under-construction(" Activity Diagram for Main User Workflow")
  ],
  kind: image, // These 2 lines make this figure appears in the figure table at the start
  supplement: [Figure], //
  caption: [[TODO] Activity Diagram for Main User Workflow],
) <activity_diagram>

== Project Timeline


#under-construction("Update")
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
      columns: (25%, ..(3.125%,) * 24), // 75% / 24
      table.header(
        table.cell(align: center, rowspan: 2)[#strong[Tasks]],
        table.cell(align: center, colspan: 24)[#strong[Weeks]],
        ..range(1, 25).map(i => table.cell(align: center)[#strong[#i]]),
      ),

      // Tasks (EDIT HERE ONLY)
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
  caption: [Activities timeline],
) <activity_table>
// @typstyle on

@activity_table outlines the delivery schedule across the 24-week internship
period. #lorem(80)
