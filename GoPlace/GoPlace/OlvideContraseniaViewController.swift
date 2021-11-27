//
//  OlvideContraseniaViewController.swift
//  GoPlace
//
//  Created by user191315 on 10/7/21.
//

import UIKit
import FirebaseAuth

class OlvideContraseniaViewController: UIViewController {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var anchorCenteryViewContent: NSLayoutConstraint!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var cargarActivity : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
    }
    
    @IBAction func clickBtnRegresar(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirmarCambio(_ sender: Any) {
        

    Auth.auth().sendPasswordReset(withEmail: self.txtCorreo.text!) { (resultado) in
        
        if resultado == nil{
            self.showAlerWithTitle("Se te envio un 📩", message: "Revisa tu bandeja", accept: "Gracias"){
                self.navigationController?.popViewController(animated: true)
            }            
        }else{
            self.showAlerWithTitle("Error", message: resultado!.localizedDescription, accept: "Acpetar"){
            }
        }
    }
}
}


//MARK: - Keyboard events
extension OlvideContraseniaViewController {
    
    private func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let viewContentFinalPosY = self.viewContent.frame.origin.y + self.viewContent.frame.size.height
        
        if keyboardFrame.origin.y < viewContentFinalPosY {
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
                
                let delta = keyboardFrame.origin.y - viewContentFinalPosY
                self.anchorCenteryViewContent.constant = delta
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorCenteryViewContent.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
