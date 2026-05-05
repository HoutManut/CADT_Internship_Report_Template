#import "@preview/timeliney:0.4.0": group, headerline, milestone, task, taskgroup, timeline

#figure(
  caption: "Activities Timeline",
  timeline(
    show-grid: true,
    {
      headerline(group(([*Jan*], 4)), group(([*Feb*], 4)), group(([*Mar*], 4)), group(([*Apr*], 4)))
      headerline(
        group(..range(4).map(n => text("W" + str(n + 1), size: 8pt))),
        group(..range(4).map(n => text("W" + str(n + 1), size: 8pt))),
        group(..range(4).map(n => text("W" + str(n + 1), size: 8pt))),
        group(..range(4).map(n => text("W" + str(n + 1), size: 8pt))),
      )

      let t1_1 = 0
      let t1_2 = t1_1 + 2
      let t2_1 = t1_2 - 1
      let t2_2 = t2_1 + 2

      taskgroup(
        title: strong("Setup Project"),
        style: (stroke: 4pt + black),
        {
          task(
            "Research the market",
            (from: t1_1, to: t1_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Conduct user surveys",
            (from: t2_1, to: t2_2),
            style: (stroke: 4pt + gray),
          )
        },
      )

      let t3_1 = t2_2
      let t3_2 = t3_1 + 2
      let t4_1 = t3_2
      let t4_2 = t4_1 + 2
      let t5_1 = t4_2
      let t5_2 = t5_1 + 2
      let t6_1 = t5_2
      let t6_2 = t6_1 + 1
      let t7_1 = t6_2
      let t7_2 = t7_1 + 1
      let t8_1 = t4_2
      let t8_2 = t8_1 + 6
      taskgroup(
        title: [*Development*],
        style: (stroke: 4pt + black),
        {
          task(
            "Auth",
            (from: t3_1, to: t3_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Home",
            (from: t4_1, to: t4_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Mail",
            (from: t5_1, to: t5_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Notification",
            (from: t6_1, to: t6_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Investor",
            (from: t7_1, to: t7_2),
            style: (stroke: 4pt + gray),
          )
          task(
            "Other (Inc. bug fixes)",
            (from: t8_1, to: t8_2),
            style: (stroke: 4pt + gray),
          )
        },
      )
      let dev_start = t7_2 - 4
      let dev_end = dev_start + 6
      let uat_start = dev_start + 2
      let uat_end = uat_start + 4
      taskgroup(
        title: [*Testing*],
        style: (stroke: 4pt + black),
        {
          task(
            "Dev",
            (from: dev_start, to: dev_start),
            style: (stroke: 4pt + gray),
          )
          task(
            "UAT",
            (from: uat_start, to: uat_end),
            style: (stroke: 4pt + gray),
          )
        },
      )
      task(
        [*Documentation*],
        (from: 3, to: 15),
        style: (stroke: 4pt + black),
      )

      milestone(
        at: 11.25,
        style: (stroke: (dash: "dashed")),
        align(center, [
          *App store launch*\
          March 2026
        ]),
      )
    },
  ),
)
