//
//  AppDelegate.swift
//  NetworkCache
//
//  Created by Eden on 16/12/6.
//  Copyright © 2016年 Eden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*[
         {
         "id": "694c1223-6ed9-4633-9a40-145520fbaa7b",
         "title": "Command Line Tools with Swift"
         },
         {
         "id": "651728f9-33e0-4a66-bd75-171764c82045",
         "title": "Structs and Mutation"
         },
         {
         "id": "fb465ae0-a84e-411a-a9f1-dafea9a25d1d",
         "title": "Understanding Value Type Performance"
         }
         ]*/
        let endPoint: EndPoint<[Object]> = EndPoint(url: NSURL(string: "http://localhost/episodes.json") as! URL, parse: {data in
            
            if let jsonList = data as? [JSONDictonary] {
                var list: Array<Object> = []
                for json in jsonList {
                    let obj = Object(json: json)
                    if let obj = obj {
                        list.append(obj)
                    }
                }
                
                return list
            }
            
            return nil
        })
        
//        let webService = WebSevice()
//        webService.load(endPoint, completion: { result in
//            if let value = result.value {
//                print(value)
//            }
//        })
//        
        let webservice = WebSevice()
        let cachewebService = CachedWebService(webservice)
        cachewebService.load(endPoint, completion: { result in
            if let value = result.value {
                print(value)
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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


}

