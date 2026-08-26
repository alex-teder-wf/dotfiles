---
name: alex-log-my-work
description: A routine for time tracking in a company's Jira (separate from Wayflyer's own issue tracker)
disable-model-invocation: true
---

## Purpose

Log a day's worklog to Jira. You (the agent) gather what Aleksandr actually
did on a given day from calendar, Linear, GitHub, and (as a fallback) local
git history, then write a short summary and POST it as a Jira worklog.

There is no separate LLM call or script step for the summary — you write it
yourself, following the style rules below exactly.

## Step 1: Determine the date

- Default to today (`{{currentDate}}` context, or ask the shell for today's
  date if unsure).
- If the user's request implies a different day ("yesterday", "last
  Wednesday", an explicit date), resolve it to an absolute `YYYY-MM-DD`.
- State the resolved date back to the user and get explicit confirmation
  before moving on — this is the one thing worth pausing for, since gathering
  data and posting to Jira for the wrong day is wasted work.

## Step 2: Gather activity for that date

Run these in parallel where possible. Every source is best-effort — if a
source errors out or returns nothing, note it and move on rather than
blocking the whole workflow.

1. **Google Calendar** (MCP): list/search events for the confirmed date.
   Pull titles only — you don't need attendee lists or descriptions, just
   enough to know what meetings happened.
2. **Linear** (MCP): issues Aleksandr updated, commented on, or moved status
   on during that date. If the Linear MCP tools require authentication,
   authenticate first rather than skipping this source silently.
3. **GitHub** (use the `gh` CLI via Bash — `gh` is already authenticated in
   this environment):
   - PRs opened, merged, or closed that day (`gh search prs
--author=@me --updated=<date>` or `gh api
users/<username>/events` filtered to `PullRequestEvent`).
   - Review comments Aleksandr left on other people's PRs that day
     (`gh api search/issues -q "commenter:@me updated:<date>"` or similar).
   - Currently open PRs authored by Aleksandr, and PRs merged that day —
     these matter even without new events, since "an open PR is still being
     worked on" is worklog-worthy.
4. **Local git reflog fallback**: only if step 3 found **no GitHub push
   activity** for the date (e.g. offline work, or work not yet pushed). Run
   `git reflog --date=iso -n 50 | grep <date>` in the relevant local repo(s)
   and use it purely to confirm _that_ work happened and roughly _what area_
   — never surface branch names, rebase/checkout mechanics, or commit hashes
   into the summary (see style rules).

## Step 3: Write the summary

Write **3–4 sentences**, following these rules exactly (they come from
direct prior feedback on how these worklogs should read — don't relax them):

- General, simple, short. 3–4 sentences, no more.
- No links, no dates, no time periods.
- No git mechanics: never mention rebasing, checking out, branch names, or
  syncing with main — syncing with main is assumed and never worth stating.
- Describe work at the level of general vector/direction (often what the
  branch or ticket name implies), not granular technical detail.
- Formal, to the point. Must not read like it was written by an LLM — no
  filler, no hedging, no "I worked on".
- Don't mention Aleksandr by name — it's his own worklog, first person is
  implied, so just state actions/topics directly.
- Never invent activity. Only summarize what the gathered sources actually
  show. If a source came back empty, just don't mention it — don't pad.

Reference tone (these are examples of the target voice, not literal content
to reuse):

> App refresh stand-up. Warpspeed pod standup. Design review of new customer
> app screens. Sync with Oliver on further actions.

> Product sprint demo meeting. App Refresh retro. Warpspeed retro and
> planning. Communication with Design and Nathan on app refresh tasks.

> UW working group stand-up. Warpspeed refinement session. Finishing the
> work on pivot-table updates. Solving refresh-cadence issue in UWHome
> Accounting.

## Step 4: Post the worklog to Jira

POST directly — no confirmation step on the summary text itself (only the
date gets confirmed, in Step 1).

- `WORKLOG_TARGET_JIRA_URL` is the **full worklog endpoint** already
  (includes the target issue), read it from the environment at call time —
  don't go looking for it or print it.
- `WORKLOG_TARGET_JIRA_PAT` is the bearer token, same rule.
- Request:

  ```
  POST $WORKLOG_TARGET_JIRA_URL
  Headers:
    Accept: application/json
    Content-Type: application/json
    Authorization: Bearer $WORKLOG_TARGET_JIRA_PAT
  Body:
  {
    "comment": "<the 3-4 sentence summary from Step 3>",
    "started": "<confirmed date>T10:00:00.000+0400",
    "timeSpent": "8h"
  }
  ```

- Treat anything other than a 2xx response as a failure: report the status
  code and response body to the user, don't retry silently.
- On success, confirm to the user with the date and the exact summary text
  that was posted.
