import UIKit
import PlaygroundSupport
import AVFoundation


open class MusicFace : UIView,AVAudioPlayerDelegate{
    var viewWidth = 0
    var viewHeight = 0
    var audioPlayer : AVAudioPlayer!
    var artWorkView : UIImageView?
    var songName : UILabel?
    var artistName : UILabel?
    var playPauseButton : UIButton?
    
    
    public init (width: CGFloat, height:CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        viewWidth = Int(width)
        viewHeight = Int(height)
        self.backgroundColor = UIColor.black
        initializeAudioPlayer()
        initializeArtwork()
        initializeLabels()
        initializePlayButton()
        
    }
    func initializeAudioPlayer(){
        let path = Bundle.main.path(forResource: "Supersonic", ofType: "m4a")
        let url = URL(fileURLWithPath: path!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
        }catch {
            print("Cant load file")
        }
    }
    func initializeLabels(){
        songName = UILabel(frame: CGRect(x:0, y:CGFloat(viewWidth/2), width :CGFloat(viewWidth), height: CGFloat(viewWidth/8)))
        songName?.textColor = UIColor.white
        songName?.text = "Supersonic"
        songName?.font = UIFont(name: "Helvetica-Bold", size: 22)
        songName?.textAlignment = .center
        self.addSubview(songName!)
        artistName = UILabel(frame: CGRect(x:0, y:CGFloat(viewHeight-(viewWidth/2)-(viewWidth/8)), width :CGFloat(viewWidth), height: CGFloat(viewWidth/8)))
        artistName?.textColor = UIColor.white
        artistName?.text = "Oasis"
        artistName?.textAlignment = .center
        self.addSubview(songName!)
        self.addSubview(artistName!)
    }
    func initializeArtwork(){
        artWorkView = UIImageView(frame: CGRect(x: 0, y: CGFloat((viewHeight-viewWidth/2)), width: CGFloat(viewWidth/2), height: CGFloat(viewWidth/2)))
        artWorkView?.image = UIImage(named: "oasis.jpg")
        self.addSubview(artWorkView!)
        
    }
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton?.setFAIcon(icon: .FAPlay, forState: .normal)
    }
    func initializePlayButton(){
        let width = CGFloat(viewWidth/2)
        let height = CGFloat(viewWidth*3/10)
        playPauseButton = UIButton(frame: CGRect(x: width, y: CGFloat(viewHeight-viewWidth/2), width: width, height: width))
        playPauseButton?.setFAIcon(icon: .FAPlay, iconSize:60, forState: .normal)
        playPauseButton?.setFATitleColor(color: UIColor.white)
        //playPauseButton?.backgroundColor = UIColor.red
        playPauseButton?.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        self.addSubview(playPauseButton!)
    }
    open func playSound(){
        if audioPlayer.isPlaying == false {
            audioPlayer.play()
            playPauseButton?.setFAIcon(icon: .FAPause, iconSize:40, forState: .normal)
        }else{
            audioPlayer.pause()
            playPauseButton?.setFAIcon(icon: .FAPlay, iconSize:40, forState: .normal)
        }
    }
    open func stopSound(){
        audioPlayer.stop()
        playPauseButton?.setFAIcon(icon: .FAPlay, iconSize:40, forState: .normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
