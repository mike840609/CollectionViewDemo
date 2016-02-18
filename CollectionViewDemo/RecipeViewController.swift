//
//  RecipeViewController.swift
//  CollectionViewDemo
//
//  Created by 蔡鈞 on 2016/2/18.
//  Copyright © 2016年 mike840609. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView:UIImageView!
    
    var recipeImageName:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.image = UIImage(named:recipeImageName)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
