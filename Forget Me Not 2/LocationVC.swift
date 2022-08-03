//
//  LocationVC.swift
//  Forget Me Not 2
//
//  Created by CoopStudent on 8/2/22.
//

import UIKit

class LocationVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var altField: UITextField!
    @IBOutlet var longField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    public var completionL: ((String, String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        altField.delegate = self
        longField.delegate = self
        nameField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty,
            let altText = altField.text, !altText.isEmpty,
           let longText = longField.text, !longText.isEmpty,
           let lName = nameField.text, !lName.isEmpty {
            //let altInt = Int(altText) ?? 0
            //let longInt = Int(longText) ?? 0
            completionL?(titleText, bodyText, lName)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


