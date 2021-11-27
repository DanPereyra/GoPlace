//
//  RegistroViewController.swift
//  GoPlace
//
//  Created by user191315 on 10/7/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistroViewController: UIViewController {

    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var anchorBottomScroll: NSLayoutConstraint!
    @IBOutlet weak var cargarActivity : UIActivityIndicatorView!
    
    var publiacacionRef : DatabaseReference!
    
    @IBAction private func tapToCloseKeyboard(_ sender: Any) {
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

    @IBAction func btnRegistrar(_ sender: UIButton) {
        
        if self.txtCorreo.text == ""{
            self.showAlerWithTitle("Error", message: "Ingrese su Correo", accept: "Ok"){
            }
            return
        }

        if self.txtNombre.text == ""{
            self.showAlerWithTitle("Error", message: "Ingrese su Nombre", accept: "Ok"){
            }
            return
        }

        if self.txtApellido.text == ""{
            self.showAlerWithTitle("Error", message: "Ingrese su Apellido", accept: "Ok"){
            }
            return
        }

        if self.txtNumero.text == ""{
            self.showAlerWithTitle("Error", message: "Ingrese su Numero", accept: "Ok"){
            }
            return
        }

        if self.txtContraseña.text?.count ?? 0 <= 4{
            self.showAlerWithTitle("Error", message: "Ingrese una constraseña correcta", accept: "Ok"){
            }
            return
        }
        
        self.cargarActivity.startAnimating()
        
        Auth.auth().createUser(withEmail: self.txtCorreo.text!, password: self.txtContraseña.text!) { (resultado, error) in

            if resultado != nil{

                self.publiacacionRef = Database.database().reference().child("Usuarios").childByAutoId()

                let estrucutura : [String : Any] = ["nombre" : self.txtNombre.text!,
                                                    "apellido" : self.txtApellido.text! as String,
                                                    "correo" : self.txtCorreo.text! as String,
                                                    "numero" : self.txtNumero.text! as String]
                self.cargarActivity.stopAnimating()
                self.publiacacionRef.setValue(estrucutura)
           
                self.showAlerWithTitle("Felicidades", message: "Ya formas parte de GoPlace", accept: "Gracias"){
                    self.txtNombre.text = ""
                    self.txtApellido.text = ""
                    self.txtContraseña.text = ""
                    self.txtCorreo.text = ""
                    self.txtNumero.text = ""
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.cargarActivity.stopAnimating()
                self.showAlerWithTitle("Vaya!", message: error!.localizedDescription, accept: "OK"){
                }
            }
        }
    }
    
}

extension RegistroViewController {
    
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
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension UIViewController {
    
    func showAlerWithTitle(_ title: String, message: String, accept: String,_ handler : @escaping Handler) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let acceptButton = UIAlertAction(title: accept, style: .default) { action in
            handler()
        }
        
        alertController.addAction(acceptButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    typealias Handler = () -> Void
}


