//
//  CollectionViewController.swift
//  Day6NewsAPI
//
//  Created by Mohamed Kotb Saied Kotb on 29/04/2024.
//

import UIKit
import SDWebImage
import Reachability


class CollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var news: [New] = []
    var indicator : UIActivityIndicatorView?
    var reachability: Reachability!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
        
        getData()
        
        self.title = "News List"
        indicator = UIActivityIndicatorView(style: .medium)
        indicator!.center = view.center
        indicator!.startAnimating()
        view.addSubview(indicator!)
//        getDataFromApi { [weak self] news in
//                    self?.news = news
//                    DispatchQueue.main.async {
//                        self?.indicator?.stopAnimating()
//                        self?.collectionView.reloadData()
//                    }
//                }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        if reachability.connection != .unavailable {
            getData()
        }
    }

    func getData() {
        if reachability.connection != .unavailable {
            getDataFromApi { [weak self] news in
                self?.news = news
                DispatchQueue.main.async {
                    self?.indicator?.stopAnimating()
                    self?.collectionView.reloadData()
                    for new in news {
                        print("saved to home")
                        CoreDataHelper.shared.saveHomeNew(new: new)
                    }
                }
            }
        } else {
            if let savedNews = CoreDataHelper.shared.fetchSavedHomeNews() {
                print("offline")
                news = savedNews
                self.indicator?.stopAnimating()
                collectionView.reloadData()
            } else {
                print("No cached data available")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2.4, height: view.frame.width / 2)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
                let new = news[indexPath.item]
        cell.titeleLabel.text = new.author
        //print(new.title!)
        cell.imageView.sd_setImage(with: URL(string: news[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "man"))
                return cell
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
           detailVC.new = news[indexPath.item]
           navigationController?.pushViewController(detailVC, animated: true)
       }
    
    
    
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
//        
//            // Configure the cell
//        cell.titeleLabel.text = news[indexPath.row].title
//        print(news[indexPath.row].title!)
////        cell.imageView.sd_setImage(with: URL(string: news[indexPath.row].url!), placeholderImage: UIImage(named: "man"))
//        
//            return cell
//        }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func getDataFromApi(handler: @escaping (([New]) -> Void)) {
        let url = URL(string: "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json")
        guard let url = url else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            do {
                let result = try JSONDecoder().decode([New].self, from: data)
                handler(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

}
