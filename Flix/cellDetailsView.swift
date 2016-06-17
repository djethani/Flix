//
//  cellDetailsView.swift
//  Flix
//
//  Created by Dimple Jethani on 6/16/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class cellDetailsView: UIViewController {
    
    var imageUrl: NSURL!
    var movie_title:String = ""
    var overview_words:String=""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overview: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImageWithURL(imageUrl)
        navigationItem.title = movie_title
        overview.text = overview_words
        overview?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
