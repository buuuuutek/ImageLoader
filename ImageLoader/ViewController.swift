//
//  ViewController.swift
//  ImageLoader
//
//  Created by ApplePie on 28.03.18.
//  Copyright © 2018 VictorVolnukhin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private let imageCache = AutoPurgingImageCache()
    private let myArray: Array<String> =
        ["https://s.appleinsider.ru/2017/12/apple-watch.jpg",
         "https://aip-a.akamaihd.net/2013/09/apple-mac-high-resolution-wallpaper-11.png",
         "http://mobiltelefon.ru/photo/september15/07/apple_watch_in_use_02.jpg",
         "http://www.smartwatchpro.ru/wp-content/uploads/2016/10/Apple-AirPods.png",
         "https://cdn.lifehacker.ru/wp-content/uploads/2017/12/aw-01-complect_1514290940.jpg",
         "https://espanarusa.com/files/autoupload/68/81/16/bwgkcrit380039.jpg",
         "https://trashbox.ru/files/290787_8a47ef/0909-apple-watch-100413659-orig.jpg",
         "https://habrastorage.org/getpro/geektimes/post_images/7a8/a5f/2b6/7a8a5f2b6e9053e8cf673c14d1f920cd.jpg",
         "http://media.idownloadblog.com/wp-content/uploads/2015/04/Apple-Watch-Edition-back-Wired-002.jpg",
         "https://static.giga.de/wp-content/uploads/2015/04/Apple-Watch-copy.jpg",
         "https://vivalacloud.ru/wp-content/uploads/2017/09/apple-watch.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableViewToViewController()
        
        downloadImages()
        
    }
    
    func addTableViewToViewController() {
        
        // TableView dimensions:
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let newTableView = UITableView(frame:
            CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        newTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        newTableView.dataSource = self
        newTableView.delegate = self
        
        self.tableView = newTableView
        self.view.addSubview(newTableView)
    }
    
    func downloadImages() {
        for url in myArray {
            
            let index = self.myArray.index(of: url)!
            
            
            Alamofire.request(url).responseImage { response in
                //debugPrint(response)
                
//                print(response.request)
//                print(response.response)
//                debugPrint(response.result)
                
                if let image = response.result.value {
                    print(index)
                    self.imageCache.add(image, withIdentifier: String(describing: index))
                    print("===============================================================")
                    print("String(describing: self.myArray.index(of: url)): \(index)")
                    print(self.imageCache.image(withIdentifier: String(index)))
                    print("===============================================================")
                }
                
                let indexPath = IndexPath(item: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let size = CGSize(width: cell.frame.width, height: cell.frame.height)
        
        let cachedPicture = self.imageCache.image(withIdentifier: String(indexPath.row))
        print(cachedPicture)
        
        let aspectScaledToFillImage = cachedPicture?.af_imageAspectScaled(toFill: size)
        
        
        
        cell.accessoryView = UIImageView(image: aspectScaledToFillImage)
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.height / 4
    }

}

