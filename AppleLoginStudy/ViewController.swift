//
//  ViewController.swift
//  AppleLoginStudy
//
//  Created by Hailey on 2020/02/27.
//  Copyright © 2020 min_e. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var loginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSignInAppleButton()
    }

    private func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(appleIDRequest), for: .touchUpInside)
        
        self.loginStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    private func appleIDRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }
    
    @IBAction func appleLoginAction(_ sender: UIButton) {
        appleIDRequest()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let fullName = appleIDCredential.fullName,
            let email = appleIDCredential.email else { return }
        let userIdentifier = appleIDCredential.user
        
        print(userIdentifier, fullName, email, separator: "\n")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
