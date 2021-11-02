//
//  BaseVC.swift
//  GAEmptyDataDemo
//
//  Created by MaciOS on 2021/10/22.
//

import UIKit
import EmptyDataSet_Swift
import SnapKit

class BaseVC: UIViewController {
    
    // 暂无数据 自定义视图
    var emptyDataCustomView: EmptyDataCustomView?
    // 暂无网络 自定义视图
    lazy var netAlert: NetstatAlertVC = {
        let alert = NetstatAlertVC()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .coverVertical
        alert.tranferReloadBlock { [weak self] result in
            self?.anewReloadData()
        }
        return alert
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NetworkStatusChange"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    // MARK: iOS11设置 使用安全区域
    func adjustsScrollViewInsetNever(scrollView:UIScrollView) {
        if #available(iOS 11.0, *){
            scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    // MARK: 重新加载刷新数据
    @objc func anewReloadData() {
        
    }
    
}

// MARK: 暂无数据/暂无网络
extension BaseVC {
    
    /**
     @abstract 处理暂无数据
     @param scrollView: 容器
     @param reload: 是否有刷新按钮
     @param alert: 提示文字
     @param image: 提示图片
     @param space: 文字顶部距离图片底部的相对偏移
     @param mark: 0表示Size15 #333333, 1表示Size13 #999999
     @param onlyNet: 方法中只处理暂无网络的提示
    */
    func setupEmptyData(scrollView: UIScrollView?,
                        reload: Bool = false,
                        alert: String = "暂无数据",
                        image: UIImage? = nil,
                        space: CGFloat = 0,
                        mark: Int = 0,
                        onlyNet: Bool = false) {
        if !NetstatManager.shared.isNetworkConnect() {
            noNetstatAction(scrollView)
            return
        }
        if onlyNet {
            return
        }
        guard let scr = scrollView else {
            return
        }
        scr.emptyDataSetView { [weak self] view in
            if self?.emptyDataCustomView == nil {
                let customView = Bundle.main.loadNibNamed("EmptyDataCustomView", owner: nil, options: nil)![0] as! EmptyDataCustomView
                customView.setupAlertData(image: image, msg: alert, space: space, mark: mark)
                if reload {
                    customView.tranferParameterClosure { [weak self] result in
                        self?.anewReloadData()
                    }
                }
                self?.emptyDataCustomView = customView
            }
            view.customView(self?.emptyDataCustomView).verticalOffset(-50)
        }
    }
    
    /**
     @abstract 处理暂无网络
     @param haveData: 是否有数据
     @param reload: 是否有刷新按钮
    */
    private func noNetstatAction(_ scrollView: UIScrollView?) {
        var haveData = false
        if let tv = scrollView as? UITableView {
            let cells = tv.visibleCells
            if cells.count > 0 {
                haveData = true
            }
        } else if let co = scrollView as? UICollectionView {
            let cells = co.visibleCells
            if cells.count > 0 {
                haveData = true
            }
        }
        
        if !NetstatManager.shared.isNetworkConnect() && haveData == false {
            NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChange(_:)), name: Notification.Name("NetworkStatusChange"), object: nil)

            self.view.addSubview(netAlert.view)
            self.view.bringSubviewToFront(netAlert.view)
            let top: CGFloat = UIApplication.shared.statusBarFrame.height + 44
            netAlert.view.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(top)
            }
        } else {
            netAlert.view.removeFromSuperview()
        }
    }
    
    /// 网络状态从无网络切换到有网络时,通知刷新
    @objc func networkStatusChange(_ sender: Notification) {
        noNetstatAction(nil)
        if let topVC = ScreenUIManager.topViewController() {
            if topVC.theClassName == self.theClassName {
                anewReloadData()
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NetworkStatusChange"), object: nil)
    }
    
}

extension NSObject {
    // 获取对象的类名
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
