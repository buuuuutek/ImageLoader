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

    private var imageView = UIImageView()
    private let myArray: NSArray =
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
        
        self.view.addSubview(newTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        Alamofire.request("https://httpbin.org/image/png").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                cell.accessoryView = UIImageView(image: image)
            }
        }

        return cell
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.height / 4
    }

}

