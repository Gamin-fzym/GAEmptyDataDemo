//
//  NetstatAlertVC.swift
//  juzhe
//
//  Created by JROS03 on 2020/7/28.
//  Copyright © 2020 air. All rights reserved.
//

import UIKit

class NetstatAlertVC: BaseVC {

    @IBOutlet weak var returnBut: UIButton!
    @IBOutlet weak var sureBut: UIButton!
    private var reloadBlock:((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func tranferReloadBlock(callback:@escaping ((String) -> Void)) {
        self.reloadBlock = callback
    }
    
    /// 确认
    @IBAction func confirmBtnClick(_ sender: Any) {
        if self.reloadBlock != nil {
            self.reloadBlock!("刷新了")
        }
    }
    
    @IBAction func returnAction(_ sender: Any) {
        if self.reloadBlock != nil {
            self.reloadBlock!("刷新了")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
}
