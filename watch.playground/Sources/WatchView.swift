import UIKit
import PlaygroundSupport

open class WatchView : UIView{
    
    public init(){
        let watchFace = UIImage(named: "faceSpace.png")
        let watchStrap = UIImage(named: "strapWhite.png")
        
        let watchViewWidth = (watchFace?.size.width)!/2
        let watchViewHeight = (watchStrap?.size.height)!/2
        let watchBezelHeight = (watchFace?.size.height)!/2
        let watchBezelWidth = (watchFace?.size.width)!/2
        let watchStrapWidth = (watchStrap?.size.width)!/2
        let watchStrapHeight = (watchStrap?.size.height)!/2
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: watchViewWidth,
            height: watchViewHeight))
        
        let watchBezelView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: watchBezelWidth,
            height: watchBezelHeight))
        let watchStrapView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: watchStrapWidth,
            height: watchStrapHeight))
        
        watchStrapView.image = watchStrap
        watchBezelView.image = watchFace
        self.addSubview(watchStrapView)
        watchStrapView.center = CGPoint(x: watchViewWidth/2, y: watchViewHeight/2)
        self.addSubview(watchBezelView)
        watchBezelView.center = CGPoint(x: watchViewWidth/2, y: watchViewHeight/2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
