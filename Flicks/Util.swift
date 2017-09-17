//
//  Util.swift
//  Flicks
//
//  Created by Raina Wang on 9/16/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import Foundation
import UIKit

struct Util {
    static func handleError(error: Error, controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertView = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertViewController
        alertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        controller.addChildViewController(alertView)
        controller.view.addSubview(alertView.view)
        alertView.didMove(toParentViewController: controller)

        alertView.errorMessage.text = error.localizedDescription
    }
    static func loadImageFromLowToHigh(imgView: UIImageView, lowResURL: URL, highResURL: URL) {
        let smallImageRequest = URLRequest(url: lowResURL)
        let largeImageRequest = URLRequest(url: highResURL)
        
        imgView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                imgView.alpha = 0.0
                imgView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    imgView.alpha = 1.0
                }, completion: { (sucess) -> Void in
                    imgView.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            imgView.image = largeImage;
                        },
                        failure: { (request, response, error) -> Void in
                        })
                })
            },
            failure: { (request, response, error) -> Void in
        })
    }
    static func minsToHoursMinutes (mins : Int) -> (Int, Int) {
        return (mins / 60, (mins % 60))
    }
}
