//
//  AppDelegate.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import GoogleMobileAds
import GooglePlaces



private let YOUR_CLIENT_ID = "651320784939-idkntamsfsd19kmue6iki2qkdjbnut0u.apps.googleusercontent.com"
private let YOUR_ADMOB_APP_ID = "ca-app-pub-7864413541660030~4751525194"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    

    var window: UIWindow?
    static var appdelegate = AppDelegate()
    var leftMenu : LeftMenuTVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = YOUR_CLIENT_ID
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GADMobileAds.configure(withApplicationID: "YOUR_ADMOB_APP_ID")
        GMSPlacesClient.provideAPIKey("AIzaSyC3-ksmrjduuSNso-Z9wOCSeXvQACcV1jU")
        CurrentUser.sharedInstance.load()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.absoluteString.contains("facebook") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else
        {
           return GIDSignIn.sharedInstance().handle(url,
                                              sourceApplication: sourceApplication,
                                              annotation:annotation)
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func goToHome(_ animated: Bool?, afterLaunchScreen: Bool = false)
    {
        
        let leftMenuTVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuTVC") as! LeftMenuTVC
        
        var middleVC : UIViewController
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        middleVC = vc
        
        
        
        self.leftMenu = leftMenuTVC
        let navigationController = UINavigationController(rootViewController: middleVC)
        
        let slideMenuController = SlideMenuController(mainViewController:navigationController, leftMenuViewController: leftMenuTVC)
        if ((animated) != nil) {
            UIView.transition(with: self.window!, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                self.window?.rootViewController = slideMenuController
            }, completion: nil)
        }
        else {
            self.window?.rootViewController = slideMenuController
        }
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
    }
    
    func goToLogin(_ animated: Bool) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        
        if (animated) {
            UIView.transition(with: self.window!, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.window?.rootViewController = vc
            }, completion: nil)
        }else{
            UIView.transition(with: self.window!, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.window?.rootViewController = vc
            }, completion: nil)
        }
        
    }
    
    

    static func appDelegate() -> AppDelegate{
        DispatchQueue.main.async() {
            appdelegate = UIApplication.shared.delegate as! AppDelegate
        }
        return appdelegate
    }
    
    
    func disableLeftSlide( _ shouldDisable : Bool ) {
        
        (self.window?.rootViewController as? SlideMenuController)?.disableLeftSlide(shouldDisable)
    }

}

