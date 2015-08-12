//
//  AppDelegate.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Flurry.startSession(FlurryAPIKey)
    Flurry.setDebugLogEnabled(true)
    Flurry.setLogLevel(FlurryLogLevelDebug)
    
    Crashlytics.startWithAPIKey("955b68eaf66e0210af84f1c1148355ff2fa60905")
    
    return true
  }
}

