//
//  FavoriteViewController.swift
//  Day6NewsAPI
//
//  Created by Mohamed Kotb Saied Kotb on 29/04/2024.
//

import UIKit
import SDWebImage

class FavoriteViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var favoriteArticles: [New] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite News"

        // Do any additional setup after loading the view.
        tableView.dataSource = self
                tableView.delegate = self
                fetchFavoriteArticles()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteArticles()
    }
    
    func fetchFavoriteArticles() {
            favoriteArticles = CoreDataHelper.shared.fetchSavedNews()
            tableView.reloadData()
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let article = favoriteArticles[indexPath.row]
        cell.textLabel?.text = article.title
        print(article.author!)
        cell.imageView?.sd_setImage(with: URL(string: article.imageUrl!), placeholderImage: UIImage(named: "man"))
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.new = favoriteArticles[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
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
