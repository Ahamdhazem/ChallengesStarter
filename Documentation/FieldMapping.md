# Required field mapping — 8-hour scope

Use this reference with the short viewDidLoad TODOs. README.md defines the assessment scope. Extra fields in the full response are not additional implementation requirements.

## List and details

| UI | JSON field / rule |
| --- | --- |
| Identity | challenge.id; pass the complete selected model to details |
| List membership | challenge_type == period_target |
| Name | name |
| Status | state; enrolled → Enrolled, in_progress → In Progress, succeeded → Completed, failed → Failed, withdrawn → Withdrawn |
| Status color | state_color; use a neutral fallback for missing/invalid color |
| Actual / target | progress_value / target_value; preserve true values, including over-target actuals |
| Percent / bar | progress_pct / 100 clamped to 0...1; safe actual/positive-target fallback if percent is absent |
| Remaining | max(remaining_value, 0) + “to go”; succeeded → Goal Completed |
| Dates | date_start/date_end, parsed as yyyy-MM-dd without shifting the calendar date |
| Details headline | progress_title; hide if empty |
| Details activity | activity, optionally prefixed by target_value |
| Reward rows | rewards array; UIStackView, no UICollectionView |
| Reward title | nonempty name, then reward; generic “Reward” if both absent |
| Reward image | Static reward_placeholder_icon for every row |

Keep labels readable, status pills compact, progress finite and content scrollable. Hide empty optional content. Use supplied fonts, header artwork and static glyphs; no remote image handling is required.

## Leave state and response

Enable only when challenge.state is enrolled/in_progress, ID is positive and a submission is not running. Disable for succeeded, failed, withdrawn and unknown states. Reward state/can_claim does not determine Leave eligibility.

After a standard confirmation alert, send one POST with the selected ID. Read the compact response: statusCode, data.challenge_id, data.state and data.state_color. Matching success + withdrawn disables Leave and invokes onChallengeLeft once before popping. The list removes that item locally using the callback; **no GET refresh is required**. The server may retain withdrawn rows: the local removal is only this assessment's display behavior, not a claim about server deletion.

On HTTP/API/network/decoding failure, remain in details, show a useful error and end submitting. Do not automatically retry a Leave POST. Empty success message is valid. A mismatched or incomplete response must not be treated as confirmed success.

## Supplied-data checks

- The MyChallenges example has 14 records but only 8 period_target items: 17, 1, 2, 3, 4, 5, 6, 13.
- ID 13 is in_progress at 8 / 20 (40%, 12 remaining) in that snapshot.
- ID 4 is succeeded with 14 / 12 and remaining -2: show the true count, full bar and Goal Completed.
- ID 2 is failed despite a partial bar: Leave is disabled.
- ID 17 was enrolled in the list snapshot; the newer Leave response changes it to withdrawn. Do not repeat its real Leave request.

## Outside the 8-hour scope

Search/filter/Available, refresh/pagination, reward summary/expiry chips, quantity formatting, downloaded reward.icon images, type-specific icons, background_color, reward completion checks, Play/Claim eligibility and all reward transactions are not required. The full response and assets retain these fields/artwork for reference only. Points/reward states must not override the parent challenge state.
