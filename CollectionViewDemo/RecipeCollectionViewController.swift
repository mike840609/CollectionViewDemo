//
//  RecipeCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by 蔡鈞 on 2016/2/18.
//  Copyright © 2016年 mike840609. All rights reserved.
//

import UIKit
import Social

private let reuseIdentifier = "Cell"

class RecipeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var shareButton:UIBarButtonItem!
    
    var shareEnabled = false
    var selectedRecipes = [String]()
    
    
    var recipeImages = ["angry_birds_cake", "creme_brelee", "egg_benedict", "full_breakfast", "green_tea", "ham_and_cheese_panini", "ham_and_egg_sandwich", "hamburger", "instant_noodle_with_egg.jpg", "japanese_noodle_with_pork", "mushroom_risotto", "noodle_with_bbq_pork", "starbucks_coffee", "thai_shrimp_cake", "vegetable_curry", "white_chocolate_donut"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return recipeImages.count
    }

    // 設定cell內容
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // 設定可回收識別器 dequeueReusableCellWithReuseIdentifier
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecipeCollectionViewCell
    
        cell.recipeImageView.image = UIImage(named: recipeImages[indexPath.row])
        
        cell.backgroundView = UIImageView(image: UIImage(named:"photo-frame"))
        
        cell.selectedBackgroundView = UIImageView(image:UIImage(named: "photo-frame-selected"))
        
        return cell
    }
    
    // prepareForSegue 方法 傳值到 RecipeViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showRecipePhoto"{
            
            var indexPaths = collectionView?.indexPathsForSelectedItems()
            let destinationViewController = segue.destinationViewController as! UINavigationController
            let recipeViewController =  destinationViewController.viewControllers[0] as! RecipeViewController
            
            recipeViewController.recipeImageName = recipeImages[indexPaths![0].row]
            collectionView?.deselectItemAtIndexPath(indexPaths![0], animated: false)
        }
    }
    
    // 選取項目
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            return
        }
        
        // Determine the selected items by using the indexPath
        let selectedRecipe = recipeImages[indexPath.row]
        
        // Add the selected item into the array
        selectedRecipes.append(selectedRecipe)
    }
    
    // 反選項目
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            return
        }
        
        let deSelectedRecipe = recipeImages[indexPath.row]
        if let index = recipeImages.indexOf(deSelectedRecipe) {
            recipeImages.removeAtIndex(index)
        }
    }
    

    @IBAction func shareButtonTapped(sender: AnyObject){
        
        // Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            // If sharing is not enable, change shareEnabled to true and change the button text to Upload
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareButton.title = "Upload"
            shareButton.style = UIBarButtonItemStyle.Done
            
            return
        }
        
        // Check if there is any selected recipes, otherwise, just leave this method
        guard selectedRecipes.count > 0 else {
            return
        }
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            // 設定 Facebook 編輯器
            let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookComposer.setInitialText("Check out my recipes!")
            
            for recipePhoto in selectedRecipes {
                facebookComposer.addImage(UIImage(named: recipePhoto))
            }
            
            presentViewController(facebookComposer, animated: true, completion: nil)
        }
        
        // Deselect all selected items
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            for indexPath in indexPaths {
                collectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            }
        }
        
        // Remove all items from selectedRecipes array
        selectedRecipes.removeAll(keepCapacity: true)
        
        // Change the sharing mode to NO
        shareEnabled = false
        collectionView?.allowsMultipleSelection = false
        shareButton.title = "Share"
        shareButton.style = UIBarButtonItemStyle.Plain

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showRecipePhoto" {
            if shareEnabled {
                return false
            }
        }
        
        return true
    }
    
    
    
    // 判斷直立,橫向 尺寸類別 ６plus 則改變 cell 大小,以容納更多 cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let sideSize = (traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular) ? 80.0 : 128.0
        
        /*  改變排列顯示
        let collectionViewSize = collectionView.frame.size
        let collectionViewArea = Double(collectionViewSize.width * collectionViewSize.height)
        let sideSize: Double = sqrt(collectionViewArea / (Double(doodleImages.count))) - 30.0
        */
        
        return CGSize(width: sideSize, height: sideSize)
    }
    
    // 對尺寸類別變更進行回應
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
    }
    @IBAction  func unwindToHomeScreen(segue:UIStoryboardSegue){
        
    }

}
