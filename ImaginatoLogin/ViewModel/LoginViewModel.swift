//
//  LoginViewModel.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import RxCocoa
import RxSwift

class LoginViewModel {
    var user : UserModel?

    // Because we don't have backend api
    // So that we will use below user for checking authorize
    let userEmail = "test@imaginato.com"
    let userPassword = "Imaginato2020"

    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let needLogin = PublishSubject<Void>()

    let isEmailValid: Driver<Bool>
    let isPasswordValid: Driver<Bool>
    let isEmailPasswordValid: Driver<Bool>
    var didLogin = PublishSubject<User>()

    let isLoading: Driver<Bool>
    let error = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    private let indicator = ActivityIndicator()

    init() {
        isLoading = indicator.asDriver()
        isEmailValid = email
            .asDriver()
            .map { $0.isValidEmail() }

        isPasswordValid = password
            .asDriver()
            .map { $0.count >= 6 }

        isEmailPasswordValid = Driver.combineLatest(
            email.asDriver(),
            isEmailValid,
            isPasswordValid
        ) { email, isValidEmail, isValidPassword in
            return !email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
                && isValidEmail
                && isValidPassword
        }

        let loginParams = Driver.combineLatest(
            email.asDriver(),
            password.asDriver()
        ) { (email: $0, password: $1) }

        needLogin
            .withLatestFrom(loginParams)
            .flatMapLatest { [unowned self] (email, password) in
                self.logIn(email: email, password: password)
                    .trackActivity(self.indicator)
                    .catchError { [unowned self] error in
                        self.error.onNext(error)
                        return Observable.empty()
                }
            }
            .bind(to: didLogin)
            .disposed(by: disposeBag)
    }

    func logIn(email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            let queryItems = ["email": email, "password": password]
            WebService.loginUser(queryItems: queryItems) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            self.user = response.object ?? nil
                            print(self.user?.user?.userId ?? "")
                            let reponseUser = User(id: self.user?.user?.userId ?? 0, name: self.user?.user?.userName ?? "", created: self.user?.user?.created_at ?? "")
                            observer.onNext(reponseUser)
                            observer.onCompleted()
                        case .failure:
                            let error = NSError(domain: "org.toprating.authentication", code: 1000,
                                                userInfo: [NSLocalizedDescriptionKey: "Your email or password is incorrect."])
                            observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }.delaySubscription(DispatchTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
    }
    

}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
