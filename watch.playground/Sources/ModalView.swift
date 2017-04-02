import UIKit
import PlaygroundSupport

open class ModalView : UIView{
    
    var aboutLabel : UILabel!
    var bodyText : UILabel!
    
    var width = 0
    var height = 0
    
    var swiftLogoView : UIImageView!
    
    var particleEmitter : CAEmitterLayer!
    
    var cells = [CAEmitterCell]()
    
    public init(width : CGFloat, height : CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.width = Int(width)
        self.height = Int(height)
        setBackgroundColor()
        createParticleEmitter()
        setupParticleCells()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        setupLabels()
        setupLogo()
    }
    func setBackgroundColor(){
        let bc = CAGradientLayer()
        let topColor = UIColor(colorLiteralRed: 0.984, green: 0.525, blue: 0.153, alpha: 1.00).cgColor
        let bottomColor = UIColor(colorLiteralRed: 1.00, green: 0.227, blue: 0.102, alpha: 1.00).cgColor
        bc.colors = [topColor, bottomColor]
        bc.locations = [0.0, 1.0]
        bc.frame = self.bounds
        bc.zPosition = -1
        self.layer.insertSublayer(bc, at: 0)
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
            cell.velocity = 100
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.scale = 0.5
            cell.spinRange = 3
            cell.contents = UIImage(named: "\(i).png")!.cgImage
            cells.append(cell)
            particleEmitter.emitterCells = cells
        }
        particleEmitter.emitterCells = cells
        self.layer.addSublayer(particleEmitter)
        
        
    }
    func setupLogo(){
        swiftLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: width/6, height: width/6))
        swiftLogoView.image = UIImage(named:"animal.png")
        self.addSubview(swiftLogoView)
        
    }
    func setupLabels(){
        aboutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height/4))
        bodyText = UILabel(frame: CGRect(x: 0, y: height/4, width: width-10, height: height * 3/4))
        
        
        aboutLabel.text = "About This Project"
        aboutLabel.textAlignment = .center
        aboutLabel.font = UIFont(name: "Helvetica", size: 26)
        aboutLabel.textColor = UIColor.white
        
        bodyText.center.x = self.center.x
        
        bodyText.lineBreakMode = .byWordWrapping
        bodyText.numberOfLines = 0
        bodyText.text =
        "Swift Playgrounds is a powerful tool that allows rapid, interactive prototyping of many iOS and macOS technologies. This project shows an imaginative extension of what swift playgrounds can offer for the Apple Watch in the future, by creating watch faces that are tailored to one's liking. Click outside this box to begin."
        
        bodyText.textAlignment = .center
        bodyText.font = UIFont(name: "Helvetica", size: 16)
        bodyText.textColor = UIColor.white
        
        self.addSubview(aboutLabel)
        self.addSubview(bodyText)
        
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
