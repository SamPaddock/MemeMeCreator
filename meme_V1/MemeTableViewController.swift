//
//  MemeTableViewController.swift
//  meme_V1
//
//  Created by Sarah Al-Matawah on 16/06/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var getMeme: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.sharedMeme
    }
    
    //MARK: View Creation

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //reinitlize table view with sent meme to update with new sent meme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    //table has one section only
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //get number of sent memes to set number of rowa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMeme.count
    }
    
    //Fill row with sent memes
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! MemeTableViewCell
        
        cell.memeLabel.text = getMeme[indexPath.row].topText + " " + getMeme[indexPath.row].bottomText
        cell.memeImage.image = getMeme[indexPath.row].memedImage
        

        return cell
    }
    
    // MARK: - Table View Delegate
    
    //When row selected, display the meme in a detailed meme view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = self.storyboard!.instantiateViewController(identifier: "DetailedMemeViewController") as! DetailedMemeViewController
        detailedVC.memeDetail = self.getMeme[indexPath.row]
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    //Set row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    

}
