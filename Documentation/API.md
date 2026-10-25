# Assessment API contract — 8-hour task

## 1. MyChallenges

Method: **GET**

```text
https://devapi-salespoint.leading-point.org/api/Core/v3.0/gamification/MyChallenges?challenge_type=period_target
```

| Parameter | Location | Required value |
| --- | --- | --- |
| `challenge_type` | URL query | `period_target` |

Use the exact singular query requested for this assessment. Do not substitute `challenge_types[]`, `challenge_types`, a JSON body or a different type. Use URLComponents/URLQueryItem. As a defensive display check, omit non-period-target records if the response contains other types.

## 2. LeaveChallenge

Method: **POST**

```text
https://devapi-salespoint.leading-point.org/api/Core/v3.0/gamification/LeaveChallenge
```

```json
{
  "challenge_id": 17
}
```

The real request uses the injected selected challenge's ID. Do not hardcode `17`. Encode a typed body or JSON data, set `Content-Type: application/json`, and send a single confirmed request. The supplied successful request log confirms this devapi endpoint.

## Authentication

Authentication is supplied by `AssessmentAuthentication.swift`, using the same locally configured assessment setup as the previous trainee task. It calls `POST https://devapi-salespoint.leading-point.org/api/Core/v3.0/auth/token/obtain` with the configured API-ready login values, reads `data.access_token`, and caches it in memory. The trainee does not implement login.

The list already calls `AssessmentAuthentication.shared.authorizationHeader()` from `viewDidLoad` through `requestChallenges()`. Implement its GET in `loadChallenges(authorization:)`, which runs only after successful authorization. Before a confirmed Leave request, call the same helper again to reuse or reacquire a valid token. Its emitted string already contains `Bearer `; set it directly as Authorization, add `api-key: APIConfiguration.apiKey` and `Accept: application/json`. Also set `Content-Type: application/json` for LeaveChallenge. See [TokenSetup.md](TokenSetup.md).

If authentication fails, finish loading/submitting and show the error; do not turn it into an empty list or automatically replay a Leave POST.

## Supplied MyChallenges response

Open [my-challenges-provided-response.json](../Fixtures/my-challenges-provided-response.json) for the full supplied example. Contact/shipping values are blanked; challenge/reward identities, UI fields, remote icon URLs and paging metadata are preserved.

The supplied example contains **14 records**, including **8 period_target** challenges: `17, 1, 2, 3, 4, 5, 6, 13`. It is a mixed-type response, not evidence that the requested query already filtered the server result. Keep `challenge_type=period_target` and filter defensively. `data.total` is 14, not the visible filtered count. Pagination is outside this task.

The following is an **excerpt** showing ID 13; other challenge records and unrelated fields are omitted. The complete file is the response reference.

```json
{
  "statusCode": "success",
  "sales_point_trx_id": "aa3a5c68-f8af-4a0d-9492-bdc91b6ac849",
  "message": "",
  "data": {
    "challenges": [
      {
        "id": 13,
        "name": "Demo: Join — Hit 20 Prepaid Activations",
        "challenge_type": "period_target",
        "activity": "Prepaid Activations",
        "progress_title": "Keep going! You're 12 Prepaid Activations away from your reward",
        "state": "in_progress",
        "state_color": "#F59E0B",
        "progress_pct": 40.0,
        "progress_value": 8.0,
        "remaining_value": 12.0,
        "target_value": 20.0,
        "date_start": "2026-10-01",
        "date_end": "2026-11-12",
        "days_to_expiry": 19,
        "rewards": [
          {
            "id": 29,
            "name": "Demo 200 Points",
            "reward": "Demo 200 Points",
            "reward_type": "points",
            "quantity": 1,
            "state": "",
            "state_color": "",
            "can_claim": false,
            "entitlement_id": 0,
            "presentation": "",
            "icon": "https://dev-salespoint.leading-point.org/api/web/s_image/datas/fa706cab50c67e003a0aba9854613cc86d5b3ca287ef64c294acc48bc836269c",
            "background_color": ""
          },
          {
            "id": 33,
            "name": "Demo Silver Badge",
            "reward": "Demo Silver Badge",
            "reward_type": "badge",
            "quantity": 1,
            "state": "",
            "state_color": "",
            "can_claim": false,
            "entitlement_id": 0,
            "presentation": "",
            "icon": "https://dev-salespoint.leading-point.org/api/web/s_image/datas/74e595e8aa8c6814e54ef62e70c3ad059a8fe3094205f954f365f4191d1e6149",
            "background_color": ""
          },
          {
            "id": 94,
            "name": "Demo Gift Piece B",
            "reward": "Demo Gift Piece B",
            "reward_type": "gift",
            "quantity": 1,
            "state": "claimed",
            "state_color": "#8B5CF6",
            "can_claim": false,
            "entitlement_id": 0,
            "presentation": "",
            "icon": "https://dev-salespoint.leading-point.org/api/web/s_image/datas/4f26f74fdc7568cd74803f7c9aa7538da6be1f01395fdd03f8045da7574f2b5d",
            "background_color": ""
          }
        ]
      }
    ]
  },
  "error": {
    "code": "",
    "title": "",
    "message": "",
    "detail": "",
    "extra_data": {}
  }
}
```

See [FieldMapping.md](FieldMapping.md) and both viewDidLoad summaries for the required 8-hour UI fields. Reward actions/images and the extra response metadata are reference only.

Important cases from the supplied data:

- ID 13: in_progress, 8 / 20, 40%, 12 remaining; Leave enabled in the snapshot. Required rewards UI is name + placeholder only.
- ID 4: succeeded, actual 14 / target 12, 100%, remaining -2. Keep the true 14 / 12 label, clamp the bar to full and show Goal Completed. Leave disabled.
- ID 2: failed at 40%, despite fulfilled rewards. Leave disabled; reward state does not change parent participation.
- IDs 1/3/5: enrolled with fulfilled points; the parent participation state remains enrolled. Reward checks are outside the 8-hour scope.
- Every provided reward has can_claim=false and entitlement_id=0. These fields are reference only; no Play/Claim buttons or eligibility logic are required in this timebox.
- expiry_message, grant_id and wheel_id are not present in this example. Read days_to_expiry for expiry text; do not require or invent the absent fields.

The Leave success response is supplied below. Its data is a compact participation update, not a full Challenge. An actual Leave error response has not been supplied; handle the envelope error fields without inventing a recorded error example.

## Navigation / successful leave

Pass the complete model from the selected list cell into details. Do not issue a `ChallengeDetails` GET. Supply the existing `onChallengeLeft` callback when creating details; wire it to remove the selected item from the displayed list locally. Invoke it once after confirmed success, then pop. No additional GET, pull-to-refresh or refresh flow is required in the 8-hour task.


## Captured LeaveChallenge success

The supplied log reports HTTP 200 on the devapi URL above with body `{ "challenge_id": 17 }`. The stored fixtures contain only the JSON request/response bodies; Authorization and device/location header values are not copied into the handoff.

[Request fixture](../Fixtures/leave-challenge-request.json) · [Success fixture](../Fixtures/leave-challenge-success.json)

```json
{
  "statusCode": "success",
  "sales_point_trx_id": "1f84ba2e-bd5e-4a6e-b93c-08dded23be99",
  "message": "",
  "data": {
    "challenge_id": 17,
    "state": "withdrawn",
    "state_color": "#9CA3AF"
  },
  "error": {
    "code": "",
    "title": "",
    "message": "",
    "detail": "",
    "extra_data": {}
  }
}
```

| Field | Handling |
| --- | --- |
| statusCode | Require API success; HTTP 200 alone is insufficient |
| data.challenge_id | Match it to the ID sent, not a reward ID |
| data.state | Expected successful leave result: withdrawn; immediately disable Leave |
| data.state_color | Apply returned participation color; sample #9CA3AF |
| sales_point_trx_id | Diagnostic reference, not navigation identity |
| message | Can be empty on successful operations |
| error | On failure prefer nonempty error.message, then message/error.title |

Decode a dedicated response model with compact leave data. After successful matching response, apply the returned state/color, call onChallengeLeft once and pop; the callback removes this item locally without another GET. This local display update does not imply the server deletes withdrawn records. Missing data, a mismatched ID or unexpected success state is a response error, not confirmed success. No automatic POST retry.

### Snapshot timing

The MyChallenges sample shows ID 17 as enrolled before this request. The newer supplied Leave result shows **17 is now withdrawn**, so do not present it as still eligible. IDs 13 (in_progress) and 3 (enrolled) were eligible in the earlier list snapshot; recheck their current state before any real operation. No live Leave POST was sent while preparing this starter.
