
import UIKit
import Foundation

class ViewController : UIViewController {
    
    private var myBigDataReal : NSData! = nil
    var myBigData : NSData! {
        set (newdata) {
            self.myBigDataReal = newdata
        }
        get {
            if myBigDataReal == nil {
                let fm = NSFileManager()
                let f = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("myBigData")
                if fm.fileExistsAtPath(f) {
                    print("loading big data from disk")
                    self.myBigDataReal = NSData(contentsOfFile: f)
                    do {
                        try fm.removeItemAtPath(f)
                        print("deleted big data from disk")
                    } catch {
                        print("Couldn't remove temp file")
                    }
                }
            }
            return self.myBigDataReal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // wow, this is some big data!
        self.myBigData = "howdy".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
    
    // tap button to prove we've got big data
    
    @IBAction func doButton (sender:AnyObject?) {
        let s = NSString(data: self.myBigData, encoding: NSUTF8StringEncoding) as! String
        let av = UIAlertController(title: "Got big data, and it says:", message: s, preferredStyle: .Alert)
        av.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(av, animated: true, completion: nil)
    }
    
    // to test, run the app in the simulator and trigger a memory warning
    
    func saveAndReleaseMyBigData() {
        if let myBigData = self.myBigData {
            print("unloading big data")
            let f = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("myBigData")
            myBigData.writeToFile(f, atomically:false)
            self.myBigData = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("did receive memory warning")
        super.didReceiveMemoryWarning()
        self.saveAndReleaseMyBigData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // on device
    
    @IBAction func doButton2(sender: AnyObject) {
        UIApplication.sharedApplication().performSelector("_performMemoryWarning")
    }
    
    // backgrounding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backgrounding:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func backgrounding(n:NSNotification) {
        self.saveAndReleaseMyBigData()
    }
    
}
