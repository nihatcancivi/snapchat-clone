//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Nihat on 4.03.2022.
//

import UIKit
import ImageSlideshow
class SnapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snap = selectedSnap{
            timeLabel.text = "Time left : \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
           
            
            let imageSlideshow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width*0.95, height: self.view.frame.height*0.90))
            imageSlideshow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()//alttaki çizgiyi oluşturma
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray//GÖSTERİLEN RENK
            pageIndicator.pageIndicatorTintColor = UIColor.black//diğerleri
            imageSlideshow.pageIndicator = pageIndicator
            
            imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFit//görsel normalhali
            imageSlideshow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideshow)
            self.view.bringSubviewToFront(timeLabel)//timelabel önde gösterme
                
            
        }
    }

}
