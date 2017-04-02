import UIKit
import SpriteKit


open class AtomFace : UIView{
    var viewWidth = 0
    var viewHeight = 0
    
    var sceneView : SKView?
    var scene : SKScene?
    
    var atom1 : SKSpriteNode?
    var atom2 : SKSpriteNode?
    var atom3 : SKSpriteNode?
    
    var path1: UIBezierPath?
    var path2: UIBezierPath?
    var path3: UIBezierPath?
    
    var nucleus : SKSpriteNode?
    
    
    public init(width : CGFloat, height : CGFloat){
        viewWidth = Int(width)
        viewHeight = Int(height)
        super.init(frame: CGRect(x: 0, y: 0, width: width , height: height))
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: width , height: width))
        sceneView?.center = self.center
        scene = SKScene(size: CGSize(width: width ,height: width))
        scene?.scaleMode = .aspectFit
        createAtoms()
        createNucleus()
        createPaths()
        createTransformations()
        createActions()
        drawPaths()
        drawAtoms()
        sceneView?.presentScene(scene)
        scene?.backgroundColor = UIColor.black
        sceneView?.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        self.addSubview(sceneView!)
    }
    
    
    
    func createAtoms(){
        atom1 = SKSpriteNode(imageNamed: "atom")
        atom2 = SKSpriteNode(imageNamed: "atom")
        atom3 = SKSpriteNode(imageNamed: "atom")
        nucleus = SKSpriteNode(imageNamed: "nucleusC")
        
        
        atom1?.scale(to: CGSize(width: viewWidth/15, height: viewWidth/15))
        atom2?.scale(to: CGSize(width: viewWidth/15, height: viewWidth/15))
        atom3?.scale(to: CGSize(width: viewWidth/15, height: viewWidth/15))
    }
    
    func createNucleus(){
        nucleus?.position = CGPoint(x: CGFloat(viewWidth/2), y: CGFloat(viewWidth/2))
        nucleus?.scale(to: CGSize(width: viewWidth/4, height: viewWidth/4))
    }
    
    func createPaths(){
        path1 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: viewWidth-2, height: viewWidth/3))
        path2 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: viewWidth-2, height: viewWidth/3))
        path3 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: viewWidth-2, height: viewWidth/3))
        
        //UIColor.clear.setFill()
        
        path1?.lineWidth = 2
        path1?.fill()
        
        path2?.lineWidth = 2
        path2?.fill()
        
        path3?.lineWidth = 2
        path3?.fill()
        
        
    }
    
    func createTransformations(){
        
        // for translocation of path of the first atom
        let translation1 = CGAffineTransform(translationX: 1, y: CGFloat((viewWidth/2)-(viewWidth/6)))
        let translation2 = CGAffineTransform(translationX: CGFloat((viewWidth/2)), y: CGFloat(viewWidth/2))
        
        let rotationFor2 = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3.2))
        let rotationFor3 = CGAffineTransform(rotationAngle: CGFloat(-1*Double.pi/3.2))
        
        
        path1?.apply(translation1)
        path2?.apply(translation1)
        path3?.apply(translation1)
        
        let bounds = (path2?.cgPath)!.boundingBox
        let center = CGPoint(x:bounds.midY, y:bounds.midY)
        let toOrigin = CGAffineTransform(translationX: -center.x, y: -center.y)
        
        path2?.apply(toOrigin)
        path3?.apply(toOrigin)
        
        path2?.apply(rotationFor2)
        path3?.apply(rotationFor3)
        
        path2?.apply(translation2)
        path3?.apply(translation2)
        
    }
    
    func createActions(){
        let action1 = SKAction.follow((path1?.cgPath)!, asOffset: false, orientToPath: true, duration: 2)
        atom1?.run(SKAction.repeatForever(action1))
        let action2 = SKAction.follow((path2?.cgPath)!, asOffset: false, orientToPath: true, duration: 2.5)
        atom2?.run(SKAction.repeatForever(action2))
        let action3 = SKAction.follow((path3?.cgPath)!, asOffset: false, orientToPath: true, duration: 3)
        atom3?.run(SKAction.repeatForever(action3))
    }
    
    func drawPaths(){
        let pathNode1 = SKShapeNode(path: (path1?.cgPath)!)
        let pathNode2 = SKShapeNode(path: (path2?.cgPath)!)
        let pathNode3 = SKShapeNode(path: (path3?.cgPath)!)
        
        
       
        
        scene?.addChild(pathNode1)
        scene?.addChild(pathNode2)
        scene?.addChild(pathNode3)
        
        pathNode1.strokeColor = UIColor.red
        pathNode2.strokeColor = UIColor.red
        pathNode3.strokeColor = UIColor.red
        
        
    }
    
    func drawAtoms(){
        scene?.addChild(atom1!)
        scene?.addChild(atom2!)
        scene?.addChild(atom3!)
        scene?.addChild(nucleus!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

