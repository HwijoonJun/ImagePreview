//
//  ViewController.swift
//  ImagePreview
//
//  Created by Alex Jun on 2023-03-18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var initialPath: URL?
    
    convenience init() {
        self.init(initialPath: Bundle.main.url(forResource: "placeholder", withExtension: "png")!)
    }
    
    init(initialPath: URL) {
        self.initialPath = initialPath
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        
        // add initial image to show when app is launched without image
        var image = UIImage(named: "placeholder.png")
        if(initialPath != nil){
            image = UIImage(contentsOfFile: initialPath!.absoluteString)
            
            do {
                let data = try Data(contentsOf: initialPath!)
                let image = UIImage(data: data)
                imageView.image = image
                
            } catch {
                print(error)
            }
        } else{
            imageView.image = image
        }
        
        
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}

