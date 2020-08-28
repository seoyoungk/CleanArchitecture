//
//  BaseViewController.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/27.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {
    lazy var activityIndicatorView: UIActivityIndicatorView = {
       let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .medium
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.view.center
        return activityIndicatorView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.view.addSubview(activityIndicatorView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    func hideKeyboardGestureRecognizer() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }
    
    func showErrorToast(_ content: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .red
        let superview = self.navigationController?.view! ?? self.view!
        superview.makeToast(content, duration: 5.0, position: .top, style: style)
    }

    func showIndicator() {
        self.activityIndicatorView.startAnimating()
    }

    func hideIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
