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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\n ....called after pop")
        self.collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMeme.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.imageMemeCell.image = getMeme[indexPath.item].memedImage
    
        return cell
    }
    
    //MARK: Collection View Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 24, bottom: 6, right: 24)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Size of the collection view
        let collectionViewSize = collectionView.bounds.size
        let collectionViewWidth = collectionViewSize.width
        let collectionViewHeight = collectionViewSize.height
        //propertie of the collection view cell size
        var collectionViewCellSize: CGSize
        //check view size to determine collection view cell size
        if collectionViewWidth > collectionViewHeight {
            collectionViewCellSize = CGSize(width: collectionViewSize.width / 4, height: collectionViewSize.height / 3)
        } else {
            collectionViewCellSize = CGSize(width: collectionViewSize.width / 3, height: collectionViewSize.height / 4)
        }
        
        return collectionViewCellSize
    }
    
    //reinitializes layout when rotation occures
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    


    

}
