//
//  GuideMakerViewController.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 13/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import hpple
import SwiftSpinner
import SwiftyJSON
import Kingfisher
import SCLAlertView


// TODO: Refactor this entire view alot can be solved with a constants file

private let reuseIdentifier = "SpellCell"

class GuideMakerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var whatsinsidetextfield = ""
    @IBOutlet weak var backgroundHeroImageLarge: UIImageView!
    
    @IBAction func FinishButtonAction(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        if (((User.current()?.username!)! != "Guest")){

        let alertView = SCLAlertView(appearance: appearance)
        let text = alertView.addTextField("DotaMate Guide Name")

        alertView.addButton("Done"){
        self.whatsinsidetextfield = text.text!
        self.firstButton()
        
        }
        alertView.showSuccess("Thanks Mate", subTitle: "Give a name to your cool Guide\nex: Arteezy's mid Windrunner🏹", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
            
        }
        else{
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: true
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showSuccess("Please Login", subTitle: "Only authorized users can post guides", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
            
        }
        
    }
   
    func firstButton(){
        
        
        SwiftSpinner.show("upgrading courier!")
        
        let object = PFObject(className: "Guide")
        object["username"] = PFUser.current()!.username
        object["uuid"] = "\(PFUser.current()!.username!) \(UUID().uuidString)"
        object["heroGuideName"] = hero!.heroLocalizedName
        object["heroGuidePosition"] = self.whatsinsidetextfield //"\(heroDetail!.attackType) \(heroDetail!.primaryAttribute) Hero"
        
        object["guideDescription"] = overviewTextField.text
        object["title"] = hero!.heroDotaName
        object["guideLikes"] = 0
        object["guideNumOfViews"]=0
        object["guideCreatorID"] = PFUser.current()?.objectId!
        object["author"] = PFUser.current()
        
        let num = abilityOrder.count
        if num>=1{
            for index in 0...num-1  {
                abilityOrderName+="\(abilityOrder[index].dotaName)+"
                
            }}
        object["skillBuild"] = abilityOrderName
        
        let numm = itemsInCV.count
        if numm>1{
        for index in 0...numm-1 {
            guard let item = itemsInCV[index].itemImageURL else{return}
            itemsInCVName+="\(item)+"
            
            }}
        object["items"] = itemsInCVName
        
        let imageData = UIImageJPEGRepresentation(self.backgroundHeroImageLarge.image!, 0.5)
        let imageFile = PFFile(name: "background.jpg", data: imageData!)
        object["heroIconPic"] = imageFile
        object.saveInBackground { (success, error) in
            if error == nil {
                // NSNotificationCenter.defaultCenter().postNotificationName("Saved", object: nil)
                self.abilityOrder.removeAll(keepingCapacity: false)
                self.itemsInCV.removeAll(keepingCapacity: false)
                self.overviewTextField.text="⬆️Choose the SkillBuild⬆️\n\nEnter some useful tips and tricks about your skillbuild that will be useful during the game👊\n\n💥Tap one of the Branches💥\n💥to change the Itembuild💥"
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                    showCloseButton: true
                )
                let alertView = SCLAlertView(appearance: appearance)
                
                
                
                alertView.showSuccess("Thanks Mate", subTitle: "Your Guide has been saved!", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
            }
            
            
        }
        SwiftSpinner.hide()
        self.tabBarController?.selectedIndex = 0
    }
  

    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var spellFirstButton: UIButton!
    @IBOutlet weak var spellSecondButton: UIButton!
    @IBOutlet weak var spellThridButton: UIButton!
    @IBOutlet weak var spellFourthButton: UIButton!
    
    @IBOutlet weak var spellTableView: UITableView!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var overviewTextField: UITextView!
    
    var hero:Hero?
    var heroDetail:HeroDetail?
    var createdGuide:Guide?
    var indexShouldPress:Int?
    var indexPressed:Int?
    var audioPlayer = AVAudioPlayer()
    var heroDetailAbilities = [Ability]()
    var abilityOrder = [Ability]()
    var abilityOrderName = ""
    var itemsInCVName=""
    
    var itemArray = [Item]()
    var itemsInCV = [Item]()
    var spellLevel = [0,0,0,0]
    var first = UIImageView()
    var second = UIImageView()
    var third = UIImageView()
    var fourth = UIImageView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if self.hero != nil {
                
                self.parseHeroWithName(self.hero!.heroLocalizedName.replacingOccurrences(of: " ", with: "_"))

            }
            DispatchQueue.main.async(execute: {
                SwiftSpinner.hide()
                 self.overviewTextField.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
                self.itemCollectionView.reloadData()
                self.spellFirstButton.layoutSubviews()
                self.spellSecondButton.layoutSubviews()
                self.spellThridButton.layoutSubviews()

                self.spellFourthButton.layoutSubviews()

               

            })

        }}
    
    

    
    
       override func viewDidLoad() {
        super.viewDidLoad()
       

        
        self.view.layoutSubviews()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        SwiftSpinner.show("Killing Roshan!")
        dowloadItems()

        overviewTextField.delegate = self
        
        if (overviewTextField.text == "") {
            textViewDidEndEditing(overviewTextField)
        }
        
        if hero != nil {
            
            self.navigationItem.title = hero?.heroLocalizedName
            //downloadImageFromURL(hero!.portraitImageURL!, forImageView: backgroundHeroImageLarge)
            view.backgroundColor = UIColor.darkGray
            let imageName = "\(hero!.heroDotaName)"
            var image = UIImage(named: imageName)
            let jpegImage = UIImageJPEGRepresentation(image!, 1)
            image =  (UIImage(data: jpegImage!))
             backgroundHeroImageLarge.image = image
           
           
            
            let name = hero!.heroLocalizedName
            
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            }
            catch{
                print("Error playing audio")
            }
           
            
            

            itemCollectionView.reloadData()

        }
        let tap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GuideMakerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    
    
}

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = itemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let bounds = itemCollectionView.bounds
        let ratio: CGFloat = 0.461
        let width: CGFloat = bounds.width / 3 - flowLayout.minimumInteritemSpacing * 2
        let height = width * ratio + 20
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        
       
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the    first responder status.
        view.endEditing(true)
    }
    
    
    
    
    //placeholder for overviewTextField
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "⬆️Choose the SkillBuild⬆️\n\nEnter some useful tips and tricks about your skillbuild that will be useful during the game👊\n\n💥Tap one of the Branches💥\n💥to change the Itembuild💥"
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == "⬆️Choose the SkillBuild⬆️\n\nEnter some useful tips and tricks about your skillbuild that will be useful during the game👊\n\n💥Tap one of the Branches💥\n💥to change the Itembuild💥"){
            textView.text = ""
            textView.textColor = UIColor.white
        }
        textView.becomeFirstResponder()
    }
    
    func parseHeroWithName(_ name:String){
        var heroDetailPrimaryAttribute:PrimaryAttribute = .strength
        var heroDetailAttackType:AttackType = .melee
        var heroDetailRoles:[String] = [String]()
        var heroDetailBaseStrength:Double = 0
        var heroDetailStrengthIncrease:Double = 0
        var heroDetailBaseAgility:Double = 0
        var heroDetailAgilityIncrease:Double = 0
        var heroDetailBaseIntelligence:Double = 0
        var heroDetailIntelligenceIncrease:Double = 0
        var heroDetailMovementSpeed:Double = 0
        var heroDetailBaseArmor:Double = 0
        var heroDetailBaseAttackLow:Double = 0
        var heroDetailBaseAttackHigh:Double = 0
        var heroDetailDayVision:Double = 0
        var heroDetailNightVision:Double = 0
        var heroDetailAttackRange:Double = 0
        
        guard let url = URL(string: "http://www.dota2.com/hero/\(name.replacingOccurrences(of: "'", with: ""))/") else{
            print(name)
            print("Hero URL error")
            return
        }
        print(url)
        guard let urlData = try? Data(contentsOf: url) else{
            print("Hero Data Error")
            return
        }
        guard let heroDataParser = TFHpple(htmlData: urlData) else{
            print("Parser Initializing Error")
            return
        }
        //let start = NSDate();
        //let heroBaseStrengthXPath = "//table[@class='infobox']//th[a/@title='Strength']"
        let heroBaseStrengthXPath = "//div[@id='overview_StrVal']"
        guard let heroBaseStrength = heroDataParser.search(withXPathQuery: heroBaseStrengthXPath) as? [TFHppleElement] else{
            print("Error finding Base Stength")
            return
        }
        if var heroStrengthData = heroBaseStrength.first?.content{
            heroStrengthData = heroStrengthData.trimmingCharacters(in: CharacterSet(charactersIn: " \n"))
            let heroStrengthDataComponents = heroStrengthData.components(separatedBy: " + ")
            if let baseStength = Double(heroStrengthDataComponents[0]){
                heroDetailBaseStrength = baseStength
                //print(heroDetailBaseStrength)
            }
            if let strengthIncrease = Double(heroStrengthDataComponents[1]){
                heroDetailStrengthIncrease = strengthIncrease
                //print(heroDetailStrengthIncrease)
            }
        }
        
        let heroBaseIntelligenceXPath = "//div[@id='overview_IntVal']"
        guard let heroBaseIntelligence = heroDataParser.search(withXPathQuery: heroBaseIntelligenceXPath) as? [TFHppleElement] else{
            print("Error finding Base Intelligence")
            return
        }
        if var heroIntelligenceData = heroBaseIntelligence.first?.content{
            heroIntelligenceData = heroIntelligenceData.trimmingCharacters(in: CharacterSet(charactersIn: " \n"))
            let heroIntelligenceDataComponents = heroIntelligenceData.components(separatedBy: " + ")
            if let baseIntelligence = Double(heroIntelligenceDataComponents[0]){
                heroDetailBaseIntelligence = baseIntelligence
                //print(heroDetailBaseIntelligence)
            }
            if let intelligenceIncrease = Double(heroIntelligenceDataComponents[1]){
                heroDetailIntelligenceIncrease = intelligenceIncrease
                //print(heroDetailIntelligenceIncrease)
            }
        }
        
        let heroBaseAgilityXPath = "//div[@id='overview_AgiVal']"
        guard let heroBaseAgility = heroDataParser.search(withXPathQuery: heroBaseAgilityXPath) as? [TFHppleElement] else{
            print("Error finding Base Agility")
            return
        }
        if var heroAgilityData = heroBaseAgility.first?.content{
            heroAgilityData = heroAgilityData.trimmingCharacters(in: CharacterSet(charactersIn: " \n"))
            let heroAgilityDataComponents = heroAgilityData.components(separatedBy: " + ")
            if let baseAgility = Double(heroAgilityDataComponents[0]){
                heroDetailBaseAgility = baseAgility
                //print(heroDetailBaseAgility)
            }
            if let agilityIncrease = Double(heroAgilityDataComponents[1]){
                heroDetailAgilityIncrease = agilityIncrease
                //print(heroDetailAgilityIncrease)
            }
        }
        
        
        let heroSpeedXPath = "//div[@id='overview_SpeedVal']"
        guard let heroSpeed = heroDataParser.search(withXPathQuery: heroSpeedXPath) as? [TFHppleElement] else{
            print("Error finding Speed")
            return
        }
        if let heroSpeedData = heroSpeed.first?.content{
            if let speed = Double(heroSpeedData){
                heroDetailMovementSpeed = speed
                //print(heroDetailMovementSpeed)
            }
        }
        
        let heroPrimaryXPath = "//img[@id='overviewIcon_Primary']"
        guard let heroPrimary = heroDataParser.search(withXPathQuery: heroPrimaryXPath) as? [TFHppleElement] else{
            print("Error finding Primary Attribute")
            return
        }
        if let heroPrimaryData = heroPrimary.first?.object(forKey: "style") {
            if heroPrimaryData == "top:43px"{
                heroDetailPrimaryAttribute = .agility
            }
            else if heroPrimaryData == "top:83px"{
                heroDetailPrimaryAttribute = .strength
            }
            else{
                heroDetailPrimaryAttribute = .intelligence
            }
            //print(heroDetailPrimaryAttribute)
        }
        
        let heroArmorXPath = "//div[@id='overview_DefenseVal']"
        guard let heroArmor = heroDataParser.search(withXPathQuery: heroArmorXPath) as? [TFHppleElement] else{
            print("Error finding Armor")
            return
        }
        if let heroArmorData = heroArmor.first?.content{
            if let armor = Double(heroArmorData){
                heroDetailBaseArmor = armor
                //print(heroDetailBaseArmor)
            }
        }
        
        let heroRolesXPath = "//p[@id='heroBioRoles']"
        guard let heroRoles = heroDataParser.search(withXPathQuery: heroRolesXPath) as? [TFHppleElement] else{
            print("Error finding Attack Type")
            return
        }
        if let heroRolesData = heroRoles.first?.content{
           // self.bioLabel.text = heroRolesData
            heroDetailRoles = heroRolesData.components(separatedBy: " - ")
            heroDetailRoles.remove(at: 0)
            //print(heroDetailRoles)
        }
        
        let heroAttackTypeXPath = "//span[@class='bioTextAttack']"
        guard let heroAttackType = heroDataParser.search(withXPathQuery: heroAttackTypeXPath) as? [TFHppleElement] else{
            print("Error finding Attack Type")
            return
        }
        if let heroAttackTypeData = heroAttackType.first?.content{
            if heroAttackTypeData == "Melee"{
                heroDetailAttackType = .melee
            }
            else{
                heroDetailAttackType = .ranged
            }
            //print(heroDetailAttackType)
        }
        
        let heroAttackXPath = "//div[@id='overview_AttackVal']"
        guard let heroBaseAttack = heroDataParser.search(withXPathQuery: heroAttackXPath) as? [TFHppleElement] else{
            print("Error finding Base Attack Values")
            return
        }
        if let heroBaseAttackData = heroBaseAttack.first?.content{
            let heroBaseAttackComponents = heroBaseAttackData.components(separatedBy: " - ")
            if let baseAttackLow = Double(heroBaseAttackComponents[0]){
                heroDetailBaseAttackLow = baseAttackLow
                //print(heroDetailBaseAttackLow)
            }
            if let baseAttackHigh = Double(heroBaseAttackComponents[1]){
                heroDetailBaseAttackHigh = baseAttackHigh
                //print(heroDetailBaseAttackHigh)
            }
        }
        
        let heroAdditionalStatsXPath = "//div[@class='statRowCol2W']"
        guard let heroAdditionalStats = heroDataParser.search(withXPathQuery: heroAdditionalStatsXPath) as? [TFHppleElement] else{
            print("Error finding Hero Additional Stats")
            return
        }
        if heroAdditionalStats.count > 0{
            if let heroVisionData = heroAdditionalStats.first?.content{
                let heroVisionComponents = heroVisionData.components(separatedBy: " / ")
                if let dayVisionRange = Double(heroVisionComponents[0]){
                    heroDetailDayVision = dayVisionRange
                    //print(heroDetailDayVision)
                }
                if let nightVisionRange = Double(heroVisionComponents[1]){
                    heroDetailNightVision = nightVisionRange
                    //print(heroDetailNightVision)
                }
            }
            
            if let heroRangeData = heroAdditionalStats[1].content{
                if let attackRange = Double(heroRangeData){
                    heroDetailAttackRange = attackRange
                    //print(heroDetailAttackRange)
                }
            }
        }
        
        let heroAbilitiesXPath = "//div[@class='overviewAbilityRow']"
        guard let heroAbilities = heroDataParser.search(withXPathQuery: heroAbilitiesXPath) as? [TFHppleElement] else{
            print("Error finding Abilities")
            return
        }
        for element in heroAbilities{
            let abilityNodes = element.children as! [TFHppleElement]
            let abilityImageDiv = abilityNodes[1]
            if let abilityDescriptionDiv = abilityNodes[3].children as? [TFHppleElement]{
                var abilityDotaName:String=""
                var abilitySmallImageURL:String = ""
                var abilityLargeImageURL:String = ""
                
            
                if let abilityImageDivNodes = abilityImageDiv.children as? [TFHppleElement]{
                    for node in abilityImageDivNodes{
                        if node.tagName == "img"{
                            abilityDotaName = node.object(forKey: "abilityname")
                            abilitySmallImageURL = "http://media.steampowered.com/apps/dota2/images/abilities/\(abilityDotaName)_hp1.png"
                            abilityLargeImageURL = "http://media.steampowered.com/apps/dota2/images/abilities/\(abilityDotaName)_hp2.png"
                            //print(abilityDotaName)
                        }
                    }
                }
                
                    if abilityDotaName != ""{
                    heroDetailAbilities.append(Ability(name: "", description: "", dotaName: abilityDotaName, urlSmall: abilitySmallImageURL, urlLarge: abilityLargeImageURL))
                        
                }
            }
        }
        
        
        
        heroDetail = HeroDetail(hero: self.hero!,primaryAttribute: heroDetailPrimaryAttribute, roles: heroDetailRoles, attackType: heroDetailAttackType, baseStrength: heroDetailBaseStrength, baseAgility: heroDetailBaseAgility, baseIntelligence: heroDetailBaseIntelligence, strengthIncrease: heroDetailStrengthIncrease, agilityIncrease: heroDetailAgilityIncrease, intelligenceIncrease: heroDetailIntelligenceIncrease, movementSpeed: heroDetailMovementSpeed, turnRate: 0, sightRangeDay: heroDetailDayVision, sightRangeNight: heroDetailNightVision, attackRange: heroDetailAttackRange, baseArmor: heroDetailBaseArmor, baseAttackLow: heroDetailBaseAttackLow, baseAttackHigh: heroDetailBaseAttackHigh, abilities: heroDetailAbilities)
      
      
        let imageView = UIImageView()
        
        imageView.kf.setImage(with: URL.init(string: self.heroDetail!.abilities[0].urlLarge))
        
        self.spellFirstButton.setBackgroundImage(imageView.image!, for: UIControlState())
      
        var secondSpell = 1
        switch hero?.heroLocalizedName {
            
        case "Io" as String!:
            secondSpell = 2
        case "Rubick" as String!:
            secondSpell = 2
            
        default:
            secondSpell = 1
        }
        
        imageView.kf.setImage(with: URL.init(string: self.heroDetail!.abilities[secondSpell].urlLarge))

        var thirdspell = 2
        
        switch hero?.heroLocalizedName {
        case "Chen" as String!:
            thirdspell = 3
        case "Io" as String!:
            thirdspell = 3
        case "Rubick" as String!:
            thirdspell = 3
        case "Troll Warlord" as String!:
            thirdspell = 3
               default:
            thirdspell = 2
        }
        self.spellSecondButton.setBackgroundImage(imageView.image!, for: UIControlState())

        imageView.kf.setImage(with: URL.init(string: self.heroDetail!.abilities[thirdspell].urlLarge))
        
        var ulti = 3
        switch hero?.heroLocalizedName {
            case "Chen" as String!:
            ulti = 4
        case "Tusk" as String!:
            ulti = 5
        case "Io" as String!:
            ulti = 4
        case "Keeper of the Light" as String!:
            ulti = 5
        case "Morphling" as String!:
            ulti = 4
        case "Nyx Assassin" as String!:
            ulti = 5
        case "Puck" as String!:
            ulti = 4
        case "Rubick" as String!:
            ulti = 4
        case "Shadow Demon" as String!:
            ulti = 4
        case "Techies" as String!:
            ulti = 5
        case "Troll Warlord" as String!:
            ulti = 4
        case "Treant Protecctor" as String!:
            ulti = 4
        case "Elder Titan" as String!:
            ulti = 4
        case "Earth Spirit" as String!:
            ulti = 4
        case "Lifestealer" as String!:
            ulti = 4
        case "Lone Druid" as String!:
            ulti = 4
        case "Ogre Magi" as String!:
            ulti = 4
            default:
            ulti = 3
        }
        
        self.spellThridButton.setBackgroundImage(imageView.image!, for: UIControlState())
        
        
        imageView.kf.setImage(with: URL.init(string: self.heroDetail!.abilities[ulti].urlLarge))
        
        self.spellFourthButton.setBackgroundImage(imageView.image!, for: UIControlState())
        
        
    }
    
    func downloadImageFromURL(_ url:String,forImageView imageView:UIImageView){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            guard let url = URL(string:url) else{
                return
            }
            guard let data = try? Data(contentsOf: url) else{
                return
            }
            DispatchQueue.main.async{
                imageView.image = UIImage(data: data)
            }
        }
    }


    
    
    
    
    
    //MARK: TableViewDelegates
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityOrder.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        abilityOrder.remove(at: (indexPath as NSIndexPath).row)
        
        spellTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SpellTVC
        
        cell.numberOfSpell.text = String((indexPath as NSIndexPath).row+1)
        
        let spellLargeImageURL = abilityOrder[(indexPath as NSIndexPath).row].urlLarge
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL.init(string: spellLargeImageURL))
            
            if let spellImage = imageView.image {
                DispatchQueue.main.async{
                    cell.spellImage.image = spellImage
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableViewScrollToBottom(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.spellTableView.numberOfSections
            let numberOfRows = self.spellTableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.spellTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
            
        })
    }
    
    
    //MARK: CVC init
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.itemsInCV.count    }
    
    
    //cell config
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellOverall", for: indexPath) as! ItemCVC
        
        let item = itemsInCV[(indexPath as NSIndexPath).row]
        if let itemImageURL = item.itemImageURL{
            
                cell.itemImage.kf.setImage(with:URL(string: itemImageURL)!)
        }
        
        
        
        return cell
        
        
    }
    

    //MARK: prepareFOrsegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseTheItem" {
            let destVC = segue.destination as! ItemChooseCollectionVC
            
        if let indexPath = self.itemCollectionView?.indexPath(for: sender as! UICollectionViewCell) {
            self.indexPressed=(indexPath as NSIndexPath).row
            }
            destVC.delegate = self
            destVC.itemFullList = self.itemArray
          
           
        }
        
        
    }
    
    
    //MARK: download items 
    
    func dowloadItems(){
        var currentItem : Item
        
        let jsonFilePath:NSString = Bundle.main.path(forResource: "items", ofType: "json")! as NSString
        let jsonData:Data = try! Data(contentsOf: URL(fileURLWithPath: jsonFilePath as String))
        
        let json = JSON(data: jsonData) // Note: data: parameter name
       
        let items = json["itemdata"]
        
        for (key, value) in items{
          print(key, value)
            
            currentItem = Item(name: value["dname"].stringValue, itemLocalizedName: value["dname"].stringValue, quality: value["qual"].stringValue, itemId: value["id"].intValue, itemImageURL: "http://media.steampowered.com/apps/dota2/images/items/\(value["img"].stringValue)", cost: value["cost"].intValue, description: value["disc"].stringValue, notes: value["notes"].stringValue, lore: value["lore"].stringValue)
            self.itemArray.append(currentItem)
            
            if (currentItem.itemId == 16){
                self.itemsInCV.append(currentItem)
                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)
                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)

                self.itemsInCV.append(currentItem)


                
            }
           
        }
        itemCollectionView.reloadData()
        
        
    }
  
    
    
    
    //MARK: knopki background
    
    @IBAction func spellFirstPressed(_ sender: UIButton) {
        if abilityOrder.count>15{
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: true
            )
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showSuccess("Its enough :)", subTitle: "Mate, we know that the rest is attributes :)", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        }
        else {
            abilityOrder.append((heroDetail?.abilities[0])!)
        }
        spellTableView.reloadData()
        tableViewScrollToBottom(true)

    }
    @IBAction func spellSecondPressed(_ sender: UIButton) {
        if abilityOrder.count>15{
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: true
            )
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showSuccess("Its enough :)", subTitle: "Its fine, we know that the rest is attributes", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        }
        else {
            var secondSpell = 1
            switch hero?.heroLocalizedName {
            
            case "Io" as String!:
                secondSpell = 2
            case "Rubick" as String!:
                secondSpell = 2
                
            default:
                secondSpell = 1
            }
        abilityOrder.append((heroDetail?.abilities[secondSpell])!)
        }
        spellTableView.reloadData()
        tableViewScrollToBottom(true)



    }
    @IBAction func spellThridPressed(_ sender: UIButton) {
        
        
        var thirdspell = 2
        switch hero?.heroLocalizedName {
        case "Chen" as String!:
            thirdspell = 3
        case "Io" as String!:
            thirdspell = 3
        case "Rubick" as String!:
            thirdspell = 3
        case "Troll Warlord" as String!:
            thirdspell = 3
        default:
            thirdspell = 2
        }
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        
       
        if abilityOrder.count>15{
            
            alertView.showSuccess("Its enough :)", subTitle: "Its fine, we know that the rest is attributes", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        }
        else {
           
            
            abilityOrder.append((heroDetail?.abilities[thirdspell])!)
        }
                spellTableView.reloadData()
        tableViewScrollToBottom(true)



    }
    
    @IBAction func spellFouthPressed(_ sender: UIButton) {
        
        var ulti = 3
        switch hero?.heroLocalizedName {
        case "Chen" as String!:
            ulti = 4
        case "Tusk" as String!:
            ulti = 5
        case "Io" as String!:
            ulti = 4
        case "Keeper of the Light" as String!:
            ulti = 5
        case "Morphling" as String!:
            ulti = 4
        case "Nyx Assassin" as String!:
            ulti = 5
        case "Puck" as String!:
            ulti = 4
        case "Rubick" as String!:
            ulti = 4
        case "Shadow Demon" as String!:
            ulti = 4
        case "Techies" as String!:
            ulti = 5
        case "Troll Warlord" as String!:
            ulti = 4
        case "Treant Protecctor" as String!:
            ulti = 4
        case "Elder Titan" as String!:
            ulti = 4
        case "Earth Spirit" as String!:
            ulti = 4
        case "Lifestealer" as String!:
            ulti = 4
        case "Lone Druid" as String!:
            ulti = 4
        case "Ogre Magi" as String!:
            ulti = 4
        default:
            ulti = 3
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        if abilityOrder.count>15{
            
            alertView.showSuccess("Its enough :)", subTitle: "Its fine, we know that the rest is attributes", colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        }
        else {
        abilityOrder.append((heroDetail?.abilities[ulti])!)
        
        }
        spellTableView.reloadData()
        tableViewScrollToBottom(true)

    }
    


}


extension GuideMakerViewController: ItemChooseCollectionVCDelegate {
    func didChoseItem(_ item: Item) {
        itemsInCV.remove(at: indexPressed!)
        itemsInCV.insert(item, at: indexPressed!)
        itemCollectionView.reloadData()
    }
}
