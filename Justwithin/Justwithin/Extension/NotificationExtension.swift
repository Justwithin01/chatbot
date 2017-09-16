//
//  NotificationExtension.swift
//  Justwithin
//
//  Created by 林智浩 on 2017/9/16.
//  Copyright © 2017年 林智浩. All rights reserved.
//

import UIKit


/*
 // 註冊
 Notifier.localizedChange.addObserver(by: self, withS: #selector(AppDelegate.receive(_:)) )
 // 發送
 Notifier.localizedChange.post()
 // 移除
 Notifier.localizedChange.remove(from: self)
 */

enum Notifier: Notifiable{

    case googleSign

    var name : Notification.Name {
        switch self {
        case .googleSign: return  Notification.Name(rawValue: "googleSignNotificationName")
        }
    }
}

protocol Notifiable {

    var name: Notification.Name {get}
    func addObserver<T: AnyObject>(by observer: T, with selector: Selector, object: Any?)
    func post(object: Any?, userInfo: [AnyHashable:Any]?)
    func remove<T: AnyObject>(from observer: T)
}

extension Notifiable {

    func addObserver<T: AnyObject>(by observer: T, with selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    func post(object: Any? = nil, userInfo: [AnyHashable:Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }

    func remove<T: AnyObject>(from observer: T) {
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }

}

