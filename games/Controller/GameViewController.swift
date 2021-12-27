//
//  GameViewController.swift
//  games
//
//  Created by MAC on 04/11/2021.
//

import UIKit
import SafariServices

class GameViewController: UIViewController , GameDescriptionDelegate {
    
    @IBOutlet weak var goToWebButton: UIButton!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    var id : Int?
    var webUrl : String?
    let shared = Constants.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToWebButton.isHidden = true
        id = shared.gamesList[shared.gameIndex!].id
        
        if let gameId = id {
            var url = "https://api.rawg.io/api/games/\(gameId)?key=81f92c650c3b4ab8b3cb270a82276aae"
            GameDescrption.shared.performRequest(with: url)
        }
        
        GameDescrption.shared.delegate = self
    }
    

    func didUpdateGames(gameDesc : GameDescription) {
        DispatchQueue.main.async {
            self.gameDescription.text = gameDesc.description_raw
            self.webUrl = gameDesc.website
            if self.webUrl != ""{
                self.goToWebButton.isHidden = false
            }
            if let imageStr = self.shared.imageStr {
                let imageData = URL(string: imageStr)
                DispatchQueue.global().async {
                    if let url = imageData{
                        self.shared.imageData = try? Data(contentsOf: url)
                            DispatchQueue.main.async {
                                if let safeData = self.shared.imageData {
                                    self.gameImage.image = UIImage(data: safeData)
                            }
                        }
                    }
                }
            }
//            if self.imageData != nil {
//                self.gameImage.image = UIImage(data: self.imageData!)
//            }
        }
    }

    
    @IBAction func GoToWebIsPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "webIdentifier", sender: self)
        if let link = webUrl {
            if let url = URL(string: link) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: false)
            }
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "webIdentifier"{
//            let destinationVc = segue.destination as! WebViewController
//            destinationVc.url = webUrl
//        }
//    }
}
