//: Playground - noun: a place where people can play

import UIKit
import SceneKit
import SpriteKit
import PlaygroundSupport

class Watch: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,SCNSceneRendererDelegate{
    
    var mainBackgroundXDimension = 0
    var mainBackgroundYDimension = 0
    
    /* VIEWS */
    let leftView = UIView()
    let rightView = UIView()
    var mainStackView = UIStackView()
    var leftStackView = UIStackView()
    let leftTopView = UIView()
    let leftButtomView = UIView()
    let leftTopStackView = UIStackView()
    let leftBottomStackView = UIStackView()
    var rotationVector = SCNVector4()
    
    let watchFaceWidth = 104*1.5
    let watchFaceHeight = 130*1.5
    var watchImageView = WatchView()
    var watchImageCenterX : CGFloat = 0
    var watchImageCenterY : CGFloat = 0
    
    var collectionView: UICollectionView!
    var timerD: DispatchSourceTimer!
    
    let sceneView : SCNView?
    let scene  = SCNScene()
    let planetNode = SCNNode()
    
    var atomFace : AtomFace?
    
    var musicFace : MusicFace?
    
    var planetNamesOrder = [String]()
    
    var planets = [String: UIImage]()
    
    var planetCellViews = [SCNView]()
    
    var atomCollectionView : AtomFace?
    
    var musicCollectionView : UIImageView?
    
    
    var cellLabels = [UILabel]()
    
    /* TIME OBJECTS */
    var currentTime: Date {
        return Date()
    }
    
    var timer: Timer?
    var viewDivider  = true
    var weekDay = 1
    var dayDate = 1
    let weekDays = ["SUN", "MON", "TUE","WED", "THU", "FRI", "SAT"]
    
    
    
    
    
    /* LABELS */
    var digitalTime : UILabel?
    var currentDate : UILabel?
    
    var watchFacesLabel = UILabel()
    var watchCaseAndBandLabel = UILabel()
    
    
    
    public init(width : CGFloat, height : CGFloat){
        sceneView = SCNView(frame: CGRect(x:0,y:0,width:watchFaceWidth,height:watchFaceHeight))
        
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height))
        
        
        mainBackgroundXDimension = Int(width)
        mainBackgroundYDimension = Int(height)
        setBackgroundColor()
        
        createSplitViews()
        createWatchView()
        createPlanetsDictionary()
        createCollectionViewLabels()
        createPlanetsCollectionViews()
        createAtomCollectionView()
        createMusicCollectionView()
        createCollectionView()
        createStackViews()
        watchImageCenterX = watchImageView.frame.width/2 - 4
        watchImageCenterY = watchImageView.frame.height/2
        initializeDigitalTime()
        initializeCurrentDate()
        initializeAtomScene()
        initializePlanetScene()
        initializeMusicFace()
        tryTimerD()
    }
    
    
    func createStackViews(){
        mainStackView.frame = self.bounds
        mainStackView.addArrangedSubview(leftView)
        mainStackView.addArrangedSubview(rightView)
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        createLeftStackView()
        self.addSubview(mainStackView)
        
    }
    func tryTimerD(){
        
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timerD = DispatchSource.makeTimerSource(flags:  DispatchSource.TimerFlags(rawValue: UInt(1)), queue: queue)
        timerD.setEventHandler { [weak self] in
            self?.updateTimeLabel()
        }
        timerD.scheduleRepeating(deadline: .now(), interval: 0.5)
        timerD.resume()
    }
    func createLeftStackView(){
        leftStackView.frame = leftView.bounds
        leftStackView.addArrangedSubview(watchFacesLabel)
        leftStackView.addArrangedSubview(collectionView)
        leftStackView.addArrangedSubview(watchCaseAndBandLabel)
        leftStackView.axis = .vertical
        leftStackView.distribution = .fillProportionally
        leftStackView.alignment = .center
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(leftStackView)
    }
    
    func createWatchView (){
        rightView.addSubview(watchImageView)
        watchImageView.center = (watchImageView.superview?.center)!
    }
    func createSplitViews(){
        leftView.frame = CGRect(x:0, y:0, width:mainBackgroundXDimension/2, height:mainBackgroundYDimension)
        rightView.frame = CGRect(x:0, y:0, width:mainBackgroundXDimension/2, height:mainBackgroundYDimension)
        leftView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        leftView.widthAnchor.constraint(equalToConstant: self.bounds.width/2).isActive = true
        rightView.widthAnchor.constraint(equalToConstant: self.bounds.width/2).isActive = true
        rightView.layer.borderColor = UIColor.lightGray.cgColor
        rightView.layer.borderWidth = 1
        //createLeftTopButtomViews()
        createLeftViewTitleLabels()
    }
    
    func createCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 120)
        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:mainBackgroundXDimension/2, height:mainBackgroundYDimension/2), collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.heightAnchor.constraint(equalToConstant: self.bounds.height/2).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: self.bounds.width/2).isActive = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsSelection = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.item < 3{
            print ("the index is \(indexPath.item)")
            print ("the index is \(planetNamesOrder[indexPath.item])")
            let currentPlanet = planetCellViews[indexPath.item]
            cell.addSubview(currentPlanet)
            cell.addSubview(cellLabels[indexPath.item])
            
            
        }else if indexPath.item == 3 {
            cell.addSubview(atomCollectionView!)
            cell.addSubview(cellLabels[3])
        }else if indexPath.item == 4 {
            cell.addSubview(musicCollectionView!)
            cell.addSubview(cellLabels[4])
        }else{
            cell.backgroundColor = UIColor.orange
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < 3 {
            
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.sceneView?.alpha = 0.0
            }, completion: {[weak self] finished in
                self?.changePlanetScene(index: indexPath.item)
            })

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.atomFace?.alpha = 0.0
            }, completion:nil)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.musicFace?.stopSound()
                self.musicFace?.alpha = 0.0
            }, completion:nil)
            
          
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                self.sceneView?.alpha = 1.0
                self.sceneView?.addSubview(self.currentDate!)
                self.sceneView?.addSubview(self.digitalTime!)
            }, completion: nil)
        }else if indexPath.item == 3{
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.sceneView?.alpha = 0.0
            }, completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.musicFace?.stopSound()
                self.musicFace?.alpha = 0.0
            }, completion:nil)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.atomFace?.alpha = 1.0
                self.atomFace?.addSubview(self.currentDate!)
                self.atomFace?.addSubview(self.digitalTime!)
            }, completion: nil)
            
        } else if indexPath.item == 4{
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.sceneView?.alpha = 0.0
            }, completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.atomFace?.alpha = 0.0
            }, completion:nil)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.musicFace?.alpha = 1.0
                self.musicFace?.addSubview(self.currentDate!)
                self.musicFace?.addSubview(self.digitalTime!)
            }, completion: nil)
        }
        
    }
    func changePlanetScene(index : Int){
        planetNode.geometry?.firstMaterial?.diffuse.contents = planets[planetNamesOrder[index]]
    }
    func createLeftTopButtomViews(){
        leftTopView.frame = CGRect(x:0, y:0, width:mainBackgroundXDimension/2, height:mainBackgroundYDimension/2)
        leftButtomView.frame = CGRect(x:0, y:0, width:mainBackgroundXDimension/2, height:mainBackgroundYDimension/2)
        leftTopView.heightAnchor.constraint(equalToConstant: self.bounds.height/2).isActive = true
        leftButtomView.heightAnchor.constraint(equalToConstant: self.bounds.height/2).isActive = true
        leftTopView.widthAnchor.constraint(equalToConstant: self.bounds.width/2).isActive = true
        leftButtomView.widthAnchor.constraint(equalToConstant: self.bounds.width/2).isActive = true
        leftTopView.layer.borderColor = UIColor.lightGray.cgColor
        leftTopView.layer.borderWidth = 2
        leftButtomView.layer.borderColor = UIColor.lightGray.cgColor
        leftButtomView.layer.borderWidth = 2
        
        leftTopView.backgroundColor = UIColor.yellow
        //leftButtomView.backgroundColor = UIColor.red
        
        
    }
    
    
    func createLeftViewTitleLabels(){
        let labelHeight = self.bounds.height/16
        let labelWidth = self.bounds.width/2
        watchFacesLabel.text = "WATCH FACES"
        watchFacesLabel.textAlignment = .center
        watchFacesLabel.adjustsFontSizeToFitWidth = true
        watchFacesLabel.frame = CGRect(x: 0, y: 0, width: labelWidth , height: labelHeight)
        
        watchFacesLabel.backgroundColor = UIColor(colorLiteralRed: 706, green: 710, blue: 710, alpha: 0.7)
        watchFacesLabel.font = UIFont(name: "HelveticaNeue", size: 24)
        watchFacesLabel.layer.borderWidth = 1
        watchFacesLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        watchCaseAndBandLabel.text = "WATCH CASES AND BANDS"
        watchCaseAndBandLabel.textAlignment = .center
        watchCaseAndBandLabel.adjustsFontSizeToFitWidth = true
        watchCaseAndBandLabel.frame = CGRect(x: 0, y: 0, width: labelWidth , height: labelHeight)
        watchCaseAndBandLabel.backgroundColor = UIColor(colorLiteralRed: 706, green: 710, blue: 710, alpha: 0.7)
        watchCaseAndBandLabel.font = UIFont(name: "HelveticaNeue", size: 24)
        watchCaseAndBandLabel.layer.borderWidth = 1
        watchCaseAndBandLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        watchFacesLabel.heightAnchor.constraint(equalToConstant: labelHeight ).isActive = true
        watchCaseAndBandLabel.heightAnchor.constraint(equalToConstant: labelHeight ).isActive = true
        watchFacesLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        watchCaseAndBandLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
    }
    func createLeftTopButtomStackViews(){
        
        
        leftTopStackView.frame = leftTopView.frame
        leftTopStackView.axis = .vertical
        leftTopStackView.addArrangedSubview(watchFacesLabel)
        leftTopStackView.distribution = .fillProportionally
        leftTopStackView.alignment = .center
        leftTopStackView.translatesAutoresizingMaskIntoConstraints = false
        leftTopView.addSubview(leftTopStackView)
        leftTopStackView.centerXAnchor.constraint(equalTo: leftTopView.centerXAnchor).isActive = true
        leftTopStackView.topAnchor.constraint(equalTo: leftTopView.topAnchor).isActive = true
        
        
        
        
        leftBottomStackView.frame = CGRect(x: 0, y: leftTopStackView.frame.maxY, width: leftButtomView.frame.width, height: leftButtomView.frame.height)
        leftBottomStackView.axis = .vertical
        leftBottomStackView.addArrangedSubview(watchCaseAndBandLabel)
        leftBottomStackView.distribution = .fillProportionally
        leftBottomStackView.alignment = .center
        leftBottomStackView.translatesAutoresizingMaskIntoConstraints = false
        leftButtomView.addSubview(leftBottomStackView)
        leftBottomStackView.centerXAnchor.constraint(equalTo: leftButtomView.centerXAnchor).isActive = true
        leftBottomStackView.topAnchor.constraint(equalTo: leftButtomView.topAnchor).isActive = true
        
    }
    func initializeDigitalTime(){
        digitalTime = UILabel(frame: CGRect(x: CGFloat(watchFaceWidth/2), y: (0.1)*CGFloat(watchFaceHeight), width: CGFloat(watchFaceWidth)/2,height: CGFloat(watchFaceHeight)/4))
        digitalTime?.font = UIFont(name: "HelveticaNeue", size: 30)
        digitalTime?.textColor = UIColor.white
        digitalTime?.text = "00:00"
    }
    func initializeCurrentDate(){
        currentDate = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(watchFaceWidth)/2, height: CGFloat(watchFaceHeight)/5))
        currentDate?.text = "-- --"
        currentDate?.textColor = UIColor.white
        currentDate?.font = UIFont(name: "HelveticaNeue", size: 18)
    }
    func updateTimeLabel() {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let hour = Calendar.current.component(.hour, from: currentTime)
        let hourString : String = hour <= 9 ? "0\(hour)" : "\(hour)"
        let minute = Calendar.current.component(.minute, from: currentTime)
        let minuteString : String = minute <= 9 ? "0\(minute)" : "\(minute)"
        weekDay = Calendar.current.component(.weekday, from: currentTime)
        dayDate = Calendar.current.component(.day, from :currentTime)
        if viewDivider{
            DispatchQueue.main.async {[weak self] in
                self?.digitalTime?.text = "\(hourString):\(minuteString)"
            }
            viewDivider = false
        }
        else{
            DispatchQueue.main.async {[weak self] in
                self?.digitalTime?.text = "\(hourString) \(minuteString)"
            }
            viewDivider = true
        }
        DispatchQueue.main.async {[weak self] in
            self?.currentDate?.text = "\((self?.weekDays[(self?.weekDay)!-1])!) \((self?.dayDate)!)"
        }
    }
    func createPlanetsDictionary(){
        planets["earth"] = UIImage(named: "earth.jpg")
        planets["mars"] = UIImage(named: "mars.jpg")
        planets["neptune"] = UIImage(named: "neptune.jpg")
        
    }
    func initializePlanetScene(){
        sceneView?.scene = scene
        sceneView?.backgroundColor = UIColor.black
        sceneView?.autoenablesDefaultLighting = true
        watchImageView.addSubview(sceneView!)
        sceneView?.center = CGPoint(
            x: watchImageCenterX,
            y:watchImageCenterY)
        planetNode.geometry = SCNSphere(radius: 1)
        planetNode.geometry?.firstMaterial?.diffuse.contents = planets["earth"]
        planetNode.geometry?.firstMaterial?.isDoubleSided = true
        
        scene.rootNode.addChildNode(planetNode)
        
        
        sceneView?.addSubview(currentDate!)
        sceneView?.addSubview(digitalTime!)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        sceneView?.addGestureRecognizer(panRecognizer)
        
    }
    func initializeAtomScene(){
        
        atomFace = AtomFace(width: CGFloat(watchFaceWidth), height: CGFloat(watchFaceHeight))
        watchImageView.addSubview(atomFace!)
        atomFace?.center = CGPoint(
            x: watchImageCenterX,
            y:watchImageCenterY)
        atomFace?.alpha = 0.0
        
    }
    func initializeMusicFace(){
        musicFace = MusicFace(width: CGFloat(watchFaceWidth), height: CGFloat(watchFaceHeight))
        watchImageView.addSubview(musicFace!)
        musicFace?.center = CGPoint(
            x: watchImageCenterX,
            y:watchImageCenterY)
        musicFace?.alpha = 0.0
        //musicFace?.addSubview(currentDate!)
        //musicFace?.addSubview(digitalTime!)
    }
    func panGesture(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: panGesture.view!)
        
        let x = Float(translation.x)
        let y = Float(-translation.y)
        
        let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(M_PI)/180.0
        
        
        rotationVector.x = -y
        rotationVector.y = x
        rotationVector.z = 0
        rotationVector.w = anglePan

        DispatchQueue.main.async {[weak self] in
            SCNTransaction.begin()
            self?.planetNode.rotation = (self?.rotationVector)!
            SCNTransaction.commit()
            SCNTransaction.flush()
            
        }
        //getting the end angle of the swipe put into the instance variable
        if(panGesture.state == .ended) {
            DispatchQueue.main.async {[weak self] in
                
                SCNTransaction.begin()
                let currentPivot = (self?.planetNode.pivot)!
                let changePivot = SCNMatrix4Invert((self?.planetNode.transform)!)
                self?.planetNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
                self?.planetNode.transform = SCNMatrix4Identity
                SCNTransaction.commit()
                SCNTransaction.flush()
            }
        }
        
        
    }
    
    func setBackgroundColor(){
        let bc = CAGradientLayer()
        let topColor = UIColor(colorLiteralRed: 0.325, green: 0.824, blue: 0.675, alpha: 1.00).cgColor
        let bottomColor = UIColor(colorLiteralRed: 0.129, green: 0.412, blue: 0.647, alpha: 1.00).cgColor
        bc.colors = [topColor, bottomColor]
        bc.locations = [0.0, 1.0]
        bc.frame = self.bounds
        bc.zPosition = -1
        self.layer.insertSublayer(bc, at: 0)
    }
    func createPlanetsCollectionViews(){
        for planet in planets{
            planetNamesOrder.append(planet.key)
            let tempSceneView = SCNView(frame: CGRect(x:0,y:0,width:100,height:100))
            let tempScene  = SCNScene()
            let tempPlanetNode = SCNNode()
            tempSceneView.scene = tempScene
            tempSceneView.backgroundColor = UIColor.black
            tempSceneView.autoenablesDefaultLighting = true
            tempPlanetNode.geometry = SCNSphere(radius: 2)
            tempPlanetNode.geometry?.firstMaterial?.diffuse.contents = planet.value
            tempPlanetNode.geometry?.firstMaterial?.isDoubleSided = true
            tempScene.rootNode.addChildNode(tempPlanetNode)
            let tempAction = SCNAction.rotate(by: 360*CGFloat((M_PI)/180.0), around:SCNVector3Make(0, 2, 0), duration: 8)
            let tempRepeatAction = SCNAction.repeatForever(tempAction)
            tempPlanetNode.runAction(tempRepeatAction)
            planetCellViews.append(tempSceneView)
            
        }
    }
    func createAtomCollectionView(){
        atomCollectionView = AtomFace(width: CGFloat(100), height: CGFloat(100))
    }
    
    func createMusicCollectionView(){
        musicCollectionView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        musicCollectionView?.backgroundColor = UIColor.black
        musicCollectionView?.setFAIconWithName(icon: .FAMusic, textColor: .white)
    }
    
    func createCollectionViewLabels(){
        let label1 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        let label2 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        let label3 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        let label4 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        let label5 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        let label6 = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 25))
        label1.text = "MARS"
        label2.text = "NEPTUNE"
        label3.text = "EARTH"
        label4.text = "ATOM"
        label5.text = "MUSIC"
        label6.text = "MAPS"
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        label4.textAlignment = .center
        label5.textAlignment = .center
        label6.textAlignment = .center
        
        cellLabels.append(label1)
        cellLabels.append(label2)
        cellLabels.append(label3)
        cellLabels.append(label4)
        cellLabels.append(label5)
        cellLabels.append(label6)
        
        for cell in cellLabels{
            cell.backgroundColor = UIColor(colorLiteralRed: 706, green: 710, blue: 710, alpha: 0.7)
        }
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let mainBackgroundYDimension = 700
let mainBackgroundXDimension = 700
let mainBackground = Watch(width: CGFloat(mainBackgroundXDimension), height: CGFloat(mainBackgroundYDimension))
//mainBackground.watchImageView

PlaygroundPage.current.liveView = mainBackground
