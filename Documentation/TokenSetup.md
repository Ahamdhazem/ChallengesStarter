# Supplied authentication — same trainee setup

`AssessmentAuthentication.swift` and the assessment configuration are supplied infrastructure. Implementing login, encryption, push registration or token storage is outside the trainee task. `Configuration/App.xcconfig` already contains the supplied assessment API key and API-ready login values, and is included in the private trainee ZIP. No separate secrets file or manually pasted token is needed.

The helper obtains a token from `POST https://devapi-salespoint.leading-point.org/api/Core/v3.0/auth/token/obtain`, using the configured API-ready username, password, device token and API key unchanged. It validates the HTTP/API envelope and reads **data.access_token**, not a response header.

It caches the token in memory, shares concurrent token acquisition and reacquires when the returned expiry is within 30 seconds. It does not automatically resend challenge GET/POST operations. An explicitly configured raw bearer token takes precedence when the reviewer needs a temporary override.

`MyChallengesViewController.viewDidLoad` already calls `requestChallenges()`, which obtains authorization before invoking `loadChallenges(authorization:)`. Implement the list GET in that method. Bind `authorizationState` before the existing call for loading and authentication errors; `.ready` only means authorization succeeded, not that the GET finished. `requestChallenges()` ignores another call while authorization is pending and permits an explicit retry after failure. Challenge API calls remain trainee TODOs.

In details, obtain authorization only after the user confirms Leave, immediately before constructing the POST. Do not send Leave or request another list load from details `viewDidLoad`. The same helper reuses its cached token when valid:

```swift
AssessmentAuthentication.shared.authorizationHeader()
    .subscribe(onSuccess: { authorization in
        // Build your challenge request here (networking remains trainee work).
        // request.setValue(authorization, forHTTPHeaderField: "Authorization")
        // request.setValue(APIConfiguration.apiKey, forHTTPHeaderField: "api-key")
    }, onFailure: { error in
        // End loading/submitting and show the authentication error.
    })
    .disposed(by: disposeBag)
```

The emitted value already includes `Bearer `. Compose the Single with your API request if preferred. Delivery is on MainScheduler. Opening the list now starts token acquisition automatically when no provided or valid cached token exists; it does not send a challenge GET until the trainee implements the supplied hook.

Both Debug and Release use `Configuration/App.xcconfig`; its settings are read through Info.plist by `APIConfiguration`. The raw bearer-token setting is blank so opening the list obtains a token automatically. `Secrets.example.xcconfig` is an empty reference template, not a required setup step. Never add a newly issued access token to the source or training archive. Share this configured staging setup only within the intended assessment handoff.
