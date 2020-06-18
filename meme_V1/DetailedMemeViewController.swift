//
//  DetailedMemeViewController.swift
//  meme_V1
//
//  Created by Sarah Al-Matawah on 18/06/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class DetailedMemeViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var memedImage: UIImageView!
    //Passed selected meme from previous view controller
    var memeDetail: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        //sellected me set in image view
        memedImage.image = memeDetail.memedImage
    }
}
