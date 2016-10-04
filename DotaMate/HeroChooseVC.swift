//
//  HeroesViewController.swift
//  DotaLobby

//
//  Created by Yerbol Kopzhassar on 12/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import Kingfisher
import Neon

class HeroChooseVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var refresher : UIRefreshControl!
    var heroes = [Hero]() {
        didSet {
            DispatchQueue.main.async {
                self.heroCollectionView.reloadData()
            }
        }
    }
    
    var heroesFiltered = [Hero]() {
        didSet {
            DispatchQueue.main.async {
                self.heroCollectionView.reloadData()
            }
        }
    }
    
    var contentList: [Hero] {
        return searchBarActive ? heroesFiltered : heroes
    }
    
    var searchBarActive: Bool = false
    var searchBarBoundsY: CGFloat?
    var searchBar: UISearchBar?
    
    let reuseIdentifier = "heroCollectionCell"
    
    @IBOutlet weak var heroCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadHeroesFromAPI()
        
        //tap
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(profileVC.refresh), for: UIControlEvents.valueChanged)
        heroCollectionView?.addSubview(refresher)
        
        SwiftSpinner.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addSearchBar()
        self.view.layoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = heroCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let bounds = heroCollectionView.bounds
        let ratio: CGFloat = 0.561
        let width: CGFloat = bounds.width / 3 - flowLayout.minimumInteritemSpacing * 2
        let height = width * ratio + 20
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    //refresh on pull
    func refresh() {
        heroCollectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: CollectionView implementing

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeroChooseCVC
        
        let hero = contentList[(indexPath as NSIndexPath).row]
        
        cell.hero = hero
        cell.heroNameLabel.text = hero.heroLocalizedName
        
        if let herolargeImageURL = hero.largeImageURL {
            cell.heroIconImage.kf.setImage(with:URL(string: herolargeImageURL)!,  options: [.transition(ImageTransition.fade(0.6))])
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! GuideMakerViewController
        if let cell = sender as? HeroChooseCVC {
            destVC.hero = cell.hero
        }
    
    }
    
    func downloadHeroesFromAPI() {
        
        Alamofire.request("http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=A041063D0F9386FD666F26E04598C9D0", method: .get, parameters: ["language":"en-us"],encoding: URLEncoding.default).validate().responseJSON(){ response in
            
            if !response.result.isSuccess {
                print("Error while fetching Heroes list : \(response.result.error)")
                return
            }
            
            guard let value = response.result.value as? NSDictionary else{
                print("Error no value found")
                return
            }
            guard let result = value["result"] as? NSDictionary else {
                print("Error no result found")
                return
            }
            guard let apiHeroes = result["heroes"] as? [NSDictionary] else{
                print("Error no heroes found")
                return
            }
            
            self.heroes = apiHeroes.flatMap {
                
                guard let id = $0["id"] as? Int,
                let localizedName = $0["localized_name"] as? String,
                let name = $0["name"] as? String else { return nil }
                
                let imageHeroName = name.replacingOccurrences(of: "npc_dota_hero_", with: "")
                let largeURL = "http://cdn.dota2.com/apps/dota2/images/heroes/\(imageHeroName)_lg.png"
                let smallURL = "http://media.steampowered.com/apps/dota2/images/heroes/\(imageHeroName)_sb.png"
                let portraitURL = "http://cdn.dota2.com/apps/dota2/images/heroes/\(imageHeroName)_vert.jpg"
            
                let hero = Hero(heroDotaName: name.replacingOccurrences(of: "npc_dota_hero_", with: ""), heroLocalizedName: localizedName, heroID: id,largeImageURL: largeURL,smallImageURL: smallURL,portraitImageURL: portraitURL)
    
                return hero
            }
            .sorted { $0.heroLocalizedName < $1.heroLocalizedName }
        }
    }
    
    
    //TODO: Refactor to a different class so it can be reusuable in the future if need be and free up space in the VC
    
    // MARK: SearchBar Delegate method
    
    func filterContentForSearchText(_ searchText:String) {
        heroesFiltered = heroes.filter {
            $0.heroLocalizedName.contains(searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarActive = !searchBarActive
        
        if searchText.characters.count > 0 {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = true
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
        searchBar.setShowsCancelButton(false, animated: false)
    }
    
    // MARK: Add Search Bar
    func addSearchBar() {
        
        if searchBar != nil { return }
        
        searchBarBoundsY = navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height
        searchBar = UISearchBar()
        searchBar?.searchBarStyle = .default
        searchBar?.tintColor = .white
        searchBar?.barTintColor = .white
        searchBar?.placeholder = "Search here"
        searchBar?.delegate = self
      
        navigationItem.titleView = searchBar
        searchBar?.anchorInCenter(width: 300, height: 44)
    }
}

