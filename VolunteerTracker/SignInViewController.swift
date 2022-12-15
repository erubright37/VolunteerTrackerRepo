//
//  SignInViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/29/22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var user: User!
    var uid = ""
    var signedIn = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var createAcctBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if signedIn == true {
            signInBtn.isHidden = true
            createAcctBtn.isHidden = true
        } else {
            signOutBtn.isHidden = true
        }
        
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        emailTextField.becomeFirstResponder()
    }

    @IBAction func SignInClick(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            // show alert
            return
        }
        
        // Get Auth Instance
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] _result ,_error in
            guard let strongSelf = self else {
                return
            }
            
            guard _error == nil else {
                print(_error?.localizedDescription)
                
                if _error?.localizedDescription == "The password is invalid or the user does not have a password." {
                    // Wrong password Alert
                    let passAlert = UIAlertController(title: "Wrong Password", message: "The password you entered in incorrect. Please try again.", preferredStyle: .alert)
                    passAlert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { _ in
                        
                        strongSelf.passwordTextField.text = ""
                    }))
                    strongSelf.present(passAlert, animated: true)
                    return
                } else if (_error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."){
                    // Show acct create
                    strongSelf.CreateAccount(email: email, password: password)
                    return
                } else {
                    let passAlert = UIAlertController(title: "Sign In Error", message: "There was an error when attempting to sign in. Please try again.", preferredStyle: .alert)
                    passAlert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { _ in
                    }))
                    strongSelf.present(passAlert, animated: true)
                    return
                }
            }
            
            strongSelf.emailTextField.text = ""
            strongSelf.passwordTextField.text = ""
            strongSelf.signedIn = true
            
            strongSelf.signInBtn.isHidden = true
            strongSelf.createAcctBtn.isHidden = true
            strongSelf.signOutBtn.isHidden = false
            
            strongSelf.user = FirebaseAuth.Auth.auth().currentUser
            strongSelf.uid = strongSelf.user!.uid
            
            strongSelf.backBtn.sendActions(for: .touchUpInside)
        })
        
    }
    
    func CreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] _result ,_error in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard _error == nil else {
                        print("Account Creation Failed")
                        return
                    }
                
                strongSelf.emailTextField.text = ""
                strongSelf.passwordTextField.text = ""
                strongSelf.signedIn = true
                
                strongSelf.signInBtn.isHidden = true
                strongSelf.createAcctBtn.isHidden = true
                strongSelf.signOutBtn.isHidden = false
                
                strongSelf.backBtn.sendActions(for: .touchUpInside)
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
           self.emailTextField.text = ""
           self.passwordTextField.text = ""
        }))
        present(alert, animated: true)
    }
    
    @IBAction func CreateAccountClick(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            // show alert
            return
        }
        
        // Get Auth Instance
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] _result ,_error in
            guard let strongSelf = self else {
                return
            }
            
            guard _error == nil else {
                // Show acct create
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] _result ,_error in
                        guard let strongSelf = self else {
                            return
                        }
                        
                        guard _error == nil else {
                            print("Account Creation Failed")
                            return
                        }
                    
                    strongSelf.emailTextField.text = ""
                    strongSelf.passwordTextField.text = ""
                    
                    strongSelf.signedIn = true
                    strongSelf.signInBtn.isHidden = true
                    strongSelf.createAcctBtn.isHidden = true
                    strongSelf.signOutBtn.isHidden = false
                    
                    strongSelf.backBtn.sendActions(for: .touchUpInside)
                })
                return
            }
            
            strongSelf.emailTextField.text = ""
            strongSelf.passwordTextField.text = ""

            strongSelf.signedIn = true
            strongSelf.user = FirebaseAuth.Auth.auth().currentUser
            strongSelf.uid = strongSelf.user!.uid
            
            strongSelf.backBtn.sendActions(for: .touchUpInside)
        })
    }
    
    
    @IBAction func SignOutClick(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            signedIn = false
            
            signInBtn.isHidden = false
            createAcctBtn.isHidden = false
            signOutBtn.isHidden = true
            
            uid = ""
        }
        catch {
            print("error occurred")
        }
    }

}
