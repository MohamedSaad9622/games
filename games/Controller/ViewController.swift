//
//  ViewController.swift
//  games
//
//  Created by MAC on 03/11/2021.
//

import UIKit

class ViewController: UIViewController, GamesManagerDelegate {
    func didUpdateGames(gameDesc: GameDescription) {
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    let shared = Constants.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swipe to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.backgroundView = refreshControl

        
        GamesManager.shared.performRequest(with: shared.url)
        
        tableView.register(UINib(nibName: shared.GameCellNibName, bundle: nil), forCellReuseIdentifier: shared.gameCell_Identifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GamesManager.shared.delegate = self
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if shared.searchTest {
            GamesManager.shared.performRequest(with: shared.searchLink!)
        }
        else{
            GamesManager.shared.performRequest(with: shared.url)
        }
        refreshControl.endRefreshing()
    }
    
}


//MARK: - tableView & segue

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ViewController.gamesList.count
        return shared.gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: shared.gameCell_Identifier, for: indexPath) as! GameTableViewCell

        cell.gameName.text = shared.gamesList[indexPath.row].name
        cell.gameRating.text = String(shared.gamesList[indexPath.row].rating)

        // to show the image from its url
        let imageUrl = URL(string: shared.gamesList[indexPath.row].background_image)
        DispatchQueue.global().async {
            if let url = imageUrl{
                self.shared.imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let safeData = self.shared.imageData {
                            cell.gameImage.image = UIImage(data: safeData)
                    }
                }
            }
        }
        
//        to load more games (by start new request api) when scroll to the end of tableView
//        if indexPath.row == ViewController.gamesList.count - 1  {
//            if let nextList = self.nextGamesList{
//                GamesManager.shared.performRequest(with: nextList)
//            }
//        }
        return cell
    }
    
//     add pagination to load more games
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == shared.gamesList.count - 1 {
            if let nextList = self.shared.nextGamesList {
                shared.showMoreGames = true
                GamesManager.shared.performRequest(with: nextList)
            }
        }
    }

    // perform seque when choose any cell (open  GameViewController)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shared.gameIndex = indexPath.row
        GamesManager.isGameViewController = true
        shared.imageStr = shared.gamesList[indexPath.row].background_image
        // to open GameViewController programmatically
        let storyBoard = UIStoryboard(name: shared.DetailsStoryboard, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: shared.DetailsStoryboardID) as! GameViewController
        navigationController?.pushViewController(newViewController, animated: false)
    }
//    // for send data to GameViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
//        if segue.identifier == "segueIdentifier" {
//            let destinationVc = segue.destination as! GameViewController
//            destinationVc.id = gamesList[gameIndex].id
//            destinationVc.imageData = imageData
//        }
//    }
}

//MARK: - update ui

extension ViewController{
    // to recieve the data from GamesManager by the delegate
    func didUpdateGames(games: GameData) {
        
        DispatchQueue.main.async {
            // because every link have 20 games and there is link to another 20 games called "next"
//            if ViewController.gamesList.count == 0 || self.searchTest == true {
//                self.searchTest = false
            if self.shared.showMoreGames{
                self.shared.showMoreGames = false
                self.shared.gamesList += games.results
                self.shared.nextGamesList = games.next
            }else {
                self.shared.gamesList = games.results
                self.shared.nextGamesList = games.next
            }
            self.tableView.reloadData()
        }
    }
}


// MARK: - UISearchBarDelegate

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchVal = searchBar.text {
            shared.searchLink = shared.searchUrl + searchVal
            shared.searchTest = true
            GamesManager.shared.performRequest(with: shared.searchLink!)
            searchBar.resignFirstResponder()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // scroll to the top
        tableView.setContentOffset(.zero, animated: true)
        GamesManager.shared.performRequest(with: shared.url)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.showsCancelButton = false
        shared.searchTest = false
    }
}
