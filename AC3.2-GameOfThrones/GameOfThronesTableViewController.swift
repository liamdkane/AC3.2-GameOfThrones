//
//  GameOfThronesTableViewController.swift
//  AC3.2-GameOfThrones
//
//  Created by Jason Gresh on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class GameOfThronesTableViewController: UITableViewController {
    
    var episodes = [GOTEpisode]()
    var seasons = Set<Int>()
    enum Seasons: Int {
        case one = 1, two, three, four, five, six
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.title = "A Song of Ice and Fire"
        self.view.backgroundColor = .lightGray
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return seasons.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season: \(String(section + 1))"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let season = Seasons.init(rawValue: section + 1), let count = filterBySeason(season) else {return 0}
        return count.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GOTCell", for: indexPath)
        guard let season = Seasons.init(rawValue: indexPath.section + 1), let currentSeason = filterBySeason(season) else {return cell}
        let currentEpisode = currentSeason[indexPath.row]
        
        cell.textLabel!.text = currentEpisode.name
        cell.detailTextLabel!.text = currentEpisode.airdate
        
        if let url = URL.init(string: currentEpisode.image), let data = try? Data(contentsOf: url), let imageOfEpisode = UIImage.init(data: data) {
            cell.imageView?.image = imageOfEpisode
        }
        
        
        return cell
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegueID" {
            if let tappedCell = sender as? UITableViewCell {
                let cellIndex = self.tableView.indexPath(for: tappedCell)!
                guard let season = Seasons.init(rawValue: cellIndex.section + 1), let currentSeason = filterBySeason(season) else {return}
                let currentEpisode = currentSeason[cellIndex.row]
                let dvc = segue.destination as? DetailViewController
                dvc?.episode = currentEpisode
            }
        }
    }
    
    func filterBySeason (_ season: Seasons) -> [GOTEpisode]? {
        let filter: (GOTEpisode) -> Bool
        switch season {
        case .one:
            filter = { (a) -> Bool in
                a.season == 1
            }
        case .two:
            filter = { (a) -> Bool in
                a.season == 2
            }
        case .three:
            filter = { (a) -> Bool in
                a.season == 3
            }
        case.four:
            filter = { (a) -> Bool in
                a.season == 4
            }
        case.five:
            filter = { (a) -> Bool in
                a.season == 5
            }
        case .six:
            filter = { (a) -> Bool in
                a.season == 6
            }
        }
        return episodes.filter(filter).sorted(by: {$0.number < $1.number})
    }
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "got", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options:  NSData.ReadingOptions.mappedIfSafe),
            let dict = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary else {
                return
        }
        
        if let episodes = dict?.value(forKeyPath: "_embedded.episodes") as? [[String:Any]] {
            for epDict in episodes {
                if let ep = GOTEpisode(withDict: epDict) {
                    self.episodes.append(ep)
                    self.seasons.insert(ep.season)
                }
            }
        }
    }
}
