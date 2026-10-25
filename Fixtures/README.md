# Response examples and practice fixtures

## Supplied response

`my-challenges-provided-response.json` is the user's actual MyChallenges example. Contact/shipping values are blanked; its 14 challenges, UI data, icon URLs and paging metadata are preserved. Only 8 items are period_target: IDs 17, 1, 2, 3, 4, 5, 6, 13. Use this file to verify response decoding and defensive filtering.

This response contains every can_claim flag as false, no positive entitlement_id, and no eligible Play/Claim example. It also contains fulfilled points in unfinished/failed challenges and over-target values (ID 4: 14 / 12, remaining -2). Follow `Documentation/FieldMapping.md`. For the 8-hour task, render reward names and static placeholders only; reward action/check logic is not required.

## Synthetic examples

These three files remain clearly synthetic for optional visual cases beyond the required name/placeholder rows:

- `my-challenges-period-target.json`: IDs 3 (participating), 4 (succeeded with eligible rewards), 5 (succeeded with used spin).
- `my-challenges-empty.json`: successful empty list.
- `my-challenges-error.json`: API-level error that can arrive with HTTP 200.

Do not combine synthetic IDs/states with the supplied response as if they were the same live records. The starter does not automatically load fixtures or issue any API request. The actual Leave success example is now supplied separately below; no recorded Leave error payload is available.

Also check malformed/null JSON, missing fields/images, unknown states, long text and transport failures. Use an eligible test model with an ID other than 3 to test Leave body encoding, without sending a live transaction.


## Supplied Leave success

- `leave-challenge-request.json`: recorded request body `{ "challenge_id": 17 }`.
- `leave-challenge-success.json`: recorded HTTP-200 business-success envelope with data.challenge_id 17, state withdrawn and state_color #9CA3AF. No Authorization/device/location headers are included.

This result is later than the MyChallenges snapshot, where ID 17 was enrolled. It is a response-model example, not a reason to repeat the request for ID 17. Decode the compact returned data, invoke the local list-removal callback and pop; no API refresh is required. Obtain an actual error example separately if available; existing synthetic API-error fixtures are not captured Leave responses.
