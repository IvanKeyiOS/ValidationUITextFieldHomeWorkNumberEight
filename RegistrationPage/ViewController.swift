//
//  ViewController.swift
//  RegistrationPage
//
//  Created by Иван Курганский on 20/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordOneTextField: UITextField!
    @IBOutlet private weak var passwordTwoTextField: UITextField!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var passwordOneLabel: UILabel!
    @IBOutlet private weak var passwordTwoLabel: UILabel!
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    
    let loginValidType: String.ValidTypes = .login
    let passwordOneValidType: String.ValidTypes = .passwordOne
    let passwordTwoValidType: String.ValidTypes = .passwordTwo
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordOneTextField.delegate = self
        passwordTwoTextField.delegate = self
    
        
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let isSuccess = (passwordOneTextField.text == passwordTwoTextField.text)
        resultLabel.textColor = isSuccess ? .green : .red
        resultLabel.text = isSuccess ? "Success" : "Passwords Mismatch"
        loginTextField.resignFirstResponder()
        passwordOneTextField.resignFirstResponder()
        passwordTwoTextField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            return true
        }
        if textField == passwordOneTextField {
            return true
        }
        if textField == passwordTwoTextField && passwordOneTextField.hasText {
            return true
        } else {
            return false }
    }
   
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        textField.text = result
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .systemGreen
        } else {
            label.text = wrongMessage
            label.textColor = .red
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case loginTextField:
            setTextField(textField: loginTextField,
                         label: loginLabel,
                         validType: loginValidType,
                         validMessage: "Login is Valid",
                         wrongMessage: "Only A-Z, a-z characters, min 1 character",
                         string: string,
                         range: range)
            
        case passwordOneTextField:
            setTextField(textField: passwordOneTextField,
                         label: passwordOneLabel,
                         validType: passwordOneValidType,
                         validMessage: "Password is Valid",
                         wrongMessage: "Minimum one of: A-Z, a-z, 0-9, simbol, min 4 character",
                         string: string,
                         range: range)
            
        case passwordTwoTextField:
            setTextField(textField: passwordTwoTextField,
                         label: passwordTwoLabel,
                         validType: passwordTwoValidType,
                         validMessage: "Password is Valid",
                         wrongMessage: "Minimum one of: A-Z, a-z, 0-9, simbol, min 4 character",
                         string: string,
                         range: range)
        default:
            break
        }
        return false
    }
}

extension String {
    enum ValidTypes {
        case login
        case passwordOne
        case passwordTwo
    }
    
    enum Regex: String {
        case login = "[a-zA-Zа-яА-Я]{1,}"
        case passwordOne = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!£#@$%&*?]).{4,}"
        case passwordTwo = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!£#@$%&*?]).{4,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .login: regex = Regex.login.rawValue
        case .passwordOne: regex = Regex.passwordOne.rawValue
        case .passwordTwo: regex = Regex.passwordTwo.rawValue
            
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

