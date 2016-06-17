//
//  ViewController.swift
//  Flix
//
//  Created by Dimple Jethani on 6/15/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate{

    
    
    @IBOutlet weak var movieScroll: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [NSDictionary]?
    
    
    var filteredData: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieScroll.dataSource = self
        movieScroll.delegate = self
        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        movieScroll.insertSubview(refreshControl, atIndex: 0)
       
        
        
        //refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)) ,forControlEvents: UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
 
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchText.isEmpty {
            print("search is empty")
            filteredData = movies
        } else {
            print("search is not empty")
            filteredData = movies!.filter({(dataItem:NSDictionary) -> Bool in
               
            let title = dataItem["title"] as! String
            if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil{
                    return  true
            }
            else{
                    return false
            }
                
            })
        }
        
        movieScroll.reloadData()
    }

 
    func refreshControlAction(refreshControl:UIRefreshControl){
        let apiKey = "a838d9c9f9b869092df1195e5c12bd03"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        

        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        //print("response: \(responseDictionary)")
                        self.movies = (responseDictionary["results"] as! [NSDictionary])
                        
                        self.filteredData=self.movies
                        
                        self.movieScroll.reloadData()
                        refreshControl.endRefreshing()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                                
                    }
                }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filter=filteredData {
            return filter.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieScroll.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        
        let row = indexPath.row
        let movie = filteredData![row]
        print("ROW", row)
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl=NSURL(string:baseUrl + posterPath)
        let title = movie["title"] as! String
        cell.titleLabel.text=title
        
        let overview = movie["overview"] as! String
        cell.posterView.setImageWithURL(imageUrl!)
        cell.overviewLabel.text = overview
        
       
        return cell
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let indexPath = movieScroll.indexPathForCell(sender as! UITableViewCell)
        let row = indexPath!.row
        let movie = filteredData![row]
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl=NSURL(string:baseUrl + posterPath)
        let overview = movie["overview"] as! String
        let CellDetails = segue.destinationViewController as! cellDetailsView
        
        CellDetails.imageUrl = imageUrl
        CellDetails.movie_title = movie["title"] as! String
        CellDetails.overview_words = overview
        
    }
}