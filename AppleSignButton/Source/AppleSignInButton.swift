//
//  AppleSignInManager.swift
//  SocialLoginDemo
//
//  Created by Sandeep Kumar on 26/04/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import AuthenticationServices

@IBDesignable class AppleSignInButton: UIView {
    
    private var appleBtn = ASAuthorizationAppleIDButton()
    
    public var didCompletedSignIn: ((_ user: AppleUser) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    @IBInspectable private var cornerRadius: CGFloat = 0.0 {
        didSet {
            appleBtn.cornerRadius = cornerRadius
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable private var style: Int = ASAuthorizationAppleIDButton.Style.black.rawValue {
        didSet {
            let buttonType = ASAuthorizationAppleIDButton.ButtonType(rawValue: type) ?? ASAuthorizationAppleIDButton.ButtonType.default
            let buttonStyle = ASAuthorizationAppleIDButton.Style(rawValue: style) ?? ASAuthorizationAppleIDButton.Style.black
            appleBtn = ASAuthorizationAppleIDButton.init(type: buttonType, style: buttonStyle)
            setUpView()
        }
    }
    
    @IBInspectable private var type: Int = ASAuthorizationAppleIDButton.ButtonType.default.rawValue {
        didSet {
            let buttonType = ASAuthorizationAppleIDButton.ButtonType(rawValue: type) ?? ASAuthorizationAppleIDButton.ButtonType.default
            let buttonStyle = ASAuthorizationAppleIDButton.Style(rawValue: style) ?? ASAuthorizationAppleIDButton.Style.black
            appleBtn = ASAuthorizationAppleIDButton.init(type: buttonType, style: buttonStyle)
            setUpView()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    private func setUpView() {
        appleBtn.tag = 420
        appleBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appleBtn)
        NSLayoutConstraint.activate([
            appleBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            appleBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            appleBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            appleBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        appleBtn.addTarget(self, action: #selector(didTapASAuthorizationButton), for: .touchUpInside)
    }
    
    @objc private func didTapASAuthorizationButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController.init(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}

//MARK:- Presentation Context Provider Delegate
extension AppleSignInButton: ASAuthorizationControllerPresentationContextProviding {
    internal func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
}

//MARK:- ASAuthorizationController Delegate
extension AppleSignInButton: ASAuthorizationControllerDelegate {
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alertBox = UIAlertController.init(title: AppSignInStrings.APPLE_SIGN_IN_FAILED_TITLE.localized, message: error.localizedDescription, preferredStyle: .alert)
        alertBox.addAction(UIAlertAction.init(title: AppSignInStrings.APPLE_SIGN_IN_OK.localized, style: .default, handler: nil))
        self.window?.rootViewController?.present(alertBox, animated: true, completion: nil)
    }
    
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            didCompletedSignIn?(AppleUser(credentials.user, credentials.fullName?.givenName, credentials.fullName?.familyName, credentials.email, nil))
        case let passwordCredential as ASPasswordCredential:
            didCompletedSignIn?(AppleUser(passwordCredential.user, nil, nil, nil, passwordCredential.password))
        default:
            break
        }
        
    }
}


private enum AppSignInStrings: String {
    case APPLE_SIGN_IN_FAILED_TITLE = "SIGN_IN_FAILED_TITLE"
    case APPLE_SIGN_IN_OK = "APPLE_SIGN_IN_OK"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

public class AppleUser {
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    
    init(_ _id: String?, _ _firstName: String?, _ _lastName: String?, _ _email: String?, _ _password: String?) {
        id = _id
        firstName = _firstName
        lastName = _lastName
        email = _email
        password = _password
    }
}
