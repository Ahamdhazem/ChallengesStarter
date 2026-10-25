import UIKit

final class PeriodTargetChallengeCell: UITableViewCell {
    // TODO: Build the period_target card in this cell's XIB and connect its outlets.
    // TODO: Add configure(with:) using the selected Challenge model; reset reusable UI.
    // TODO: Keep status intrinsic-sized and configure every label/icon/progress from data.
    @IBOutlet var name : UILabel!
    @IBOutlet var status : UIButton!
    @IBOutlet var progressView : UIProgressView!
    @IBOutlet var date : UILabel!
    @IBOutlet var expirDate : UILabel!

    var CellData :ChallengesResponse.Data.MayChallenge!
    func configure(){
        name.text = CellData.name
        status.titleLabel?.text = CellData.state
        date.text = CellData.date_start + " " + CellData.date_end
        expirDate.text = CellData.expiry_message
    }
}
