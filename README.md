# Challenges — 8-hour iOS trainee task

Build the core **My Challenges → Details → Leave Challenge** flow in **8 working hours**. Use UIKit, XIBs, Auto Layout and basic RxSwift/RxCocoa bindings. Focus on working behavior and a readable layout matching the design structure; pixel-perfect polish is optional.

## Setup supplied before the timer

- Open `ChallengesStarter.xcodeproj`, scheme **ChallengesStarter**, iPhone simulator, iOS 16+.
- Resolve the pinned RxSwift 6.10.2 and Alamofire 5.12.2 packages before starting the 8 hours. Alamofire is linked to the app target and imported in both controllers for the trainee's GET/POST implementation.
- Authentication helper, endpoint constants, fonts, colors, local artwork, blank XIBs and response examples are supplied.
- `Configuration/App.xcconfig` is already filled with the assessment staging configuration and included in this handoff; no separate secrets file is needed. The list calls the supplied token helper from `viewDidLoad`, then passes Authorization into `loadChallenges(authorization:)`. Login/token acquisition is not trainee work.
- Both screens intentionally start blank. Read their short `viewDidLoad` TODOs.

## Required work

### 1. Models and list API

- Decode the response envelope and only the fields used by the two screens.
- GET `APIConfiguration.myChallengesURL` with the exact query `challenge_type=period_target`.
- Implement the GET in `loadChallenges(authorization:)`, using its supplied Authorization and the configured `api-key`. Bind `authorizationState` for token loading/errors before the existing `requestChallenges()` call.
- Display only period_target records. The supplied example has 8 matching items out of 14.
- Show a loading indicator, a successful empty-list message and a basic HTTP/API/network error message. Always end loading. One page is sufficient.

### 2. Challenge list

- Use a UITableView with reusable `PeriodTargetChallengeCell.xib` cells.
- Each card shows name, status/color, actual/target progress, remaining/completed text and date range.
- Clamp the bar to 0...1 and remaining values to zero; avoid division by zero. Keep long titles readable and status pills compact.
- Search, filters, Available tab, reward summary chips and expiry warnings are not required and may be omitted.

### 3. Details and navigation

- Pass the complete selected model into `ChallengeDetailsViewController(challenge:)`; do not fetch details again.
- Show name, status/color, dates/activity, progress title/count/percentage and a Leave button.
- Show one simple **name + bundled placeholder icon** row per reward, using UIStackView. UICollectionView is not required.
- Reward title comes from name, falling back to reward. Use `reward_placeholder_icon` for every row. Remote image loading, type-specific icons, Play/Claim buttons and completion marks are not required.
- Keep content scrollable and the Leave action clear of the safe area.

### 4. Leave Challenge

- Enable Leave only for enrolled/in_progress with a positive challenge ID; disable it for other states and during submission.
- Use a standard confirmation alert; cancelling sends no request.
- POST `APIConfiguration.leaveChallengeURL` with JSON `{ "challenge_id": selectedChallenge.id }`.
- Prevent repeated submissions and do not automatically retry the POST.
- Read statusCode and data.challenge_id/state/state_color from the supplied success example. Require matching identity and withdrawn state; HTTP 200 alone is not success.
- On success, disable Leave, call `onChallengeLeft` once and pop. Wire that callback to **remove the left item locally** from the list; do not send another GET. This is a deliberate local display update, not an assumption that the server deletes withdrawn records.
- On failure, stay in details, show a useful error, end submitting and restore Leave if the known state still allows it.

### 5. Manual verification and handoff

Demonstrate list loading, model handoff, active/completed/failed/withdrawn Leave states, repeated taps, success and failure handling. Check over-target/missing values and long text. No automated test suite is required within the 8 hours. Use the provided fixtures/mock responses rather than sending real staging transactions solely to run tests.

## Not required in the 8 hours

Search, filters, AvailableChallenges, pagination, pull-to-refresh, automatic refresh after leaving, a details API, UICollectionView for rewards, remote image downloads/caching, reward action/check logic, ClaimReward/Spin/join APIs, animations, localization, persistent storage, a custom confirmation sheet and automated tests. Basic UI/state bindings are enough; no complex Rx architecture is expected.

The screenshots and `Design/ChallengeFlow.svg` contain extra controls from the full design. This README and `Design/Cases.md` define the reduced assessment scope.

## Suggested time allocation

| Work | Hours |
| --- | ---: |
| Read requirements and define minimal models | 0.75 |
| GET integration, loading and basic errors | 1.25 |
| List XIB/cell UI | 1.5 |
| Details UI and simple reward stack | 2 |
| Navigation, Leave API and local list update | 1.5 |
| Manual checks, fixes and handoff | 1 |
| **Total** | **8** |

Checkpoint at 4 hours: the GET/list should work and selecting a row should open details with the correct model. At 8 hours, submit working core behavior and list unfinished polish; optional features do not compensate for a broken core flow.

## Reference files

- `ChallengesStarter/MyChallengesViewController.swift` and `ChallengeDetailsViewController.swift`: short task summaries.
- [FieldMapping.md](Documentation/FieldMapping.md): required UI mappings for this scope.
- [API.md](Documentation/API.md): exact endpoints and supplied JSON examples.
- [Cases.md](Design/Cases.md): minimum acceptance checklist.
- `Fixtures/my-challenges-provided-response.json`: 14 supplied records, 8 period_target.
- `Fixtures/leave-challenge-success.json`: recorded ID 17 → withdrawn. ID 17 is not a reusable live Leave test case.

Return a branch/repository link or clean ZIP with a short `SUBMISSION.md` listing completed requirements, manual checks and unfinished items. Keep the supplied assessment configuration within this private handoff; remove its credential values before publishing a repository. Exclude issued access tokens, build products and personal Xcode state.
