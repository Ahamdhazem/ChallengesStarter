# Minimum acceptance checklist — 8 hours

Use the supplied screenshots for layout structure, colors and typography. Omit search/filter/Available controls, reward chips, expiry warnings and reward actions. Reward rows only need a name and the bundled placeholder icon. Pixel-perfect polish and animations are not required.

| Check | Expected |
| --- | --- |
| GET | Correct endpoint, supplied auth helper and singular challenge_type=period_target query |
| Mixed response | Only the 8 period_target records displayed from the supplied 14-record example |
| List UI | Reusable XIB cards show model name, status/color, progress, remaining/completed text and dates |
| Selection | Correct complete model reaches details; no additional details request |
| Details | Header/progress data and variable reward rows in UIStackView; safe-area scrolling |
| Active state | Leave enabled for enrolled/in_progress with a valid ID |
| Other states | Leave disabled for succeeded/failed/withdrawn/unknown |
| Confirmation | Cancel sends no request; repeated Confirm taps send at most one POST |
| Success | Matching success/withdrawn response; callback once, pop, remove only that item locally; no GET refresh |
| Failure | Remain in details, show an error and end loading/submitting; no automatic POST retry |
| Basic resilience | Empty list, zero/missing targets, missing optional fields and long text do not crash or break layout |

Manually demonstrate the flow and explain unfinished work. Automated tests and exhaustive error matrices are optional in this timebox. Do not send real Leave transactions solely as a test check; use fixtures/mock responses.

The captured Leave result for ID 17 is a historical withdrawn state. The older MyChallenges sample still shows it enrolled; do not use that stale snapshot as permission to leave it again.

Original screenshots and ChallengeFlow.svg show the full product design. The reduced requirements in README.md take precedence for this assessment.
