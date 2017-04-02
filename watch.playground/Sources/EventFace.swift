import UIKit
import PlaygroundSupport

open class EventFace : UIView{
    var viewWidth = 0
    var viewHeight = 0
    
    var cardView : UIView!
    var cardFront : UIView!
    var cardBack : UIView!
    
    var wwdcLogoImage : UIImage!
    var wwdcLogoImageView: UIImageView!
    var meImage : UIImage!
    var meImageView : UIImageView!
    
    var particleEmitter : CAEmitterLayer!
    
    var cells = [CAEmitterCell]()
    
    var name : UILabel!
    var title : UILabel!
    var upNext: UILabel!
    
    var isFlipped = false
    
    var width = 0
    var height = 0
    
    var cardColor =  UIColor(colorLiteralRed: 0.969, green: 0.969, blue: 0.969, alpha: 1.00)
    
    public init (width: CGFloat, height:CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.viewWidth = Int(width)
        self.viewHeight = Int(height)
        self.width = viewWidth
        self.height = (viewWidth * 7/10)
        createParticleEmitter()
        setupParticleCells()
        self.backgroundColor = UIColor.black
        self.clipsToBounds = true
        initializeCardContainer()
        initializeCardBack()
        initializeCardFront()
        setBackgroundColor()
        createFrontCard()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    func initializeCardContainer(){
        cardView = UIView(frame: CGRect(x: 0, y: CGFloat(viewHeight * 4/10), width: CGFloat(width), height: CGFloat(height)))
        cardView.layer.cornerRadius = 15
        self.addSubview(cardView)
    }
    func initializeCardBack(){
        cardBack = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        cardBack.layer.cornerRadius = 15
        let qrCodeView = UIImageView(frame: CGRect(x: 0, y: 0, width: CGFloat(width * 2/3), height: CGFloat(width * 2/3)))
        let qrImage = UIImage(named: "amber.png")
        qrCodeView.image = qrImage
        cardBack.addSubview(qrCodeView)
        qrCodeView.center = cardBack.center
        
        cardView.addSubview(cardBack)
    }
    func initializeCardFront(){
        cardFront = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        cardFront.layer.cornerRadius = 15
        cardView.addSubview(cardFront)
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
        name.textColor = UIColor.white
        name.textAlignment = .center
        cardFront.addSubview(name)
        
        title = UILabel(frame: CGRect(x:CGFloat(width/3), y:CGFloat(cardFront.bounds.maxY/3), width : CGFloat(viewWidth - width/3), height: CGFloat(width/6)))
        title.font = UIFont(name: "Helvetica", size: 18)
        title.text = "Scholarship"
        title.textColor = UIColor.white
        title.textAlignment = .center
        cardFront.addSubview(title)
        
        upNext = UILabel(frame: CGRect(x:0, y:CGFloat(cardFront.bounds.maxY - CGFloat(width/6)), width : CGFloat(viewWidth), height: CGFloat(width/6)))
        upNext.font = UIFont(name: "Helvetica", size: 12)
        upNext.textAlignment = .center
        upNext.textColor = UIColor.white
        let upNextString = NSMutableAttributedString(string: "Up Next: Workshop 2")
//        upNextString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 7))

        upNext.attributedText = upNextString
        cardFront.addSubview(upNext)
        
    }
    
    func createParticleEmitter(){
        particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: width/2, y: -20)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: width, height: 1)
    }
    func setupParticleCells(){
        for i in 0..<6{
            let cell = CAEmitterCell()
            cell.birthRate = 3
            cell.lifetime = 5
            cell.lifetimeRange = 0
            cell.velocity = 50
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.scale = 0.25
            cell.spinRange = 3
            cell.contents = UIImage(named: "\(i).png")!.cgImage
            cells.append(cell)
            particleEmitter.emitterCells = cells
        }
        particleEmitter.emitterCells = cells
        self.layer.addSublayer(particleEmitter)
        
        
    }
    
    func setBackgroundColor(){
        
        let topColor = UIColor(colorLiteralRed: 0.984, green: 0.525, blue: 0.153, alpha: 1.00).cgColor
        let bottomColor = UIColor(colorLiteralRed: 1.00, green: 0.227, blue: 0.102, alpha: 1.00).cgColor
        
        let bc = CAGradientLayer()
        bc.colors = [topColor, bottomColor]
        bc.locations = [0.0, 1.0]
        bc.frame = cardFront.bounds
        bc.zPosition = -1
        cardFront.layer.insertSublayer(bc, at: 0)
        cardFront.clipsToBounds = true
        
        
        let bc2 = CAGradientLayer()
        bc2.colors = [topColor, bottomColor]
        bc2.locations = [0.0, 1.0]
        bc2.frame = cardFront.bounds
        bc2.zPosition = -1
        cardBack.layer.insertSublayer(bc2, at: 0)
        cardBack.clipsToBounds = true
    }
    func flipCard(){
        if !isFlipped{
            UIView.transition(from: cardFront, to: cardBack, duration: 1.0, options: .transitionFlipFromLeft, completion: nil)
            isFlipped = true
        }else{
           UIView.transition(from: cardBack, to: cardFront, duration: 1.0, options: .transitionFlipFromRight, completion: nil)
            isFlipped = false
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
