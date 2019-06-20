//
//  ViewController.swift
//  Demo07LancherAnimation
//
//  Created by Aditya Sharma on 9/14/18.
//  Copyright © 2018 AdityaSharma. All rights reserved.
//

import UIKit
private let popupOffset: CGFloat = 150

class ViewController: UIViewController {
    
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var altaLabel: UILabel!
    @IBOutlet weak var flowerImageWidthConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.altaLabel.frame = CGRect(x: ((UIScreen.main.bounds.width - 230)/2) + 80, y: (UIScreen.main.bounds.height - 80)/2, width: 0, height: 80)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.animateFlower()
        }
        
    }
    
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    
    func animateFlower() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 1, animations: {
            self.flowerImageView.frame = CGRect(x: (UIScreen.main.bounds.width - 80)/2, y: (UIScreen.main.bounds.height - 80)/2, width: 80, height: 80)
            self.flowerImageView.layer.cornerRadius = 40
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            var labelAnimators = [UIViewPropertyAnimator]()
            let locationAnimator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: {
                self.flowerImageView.frame = CGRect(x: (UIScreen.main.bounds.width - 230)/2, y: (UIScreen.main.bounds.height - 80)/2, width: 80, height: 80)
                self.flowerImageView.layer.cornerRadius = 0
                self.view.layoutIfNeeded()
            })
            let labelTransitionAnimator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: {
                self.altaLabel.frame = CGRect(x: ((UIScreen.main.bounds.width - 230)/2) + 80, y: (UIScreen.main.bounds.height - 80)/2, width: 150, height: 80)
                self.view.layoutIfNeeded()
            })
            let inTitleAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .easeOut, animations: {
                self.altaLabel.alpha = 1
                self.altaLabel.roundCorners([.topRight, .bottomRight], radius: 10)
                self.flowerImageView.roundCorners([.topLeft, .bottomLeft], radius: 10)
            })
            locationAnimator.startAnimation()
            labelTransitionAnimator.startAnimation()
            inTitleAnimator.startAnimation()
            labelAnimators.append(locationAnimator)
            labelAnimators.append(labelTransitionAnimator)
            labelAnimators.append(inTitleAnimator)
            self.runningAnimators.removeAll()
            locationAnimator.addCompletion({ (position) in
                labelAnimators.removeAll()
            })
        }
        let inTitleAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn, animations: {
            self.flowerImageView.alpha = 1
        })
        inTitleAnimator.scrubsLinearly = false
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
    }
    
}

public extension UIView{
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
