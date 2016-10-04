//
//  TimerViewController.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 01/08/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
//import ConcentricProgressRingView
import SwiftyTimer
//import LionheartExtensions
import SCLAlertView


class TimerViewController: UIViewController {
    
    

    @IBOutlet weak var roshanButton: UIButton!
    @IBOutlet weak var TimerView: UIView!
    @IBOutlet weak var roshanIconOutlet: UIButton!
    
    @IBOutlet weak var yello: UILabel!
    @IBOutlet weak var aegisGotawayLabel: UILabel!
    @IBOutlet weak var aegisFirstTimeLabel: UILabel!
    var elapsedTime : CFAbsoluteTime!
    var startTime : CFAbsoluteTime!
    var timeAtPress: Date!

    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?

//    var progressRingView: ConcentricProgressRingView!
    var shouldcount = false
    var showAd = true
    
    
    var counter = 0 {
        
        didSet {
            aegisTimer = 300-counter
            earlyRosh = 480-counter
            lateRosh = 660-counter
        }
    }
    
    var aegisTimer = 300 {
        didSet{

            if ((aegisTimer>0) && (aegisTimer != 300)){
                aegisGotawayLabel.text=secondsToHoursMinutesSeconds(aegisTimer)
                animateCircle(0,toThePoint: ((1-(CGFloat(aegisTimer)/300))) ,amountOfTime: 0.7 )
            
            } else if (aegisTimer != 300) {
                aegisGotawayLabel.text=secondsToHoursMinutesSeconds(1)
                animateCircle(0,toThePoint: 1 ,amountOfTime: 2 )
            
            }
        }
    }
    
    var earlyRosh = 480{
        didSet{
            
            if ((earlyRosh > 0) && (earlyRosh != 480)){
                
                aegisFirstTimeLabel.text=secondsToHoursMinutesSeconds(earlyRosh)
                animateCircle(1,toThePoint: ((1-(CGFloat(earlyRosh)/480))),amountOfTime:0.6 )
            
            } else if (earlyRosh != 480) {
                aegisFirstTimeLabel.text=secondsToHoursMinutesSeconds(1)
                animateCircle(1,toThePoint: 1 ,amountOfTime: 2 )
            
            }
        }
    }
    
    var lateRosh = 660 {
        didSet{
            if ((lateRosh>0) && (lateRosh != 660)){
                yello.text=secondsToHoursMinutesSeconds(lateRosh)
                animateCircle(2,toThePoint: ((1-(CGFloat(lateRosh)/660))) ,amountOfTime: 0.5 )
            
            } else if (lateRosh != 660) {
                
                yello.text=secondsToHoursMinutesSeconds(1)
                animateCircle(2,toThePoint: 1 ,amountOfTime: 2 )
            }
            
            if (lateRosh <= -15) && showAd {
                showAd=false
                
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                    showCloseButton: true
                )
                
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Rate it Now!", target:self, selector:#selector(TimerViewController.rateApp))
                alertView.showSuccess("Tell us what you think 👍🏻", subTitle: "If you found this app useful, please rate it, It means a lot to DotaMate!", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            
        })
        
        Timer.every(1.seconds) {
            guard let time = self.startTime else {return}
            
            self.elapsedTime = CFAbsoluteTimeGetCurrent() - time
            
            self.counter = Int(self.elapsedTime)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
       
//        if progressRingView?.superview != nil {
//            return
//        }
        
        let margin: CGFloat = 3
        var radius: CGFloat = (TimerView.frame.maxX-TimerView.frame.minX)/2-9
//        
//        let rings = [
////            ProgressRing(color: UIColor(.RGB(232, 11, 45)), backgroundColor: UIColor(.RGB(34, 3, 11))),
////            ProgressRing(color: UIColor(.RGB(137, 242, 0)), backgroundColor: UIColor(.RGB(22, 33, 0))),
////            ProgressRing(color: UIColor(.RGB(244, 242, 0)), backgroundColor: UIColor(.RGB(37, 33, 0)))
//        ]
        
        let frame = TimerView.frame
        radius = (frame.maxX-frame.minX)/2-8
        
        let newcenter = CGPoint(x: TimerView.bounds.width / 2, y: TimerView.bounds.height / 2)
//        progressRingView = try! ConcentricProgressRingView(center: newcenter, radius: radius, margin: margin, rings: rings, defaultColor: UIColor.clearColor(), defaultWidth: (frame.maxX-frame.minX)/21-3)
        
//        for ring in progressRingView {
//            ring.progress = 0.5
//        }
        
        TimerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        TimerView.addSubview(progressRingView)
//        TimerView.sendSubview(toBack: progressRingView)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "")
        
        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker?.send(builder?.build() as [AnyHashable: Any])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func animateCircle(_ indexCircle: Int, toThePoint: CGFloat,amountOfTime: CGFloat){
//        self.progressRingView[indexCircle].setProgress(toThePoint, duration: amountOfTime)
        self.TimerView.layoutSubviews()
    }
    
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (String) {
        var retTxt = ""
        retTxt=("\((seconds % 3600) / 60):\((seconds % 3600) % 60)")
    
        if (((seconds % 3600) % 60)==0) {
            retTxt.append("0")
        
        } else if (((seconds % 3600) % 60) < 10) {
            retTxt=("\((seconds % 3600) / 60):0\((seconds % 3600) % 60)")
    
        }
        
        if (seconds<=1) {
            retTxt="✔︎"
        }
        
     return retTxt
    }

    @IBAction func TimerPressed(_ sender: UIButton) {
        
//        for ring in progressRingView {
//            ring.progress = 0.5
//        }
//        
        self.startTime = CFAbsoluteTimeGetCurrent()
        self.counter = 0
        self.shouldcount = true
    }
    
    func rateApp(){
        UIApplication.shared.openURL(URL(string : "https://itunes.apple.com/us/app/dotamate-dota-2-guides-builds/id1137556608?ls=1&mt=8")!)
    }
    
    func getTime() -> (hour:Int, min:Int, sec:Int) {
        let currentDateTime = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour,.minute,.second], from: currentDateTime)
        let hour = components.hour
        let min = components.minute
        let sec = components.second
        return (hour!,min!,sec!)
    }
}
