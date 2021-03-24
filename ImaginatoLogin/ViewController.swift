//
//  ViewController.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    let textValidColor = UIColor.green
    let textInvalidColor = UIColor.red

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindUI()
        bindViewModel()
        updateControlStatus()
    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ViewController {

    private func bindUI() {
        viewModel.isLoading
            .drive(onNext: { isLoading in
               // isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)

        viewModel.didLogin
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind { [weak self] user in
                self?.showWelcomeView(forUser: user)
            }
            .disposed(by: disposeBag)

        viewModel.error
            .bind { [unowned self] (error) in
                self.showMessage(title: "Error", message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

        signInButton.rx.tap
            .bind(to: viewModel.needLogin)
            .disposed(by: disposeBag)
    }

    private func updateControlStatus() {

        viewModel.isEmailPasswordValid
            .drive(onNext: { [unowned self] isEnabled in
                self.signInButton.isEnabled = isEnabled
                self.signInButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

        emailTextField.rx
            .controlEvent(UIControl.Event.editingDidEnd)
            .asDriver()
            .withLatestFrom(viewModel.isEmailValid)
            .drive(onNext: { [unowned self] isValid in
                self.emailTextField.textColor = isValid ? self.textValidColor : self.textInvalidColor
            })
            .disposed(by: disposeBag)

        Driver.combineLatest(
            emailTextField.rx.controlEvent(UIControl.Event.editingChanged).asDriver(),
            emailTextField.rx.controlEvent(UIControl.Event.editingDidEnd).asDriver(),
            resultSelector: { _,_ in return () })
            .withLatestFrom(viewModel.isEmailValid)
            .drive(onNext: { [unowned self] isValid in
                self.emailTextField.textColor = isValid ? self.textValidColor : self.textInvalidColor
            })
            .disposed(by: disposeBag)
    }

    private func showWelcomeView(forUser user: User) {
        self.showMessage(message: "Hi!,\(user.userName) Welcome to Imaginato \nYour User Id : \(user.userId) \nCreated On : \(user.created_at ?? "")")
    }

}
