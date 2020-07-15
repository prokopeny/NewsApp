
import UIKit
import AudioToolbox

class AlertView: UIView {
    class func instanceFromNib() -> AlertView{
        return UINib (nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! AlertView
    }
    
    @IBOutlet weak var errorTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.mainView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.blur.alpha = 0
            }) { (true) in
                self.removeFromSuperview()
            }}
    }
    
}
