//
//  NewsDetailViewController.swift
//  Day6NewsAPI
//
//  Created by Mohamed Kotb Saied Kotb on 29/04/2024.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    
    @IBOutlet weak var favBtn: UIButton!
    var new: New!
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var publishAtLabel: UILabel!
    
    
    
    @IBAction func favoriteButton(_ sender: UIButton) {
              sender.isSelected.toggle()
                if sender.isSelected {
                    saveArticleToCoreData()
                } else {
                    deleteArticleFromCoreData()
                }
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        favBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                
        // Check if the article is already favorited
        favBtn.isSelected = isArticleFavorited()
        
        self.title = "Details"
        authorLabel.text = new.author
        titleLabel.text = new.title
        descriptionTextView.text = new.desription
        publishAtLabel.text = new.publishedAt
        imageView.sd_setImage(with: URL(string: new.imageUrl!), placeholderImage: UIImage(named: "man"))
    }
    
    func isArticleFavorited() -> Bool {
            guard let new = new else { return false }
            return CoreDataHelper.shared.isArticleFavorited(new: new)
        }
        
        func saveArticleToCoreData() {
            guard let new = new else { return }
            CoreDataHelper.shared.saveNew(new: new)
        }
        
        func deleteArticleFromCoreData() {
            guard let new = new else { return }
            CoreDataHelper.shared.deleteNew (new: new)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
