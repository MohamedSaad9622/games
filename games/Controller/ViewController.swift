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
    

    // to recieve games list from GamesManager
    var gamesList = [Results]()
    // the link for next 20 games (next list)
    var nextGamesList : String?
    var gameIndex : Int = 0
    // to save image data to show in GameViewController without need to reload this data again
    var imageData : Data?
    
    var searchTest = false
    
    let url = "https://api.rawg.io/api/games?key=81f92c650c3b4ab8b3cb270a82276aae&dates=2021-01-01,2021-09-30&ordering=-rating"
    var searchUrl = "https://api.rawg.io/api/games?key=81f92c650c3b4ab8b3cb270a82276aae&dates=2021-01-01,2021-09-30&ordering=-rating&search="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swipe to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.backgroundView = refreshControl

        
        GamesManager.shared.performRequest(with: url)
        GamesManager.shared.delegate = self
        GamesManager.shared.viewName = "ViewController"
        
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell_Identifier")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if searchTest {
            GamesManager.shared.performRequest(with: searchUrl)
        }
        else{
            GamesManager.shared.performRequest(with: url)
        }
        
        refreshControl.endRefreshing()
        
    }
    
}


//MARK: - tableView & segue

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell_Identifier", for: indexPath) as! GameTableViewCell

        cell.gameName.text = gamesList[indexPath.row].name
        cell.gameRating.text = String(gamesList[indexPath.row].rating)

        // to show the image from its url
        let imageUrl = URL(string: gamesList[indexPath.row].background_image)
        DispatchQueue.global().async {
            if let url = imageUrl{
                self.imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let safeData = self.imageData {
                            cell.gameImage.image = UIImage(data: safeData)
                    }
                }
            }
        }
        
        // to load more games (by start new request api) when scroll to the end of tableView
        if indexPath.row == gamesList.count - 1  {
            if let nextList = self.nextGamesList{
                GamesManager.shared.performRequest(with: nextList)
            }
        }
        return cell
    }
    

    // perform seque when choose any cell (open  GameViewController)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameIndex = indexPath.row
        let storyBoard: UIStoryboard = UIStoryboard(name: "DetailsStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsStoryboardID") as! GameViewController
        navigationController?.pushViewController(newViewController, animated: false)
    }
    // for send data to GameViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "segueIdentifier" {
            let destinationVc = segue.destination as! GameViewController
            destinationVc.id = gamesList[gameIndex].id
            destinationVc.imageData = imageData
        }
    }
    
}

//MARK: - update ui

extension ViewController{
    // to recieve the data from GamesManager by the delegate
    func didUpdateGames(games: GameData) {
        
        DispatchQueue.main.async {
            // because every link have 20 games and there is link to another 20 games called "next"
            if self.gamesList.count == 0 || self.searchTest == true {
                self.searchTest = false
                self.gamesList = games.results
                self.nextGamesList = games.next
            }else{
                self.gamesList += games.results
                self.nextGamesList = games.next
            }
            self.tableView.reloadData()
        }
    }
}


// MARK: - UISearchBarDelegate

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchVal = searchBar.text {
            searchTest = true
            searchUrl += searchVal
            GamesManager.shared.performRequest(with: searchUrl)
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTest = true
        GamesManager.shared.performRequest(with: url)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.showsCancelButton = false
    }
}
