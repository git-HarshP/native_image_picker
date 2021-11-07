import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var flutterChannelManager: FlutterChannelManager!
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup flutterChannelManager
        guard let controller = window.rootViewController as? FlutterViewController else {
          fatalError("Invalid root view controller")
        }
        
        flutterChannelManager = FlutterChannelManager(flutterViewController: controller)
        flutterChannelManager.setup()
    
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


