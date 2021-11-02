//
//  NetstatManager.swift
//  CPS
//
//  Created by MaciOS on 2021/6/7.
//  Copyright © 2021 air. All rights reserved.
//

import Foundation
import Reachability

class NetstatManager: UIViewController {
    
    /// 单例
    static let shared = NetstatManager()
    /// Reachability必须一直存在，所以需要设置为全局变量
    let reachability = try! Reachability()
    lazy var netAlert: NetstatAlertVC = {
        let alert = NetstatAlertVC()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .coverVertical
        return alert
    }()
    
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 判断是否联网
    func isNetworkConnect() -> Bool {
        return reachability.isReachable
    }
    
}

extension NetstatManager {
    /// 网络状态监听
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do {
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    /// 主动监测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
            }
            self.netAlert.dismiss(animated: false, completion: nil)
            // 由无网络到有网络时才发出通知
            NotificationCenter.default.post(name: NSNotification.Name("NetworkStatusChange"), object: nil)
        } else {
            print("连接类型：暂无网络")
            self.alert_noNetwrok()
        }
    }

    /// 警告框，提示没有连接网络
    func alert_noNetwrok() -> Void {
        if let topVC = ScreenUIManager.topViewController() {
            if let _ = topVC as? NetstatAlertVC {
                return
            }
        }
        // UIApplication.shared.keyWindow?.rootViewController?.present(self.netAlert, animated: false, completion: nil)
    }
    
}
