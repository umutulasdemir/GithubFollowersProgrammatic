//
//  UIViewController+Ext.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 18.05.2024.
//

import UIKit

extension UIViewController{
    func presentCustomPopupOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async{
            let customPopup = CustomPopupVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            customPopup.modalPresentationStyle = .overFullScreen
            customPopup.modalTransitionStyle = .crossDissolve
            self.present(customPopup, animated: true)
        }
    }
}
