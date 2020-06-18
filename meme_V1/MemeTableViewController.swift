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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        for i in 0..<getMeme.count {
            print("table row will appear \(i)")
            print(getMeme[i].topText)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("table rows \(getMeme.count)")
        return getMeme.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        print("table row \(indexPath.row) has \(getMeme[indexPath.row].topText)")
        cell.imageView?.image = getMeme[indexPath.row].memedImage
        cell.textLabel?.text = getMeme[indexPath.row].topText
        cell.detailTextLabel?.text = getMeme[indexPath.row].bottomText

        return cell
    }
    
   
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    

}
