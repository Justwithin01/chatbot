//
//  AppDelegate.swift
//  Justwithin
//
//  Created by 林智浩 on 2017/9/16.
//  Copyright © 2017年 林智浩. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate var GoogleSinginClientID: String {
        return "" // TODO:- GOOGLE Appliction Key
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


        // 設定 Google 登入
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = GoogleSinginClientID //create your GoogleService-Info

        // 設定 FB 登入
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // TODO:- 要在info.plist 填入應用程式 ID

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool{
        //        print(msg: url)
        let fb_retrun = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: nil)
        print(msg: fb_retrun)
        let google_return = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as! String?
            , annotation: options[.annotation])

        return fb_retrun || google_return

    }

}

extension AppDelegate : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard  error == nil , let userId = user.userID, let name = user.profile.name, let email = user.profile.email else {
                print(msg:"\(error.localizedDescription)")
                Notifier.googleSign.post()
                return
        }

        let fullNameArr = name.characters.split{$0 == " "}.map(String.init)
        if(fullNameArr.count == 2){
            let firstName = fullNameArr[1]
            let lastName = fullNameArr[0]
            print(msg: firstName)
            print(msg: lastName)
        }else{
            // name
            print(msg: name)
        }
        // TODO : - 登入成功 發通知 看格式要怎樣寫
        Notifier.googleSign.post(object: nil, userInfo:[:])
    }

    /// 已登入狀態再按一次就會進入這段
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        // 正常不會出現已登入狀態 寫這段只是為了避免不正常的現象
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        print(msg: user)
    }
}

// MARK:- Method
extension AppDelegate {
    func fbLogin() {

        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]

        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {
            connection, result, error -> Void in

            if error != nil {
                print(msg:"longinerror =\(error?.localizedDescription ?? "")")
            } else {

                if let resultNew = result as? [String:Any]{
                    let email = resultNew["email"]  as! String
                    let firstName = resultNew["first_name"] as! String
                    let lastName = resultNew["last_name"] as! String

                    if let picture = resultNew["picture"] as? NSDictionary,
                        let data = picture["data"] as? NSDictionary,
                        let url = data["url"] as? String {
                        print(url) //臉書大頭貼的url, 再放入imageView內秀出來
                    }
                }
            }
        })
    }
}
