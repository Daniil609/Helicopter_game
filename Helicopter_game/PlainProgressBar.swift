
import UIKit
import Foundation
@IBDesignable
class PlainProgressBar: UIView {
    @IBInspectable var color:UIColor? = .gray
    var progress:CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    private let propgressLayer = CALayer()
    override func draw(_ rect: CGRect) {
        let backgraundMask = CAShapeLayer()
        backgraundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgraundMask
        
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        
        propgressLayer.frame = progressRect
        layer.addSublayer(propgressLayer)
        propgressLayer.backgroundColor = color?.cgColor
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(propgressLayer)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(propgressLayer)
    }
    
    func changeProgress(_ progress1:Double)  {
        progress = CGFloat(progress1)
    }
    
}
