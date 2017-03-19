import UIKit
import PlaygroundSupport

open class DigitalClock : UILabel{
    
    var currentTime: Date {
        return Date()
    }
    var timer: Timer?
    var viewDivider  = true
    public var weekDay = 1
    public var dayDate = 1
    public init(x:CGFloat, y:CGFloat , width :CGFloat , height :CGFloat){

        super.init(frame: CGRect(
            x: x,
            y: y,
            width: width,
            height: height))
        self.font = UIFont(name: "HelveticaNeue", size: 20)
        self.textColor = UIColor.white
        self.text = "00:00"
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.updateTimeLabel),
            userInfo: nil,
            repeats: true)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let hour = Calendar.current.component(.hour, from: currentTime)
        let minute = Calendar.current.component(.minute, from: currentTime)
        weekDay = Calendar.current.component(.weekday, from: currentTime)
        dayDate = Calendar.current.component(.day, from :currentTime)
        if viewDivider{
            self.text = "\(hour):\(minute)"
            viewDivider = false
        }
        else{
            self.text = "\(hour) \(minute)"
            viewDivider = true
        }
    }
    
    
}
