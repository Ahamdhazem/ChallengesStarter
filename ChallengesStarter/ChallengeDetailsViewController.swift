import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class ChallengeDetailsViewController: UIViewController {
    let challenge: Challenge
    var onChallengeLeft: (() -> Void)?
    private let disposeBag = DisposeBag()

    init(challenge: Challenge) {
        self.challenge = challenge
        super.init(nibName: "ChallengeDetailsViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenge Details"

        // TODO — 8-HOUR TASK: DETAILS + LEAVE
        // 1. Render the injected Challenge in this XIB; no details GET. Use scrolling and safe-area layout.
        // 2. Show name, state/state_color, dates/activity, progress_title, count/percent and remaining value.
        // 3. Use UIStackView reward rows: name (fallback reward) + reward_placeholder_icon for every item.
        //    No collection view, remote image loading, Play/Claim controls or completion checks are required.
        // 4. Leave enabled only for enrolled/in_progress with a valid ID and no submission in flight.
        //    Confirm with UIAlertController; prevent duplicate taps and never automatically retry POST.
        // 5. POST APIConfiguration.leaveChallengeURL with JSON { "challenge_id": challenge.id }.
        //    Use supplied authorizationHeader(), api-key and Content-Type: application/json.
        // 6. Require statusCode=success, matching data.challenge_id and data.state=withdrawn.
        //    Apply state/state_color, disable Leave, call onChallengeLeft once and pop.
        //    The list callback removes the item locally; no API refresh.
        // 7. On failure, remain here, show a basic error, end submitting and restore eligible Leave.
        // Reference: README.md, Documentation/FieldMapping.md and Fixtures/leave-challenge-success.json.
        // Captured ID 17 is already withdrawn. Use fixtures for checks; do not repeat its live Leave request.

    }
}
