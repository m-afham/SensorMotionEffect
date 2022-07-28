//
//  ViewController.swift
//  SensorMotion
//
//  Created by M Afham on 07/06/2022.
//

import UIKit
import CoreMotion

class ExampleViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var expView: UIView!
   
    // MARK: - Properties
    
    lazy var blurredBackgroundImageView: UIImageView = {
        let iv: UIImageView = .init()
        iv.image = .init(named: "backgroundImage")
        iv.frame = self.view.bounds
        iv.applyBlurEffect()
        iv.layer.zPosition = -1
        return iv
    }()
    
    lazy var imageView: UIImageView = {
        let iv: UIImageView = .init()
        iv.image = .init(named: "backgroundImage")
        iv.frame = self.expView.bounds
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    private let motionManager = CMMotionManager()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startObserving()
    }
}

// MARK: - Motion Effect
extension ExampleViewController {
    func startObserving() {
        let value = 32
        let horizontalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.shadowOffset.width",
            type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = value
        horizontalEffect.maximumRelativeValue = -value

        let verticalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.shadowOffset.height",
            type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = value
        verticalEffect.maximumRelativeValue = -value

        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [ horizontalEffect,
                                      verticalEffect ]

        expView.addMotionEffect(effectGroup)
    }
}

// MARK: - UI Setup
extension ExampleViewController {
    func setupUI() {
        self.view.addSubview(blurredBackgroundImageView)
        self.expView.addSubview(imageView)
        expView.dropShadow(color: .black, opacity: 1.0, offSet: .init(width: 1, height: 1), radius: 3.0, scale: true)
    }
    
}

// MARK: - View Shadow
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - Image View Blur Effect
extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
