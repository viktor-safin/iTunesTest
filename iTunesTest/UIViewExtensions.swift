
import  UIKit

extension UIViewController {
        
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UIView {
    
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    func attach(toItem view: UIView) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = view.frame
        view.addSubview(self)
        
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addShadow(color: UIColor, opacity: Float, ofSet: CGSize, radius: CGFloat) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = ofSet
        self.layer.shadowRadius = radius
    }
    
    func snapshotView() -> UIImage? {
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 3.0)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func fadeIn(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0,
                onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                          if let complete = onCompletion { complete() }
                       }
        )
    }

    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                           self.isHidden = true
                           if let complete = onCompletion { complete() }
                       }
        )
    }
}


extension UITableView {
    
    func register<T: UITableViewCell>(cellClass: T.Type) {
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: cellClass.className, ofType: "nib") != nil {
            let nib = UINib(nibName: cellClass.className, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellClass.className)
        } else {
            register(cellClass.self, forCellReuseIdentifier: cellClass.className)
        }
    }
}


private var imageCahce = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func load(urlString : String) {
        if let image = imageCahce.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data (contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCahce.setObject (image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
