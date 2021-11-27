//
//  MenuPrincipalViewController.swift
//  GoPlace
//
//  Created by user191315 on 10/7/21.
//

import UIKit

class MenuPrincipalViewController: UIViewController {
    
    @IBAction func clickBtnRegresar(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
