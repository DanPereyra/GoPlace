//
//  GeneralTextField.swift
//  GoPlace
//
//  Created by user191315 on 10/7/21.
//

import UIKit

@IBDesignable class GeneralTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        self.setupStyleTextField()
    }
    
    private func setupStyleTextField() {
        self.layer.cornerRadius = 10
    }
}

@IBDesignable class GeneralLoginLabel : UILabel {
    
    override func draw(_ rect: CGRect) {
        self.setupStyleTextField()
    }
    
    private func setupStyleTextField() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}

@IBDesignable class GeneralLoginButton : UIButton {
    
    override func draw(_ rect: CGRect) {
        self.setupStyleTextField()
    }
    
    private func setupStyleTextField() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}

@IBDesignable class GeneralRegisterView : UIView {
    
    override func draw(_ rect: CGRect) {
        self.setupStyleTextField()
    }
    
    private func setupStyleTextField() {
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}
