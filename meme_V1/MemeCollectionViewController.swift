//
//  MemeCollectionViewController.swift
//  meme_V1
//
//  Created by Sarah Al-Matawah on 16/06/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    
    var getMeme: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.sharedMeme
    }
    
    //MARK: View Creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //reinitlize collection view with sent meme to update with new sent meme
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //MARK: Collection View Data Source

    //get number of sent memes to set number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMeme.count
    }

    //Fill cells with sent memes
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.imageMemeCell.image = getMeme[indexPath.item].memedImage
    
        return cell
    }
    
    //MARK: Collection View Delegate
    
    //When cell selected, display the meme in a detailed meme view controller
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = self.storyboard!.instantiateViewController(identifier: "DetailedMemeViewController") as! DetailedMemeViewController
        detailedVC.memeDetail = self.getMeme[indexPath.row]
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    //MARK: Collection View Layout
    
    //set spacing/padding in cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //set cells layout sepending on orintation, if landscape or portrait
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Size of the collection view
        let collectionViewSize = view.bounds.size
        let collectionViewWidth = collectionViewSize.width
        let collectionViewHeight = collectionViewSize.height
        
        //propertie of the collection view cell size
        var collectionViewCellSize: CGSize
        
        //orintation layout
        let landscape = (collectionViewWidth - 40) / 5
        let protrait = (collectionViewWidth - 24) / 3
        //check view size to determine collection view cell size
        if collectionViewWidth > collectionViewHeight {
            collectionViewCellSize = CGSize(width: landscape, height: landscape)
        } else {
            collectionViewCellSize = CGSize(width: protrait, height: protrait)
        }
        
        return collectionViewCellSize
    }
    
    //MARK: Orientation Observer
    
    //reinitializes layout when rotation occures
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
