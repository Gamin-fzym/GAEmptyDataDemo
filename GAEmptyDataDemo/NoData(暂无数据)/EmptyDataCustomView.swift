//
//  EmptyDataCustomView.swift
//  JXF
//
//  Created by MaciOS on 2021/10/16.
//  Copyright © 2021 jiraun. All rights reserved.
//

import Foundation
import UIKit

class EmptyDataCustomView: UIView {
    
    @IBOutlet weak var alertIV: UIImageView!
    @IBOutlet weak var ivHConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertLab: UILabel!
    @IBOutlet weak var reloadBut: UIButton!
    @IBOutlet weak var devConstraint: NSLayoutConstraint!
    private var reloadBlock:((String) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func tapRloadAction(_ sender: Any) {
        if self.reloadBlock != nil {
            self.reloadBlock!("刷新了")
        }
    }
    
    public func tranferParameterClosure(callbackEnclosure:@escaping ((String) -> Void)) {
        self.reloadBlock = callbackEnclosure
        reloadBut.isHidden = false
    }
    
    func setupAlertData(image:UIImage?, msg:String, space:CGFloat, mark:Int) {
        alertIV.image = image
        alertLab.text = msg
        devConstraint.constant = space
        if mark == 1 {
            alertLab.textColor = .darkGray
            alertLab.font = UIFont.systemFont(ofSize: 13)
        } else {
            alertLab.textColor = .black
            alertLab.font = UIFont.boldSystemFont(ofSize: 15)
        }
        var viewHeight: CGFloat = 100
        if let ig = image {
            let igSize = ig.size // 默认都是传的二倍图
            let newIgSize = CGSize(width: igSize.width/2.0, height: igSize.height/2.0)
            ivHConstraint.constant = newIgSize.height
            viewHeight = viewHeight+newIgSize.height
        } else {
            ivHConstraint.constant = 0.0
        }
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: viewHeight)
    }
    
}
