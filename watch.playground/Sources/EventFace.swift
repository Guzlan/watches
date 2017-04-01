import UIKit
import PlaygroundSupport

open class EventFace : UIView{
    var viewWidth = 0
    var viewHeight = 0
    
    var cardFront : UIView!
    var cardBack : UIView!
    
    var wwdcLogoImage : UIImage!
    var wwdcLogoImageView: UIImageView!
    var meImage : UIImage!
    var meImageView : UIImageView!
    
    var name : UILabel!
    var title : UILabel!
    var upNext: UILabel!
    
    var width = 0
    var height = 0
    
    var cardColor =  UIColor(colorLiteralRed: 0.969, green: 0.969, blue: 0.969, alpha: 1.00)
    
    public init (width: CGFloat, height:CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.viewWidth = Int(width)
        self.viewHeight = Int(height)
        self.width = viewWidth
        self.height = (viewWidth * 7/10)
        self.backgroundColor = UIColor.black
        initializeCardFront()
        createFrontCard()
    }
    
    func initializeCardFront(){
        
        cardFront = UIView(frame: CGRect(x: 0, y: CGFloat(viewHeight * 4/10), width: CGFloat(width), height: CGFloat(height)))
        cardFront.layer.cornerRadius = 15
        setBackgroundColor()
        
        self.addSubview(cardFront)
    }
    func createFrontCard(){
        wwdcLogoImage = UIImage(named: "wwdc.png")
        wwdcLogoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: CGFloat(width/2 + 15), height: CGFloat(width/8)))
        //wwdcLogoImageView = UIImageView(image: wwdcLogoImage)
        wwdcLogoImageView.image = wwdcLogoImage
        wwdcLogoImageView.center.x = cardFront.center.x
        cardFront.addSubview(wwdcLogoImageView)
        wwdcLogoImageView.image = wwdcLogoImage
        
        
        meImage = UIImage(named: "me.jpg")
        meImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width/3, height: width/3))
        meImageView.image = meImage
        meImageView.layer.cornerRadius = 10
        meImageView.clipsToBounds  = true
        meImageView.center.y = cardFront.bounds.maxY/2
        cardFront.addSubview(meImageView)
        
        name = UILabel(frame: CGRect(x:CGFloat(width/3), y:CGFloat(cardFront.bounds.maxY/6), width : CGFloat(viewWidth - width/3), height: CGFloat(width/6)))
        name.font = UIFont(name: "Helvetica", size: 18)
        name.text = "Amro"
        name.textColor = UIColor.black
        name.textAlignment = .center
        cardFront.addSubview(name)
        
        title = UILabel(frame: CGRect(x:CGFloat(width/3), y:CGFloat(cardFront.bounds.maxY/3), width : CGFloat(viewWidth - width/3), height: CGFloat(width/6)))
        title.font = UIFont(name: "Helvetica", size: 18)
        title.text = "Scholarship"
        title.textColor = UIColor.black
        title.textAlignment = .center
        cardFront.addSubview(title)
        
        upNext = UILabel(frame: CGRect(x:0, y:CGFloat(cardFront.bounds.maxY - CGFloat(width/6)), width : CGFloat(viewWidth), height: CGFloat(width/6)))
        upNext.font = UIFont(name: "Helvetica", size: 12)
        upNext.textAlignment = .center
        upNext.textColor = UIColor.darkGray
        let upNextString = NSMutableAttributedString(string: "Up Next: Keynote by Tim Cook")
        upNextString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 7))
        //upNextString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 7))
        upNext.attributedText = upNextString
        cardFront.addSubview(upNext)
        
    }
    func initializeCardBack(){
        let width = viewWidth-10
        let height = (viewWidth * 3/4)
        cardFront = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(viewHeight-height-5), width: CGFloat(width), height: CGFloat(height)))
        cardFront.layer.cornerRadius = 15
        cardFront.backgroundColor = cardColor
    }
    func setBackgroundColor(){
        let bc = CAGradientLayer()
        let topColor = UIColor(colorLiteralRed: 1, green: 0.635, blue: 0.169, alpha: 1.00).cgColor
        let bottomColor = UIColor(colorLiteralRed: 1, green: 0.392, blue: 0.325, alpha: 1.00).cgColor
        bc.colors = [topColor, bottomColor]
        bc.locations = [0.0, 1.0]
        bc.frame = cardFront.bounds
        bc.zPosition = -1
        cardFront.layer.insertSublayer(bc, at: 0)
        cardFront.clipsToBounds = true
        //cardBack.layer.insertSublayer(bc, at: 0)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
