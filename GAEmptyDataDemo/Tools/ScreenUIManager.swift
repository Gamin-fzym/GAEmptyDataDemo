//
//  ScreenUIManager.swift
//  RedEvelope
//
//  Created by 刘远凌 on 2018/9/12.
//  Copyright © 2018年 聚云商科技. All rights reserved.
//

import UIKit

class ScreenUIManager: NSObject {
    
    /// 获取顶部控制器 无要求
    static func topViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level(rawValue: 0) {
        //if window?.windowLevel != 0{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level(rawValue: 0) {
                //if windowTemp.windowLevel == 0{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    
    static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            // modal出来的控制器
            return getTopVC(withCurrentVC: presentVC)
        } else if let tabVC = VC as? UITabBarController {
            // tabBar的根控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let navVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:navVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }

}
