import UIKit
import Alamofire
import RxSwift
import RxCocoa
import RxRelay

final class MyChallengesViewController: UIViewController {
    
    @IBOutlet var tabelView : UITableView!
    
    enum AuthorizationState: Equatable {
        case idle
        case loading
        case ready
        case failed(String)
    }
    
    
    let authorizationState = BehaviorRelay<AuthorizationState>(value: .idle)
    let challengesResponse = BehaviorRelay<ChallengesResponse?>(value:nil)
    
    let staticChalenges = BehaviorRelay
    <[ChallengesResponse.Data.MayChallenge]>(value:[ ChallengesResponse.Data.MayChallenge(
        id:3,
        name:"Summer",
        code:"TRAINING_PERIOD_TARGET",
        challenge_type:"challenge_type",
          state: "in_progress",
          state_color: "#FFAA00",
          date_start: "2026-08-01",
          date_end: "2026-08-10",
        progress_pct: 75,
        progress_value: 150,
        target_value: 200,
        remaining_value: 50,
        progress_title: "200 activations by Aug 10 to unlock reward 🔥",
        activity: "200 Prepaid Activation",
        days_to_expiry: 1,
        expiry_message: "1 day to expiry this challenge.",
        rewards:[ChallengesResponse.Data.MayChallenge.Reward(
            id: 101,
            name: "Spin the Wheel",
            icon: "",
            reward_type: "spin_entitlement",
            state: "granted",
            can_claim: false,
            entitlement_id: 101,
            presentation: "wheel"
        )]
    )])
    
   // let challenges
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
        
        //tabelView.rowHeight.flexibleHeight = .flexibleHeight
        //requestChallenges()
        
        // TODO — 8-HOUR TASK: MY CHALLENGES
        // 1. Build a UITableView with reusable XIB cells; use supplied fonts/assets and basic Rx bindings.
        // 2. Implement loadChallenges(authorization:) below: GET with challenge_type=period_target.
        //    Token acquisition is wired here; add api-key and decode/filter data.challenges.
        // 3. Card fields: name, state/state_color, progress_value/target_value, dates and remaining value.
        //    Clamp progress_pct / 100 to 0...1; succeeded shows Goal Completed; handle missing/zero targets.
        // 4. Bind authorizationState before requestChallenges() for token loading/errors.
        //    Also handle GET loading, empty-list and HTTP/API/network errors on main.
        // 5. Pass the selected complete Challenge to ChallengeDetailsViewController(challenge:).
        //    Wire onChallengeLeft to remove that selected item locally; no new GET after leaving.
        // Scope: no search/filter/Available, pagination, refresh, reward chips or expiry warnings.
        // Reference: README.md, Documentation/FieldMapping.md and the supplied Fixtures.

    
        tableViewConfiguer()
        requestChallenges()

    }
    
    func tableViewConfiguer(){
        
        let nib = UINib(nibName:"PeriodTargetChallengeCell" , bundle: nil)
        
        tabelView.register(nib, forCellReuseIdentifier: "PeriodTargetChallengeCell")
        
        //            .asDriver(onErrorJustReturn: T##ChallengesResponse.Data.MayChallenge).drive(ta)
        // Bind the real GET result (was bound to the static sample), keeping only period_target.
        challengesResponse
            .map { response in
                (response?.data?.challenges ?? [])
                    .filter { $0.challenge_type == APIConfiguration.challengeType }
            }
            .bind(to: tabelView.rx.items(
            cellIdentifier: "PeriodTargetChallengeCell",
            cellType:PeriodTargetChallengeCell.self
        )){
            index , data , cell in
            
            cell.CellData = data
            cell.configure()
            
        }.disposed(by: disposeBag)
    }
    
    /// Supplied setup: authorize first, then start the trainee's GET implementation.
    /// May be called explicitly after an authentication failure; no automatic retries.
    func requestChallenges() {
        guard authorizationState.value != .loading else { return }
        authorizationState.accept(.loading)
        
        AssessmentAuthentication.shared.authorizationHeader()
            .subscribe(onSuccess: { [weak self] authorization in
                guard let self else { return }
//                print("Success",authorization)
                self.authorizationState.accept(.ready)
                self.loadChallenges(authorization: authorization)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { [weak self] value in
                            self?.challengesResponse.accept(value)
                        },
                        onFailure: { error in
                            // TODO: show this to the user (error label / alert).
                            print("[MyChallenges] Load failed:", error.localizedDescription)
                        }
                    )
                    .disposed(by: self.disposeBag)

            }, onFailure: { [weak self] error in
                self?.authorizationState.accept(.failed(error.localizedDescription))
                print( self?.authorizationState.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadChallenges(authorization: String) -> Single<ChallengesResponse> {
        // Authorization is used unchanged (already includes "Bearer "). Never log either header.
        Single.create { observer in
            let parameters = ["challenge_type": APIConfiguration.challengeType]
            let headers: HTTPHeaders = [
                "api-key": APIConfiguration.apiKey,
                "Authorization": authorization,
                "Accept": "application/json",
                "Accept-Language": "en"
            ]

            let request = AF.request(
                APIConfiguration.myChallengesURL,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.queryString,
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChallengesResponse.self) { response in
                #if DEBUG
                // Debug output: URL, HTTP status and raw body only — no headers.
                print("[MyChallenges] URL:", response.request?.url?.absoluteString ?? "nil")
                print("[MyChallenges] HTTP:", response.response?.statusCode ?? -1)
                if case .failure = response.result, let body = response.data {
                    print("[MyChallenges] Body:", String(decoding: body, as: UTF8.self))
                }
                #endif

                switch response.result {
                case .success(let value):
                    // HTTP 200 is not enough: the API envelope must also say success.
                    guard value.statusCode == "success" else {
                        let message = [value.error?.message, value.message, value.error?.title]
                            .compactMap { $0 }
                            .first { !$0.isEmpty } ?? "Unable to load challenges."
                        observer(.failure(ChallengesError.api(message)))
                        return
                    }
                    observer(.success(value))

                case .failure(let error):
                    #if DEBUG
                    if case .responseSerializationFailed(.decodingFailed(let decodingError)) = error {
                        // Names the exact field/type that failed to decode.
                        print("[MyChallenges] Decoding error:", decodingError)
                    } else {
                        print("[MyChallenges] Error:", error)
                    }
                    #endif
                    observer(.failure(error))
                }
            }

            return Disposables.create { request.cancel() }
        }
    }

    enum ChallengesError: LocalizedError {
        case api(String)
        var errorDescription: String? {
            switch self { case .api(let message): return message }
        }
    }
    
    func bindWithchallengesResponse(){
        challengesResponse.subscribe(
            onNext: {_ in 
                print("challengesResponse.value", self.challengesResponse.value?.data)
            }
        ).disposed(by: disposeBag)
    }
    
}
