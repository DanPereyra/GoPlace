//
//  LoginViewController.swift
//  GoPlace
//
//  Created by user191315 on 10/7/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var anchorCenteryViewContent: NSLayoutConstraint!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPaswword: UITextField!
    @IBOutlet weak var cargaActivity : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        //Este se ejecuta una unica vez, es como el oncreate del controller
        super.viewDidLoad()
        self.lblTitle.layer.cornerRadius = 15
        self.lblTitle.layer.masksToBounds = true
    }
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeToOpenKeyboard(_ sender: Any) {
        self.txtUser.becomeFirstResponder()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
    }
    
    @IBAction func btningresar(_ sender: UIButton) {
        
        self.cargaActivity.startAnimating()

        Auth.auth().signIn(withEmail: self.txtUser.text!, password: self.txtPaswword.text!) { (user, error) in
  
            if error == nil {
                  self.cargaActivity.stopAnimating()
                  self.txtUser.text! = ""
                  self.txtPaswword.text! = ""
                  
                  self.performSegue(withIdentifier: "MenuPrincipalViewController", sender: nil)
                  
            }else {
                self.cargaActivity.stopAnimating()
                self.showAlerWithTitle("Error", message: error!.localizedDescription, accept: "Acpetar"){
                }
            }
        }
   }
}

//MARK: - Keyboard events
extension LoginViewController {
    
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
