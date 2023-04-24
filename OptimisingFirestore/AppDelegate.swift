//
//  AppDelegate.swift
//  OptimisingFirestore
//
//  Created by Karandeep Singh on 24/4/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		return true
	}
}
