//
//  ViewController.swift
//  ImageLoader
//
//  Created by ApplePie on 28.03.18.
//  Copyright © 2018 VictorVolnukhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let imageView = UIImageView()
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
        
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            self.imageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        
        cell.accessoryView = self.imageView
        
        //cell.accessoryView = UIImageView(image: UIImage(named: "chair"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.height / 4
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

