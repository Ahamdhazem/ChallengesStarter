import Foundation

/// Supplied constants only. Both networking operations are trainee TODOs.
enum APIConfiguration {
    static let myChallengesURL = "https://devapi-salespoint.leading-point.org/api/Core/v3.0/gamification/MyChallenges"
    static let challengeType = "period_target"
    static let leaveChallengeURL = "https://devapi-salespoint.leading-point.org/api/Core/v3.0/gamification/LeaveChallenge"

    static let tokenObtainURL = URL(string: "https://devapi-salespoint.leading-point.org/api/Core/v3.0/auth/token/obtain")!
    static var username: String { configuredValue("AssessmentAuthUsername") }
    static var password: String { configuredValue("AssessmentAuthPassword") }
    static var deviceToken: String { configuredValue("AssessmentAuthDeviceToken") }

    static var bearerToken: String { configuredValue("AssessmentBearerToken") }
    static var apiKey: String { configuredValue("AssessmentAPIKey") }

    private static func configuredValue(_ key: String) -> String {
        let value = (Bundle.main.object(forInfoDictionaryKey: key) as? String ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return value.hasPrefix("$(") ? "" : value
    }
}


//"api-key": apiKey,
//
//]
//let body = RedemptionRequest(
//items: [
//    RedemptionRequestItem(
//        item_id: 12,
//        quantity: 1,
//        idempotency_key: ""
//    )
//],
//phone_number: "966565432768",
//delivery_address: "Amman",
//delivery_note: ""
//)
//
//let request = AF.request(
//"https://devapi-salespoint.leading-point.org/api/Core/v3.0/loyalty/Redeem",
//method: .post,
//parameters:body,
//encoder:JSONParameterEncoder(),
//headers:headers
//).validate()
//.responseDecodable(of:RedemptionResponse.self){
//    response in
//    switch response.result{
//    case .success(let data): observer(.success(data))
//    case .failure(let error): observer(.failure(error))
//    }
//}
