import XCTest
@testable import Exam_English

class LoginViewControllerTests: XCTestCase {

    var loginViewController: LoginViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        loginViewController.loadViewIfNeeded()

        // Injecting mock dependencies
        loginViewController.customView = CustomView()
        loginViewController.apiService = MockAPIService()
    }

    override func tearDown() {
        loginViewController = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertTrue(loginViewController.tempHideShow)
        XCTAssertEqual(loginViewController.defaultPasswordWarning, "")
        XCTAssertTrue(loginViewController.warningAccountLabel.isHidden)
        XCTAssertTrue(loginViewController.warningPasswordLabel.isHidden)
    }

    func testHideShowPassword() {
        let button = UIButton()
        loginViewController.hideShowPass(button)

        XCTAssertFalse(loginViewController.tempHideShow)
        XCTAssertFalse(loginViewController.passwordTextField.isSecureTextEntry)

        loginViewController.hideShowPass(button)

        XCTAssertTrue(loginViewController.tempHideShow)
        XCTAssertTrue(loginViewController.passwordTextField.isSecureTextEntry)
    }

    func testLoginButtonTappedWithEmptyFields() {
        loginViewController.accountTextField.text = ""
        loginViewController.passwordTextField.text = ""

        let button = UIButton()
        loginViewController.loginButtonTapped(button)

        XCTAssertFalse(loginViewController.warningAccountLabel.isHidden)
        XCTAssertFalse(loginViewController.warningPasswordLabel.isHidden)
    }

    class MockAPIService: APIServiceProtocol {
        func postLogin(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
            let jsonString = "{\"result\": {\"token\": \"dummyToken\"}}"
            let data = jsonString.data(using: .utf8)!
            completion(.success(data))
        }
    }

    func testLoginSuccess() {
        let mockAPIService = MockAPIService()
        loginViewController.apiService = mockAPIService

        loginViewController.accountTextField.text = "validUsername"
        loginViewController.passwordTextField.text = "validPassword"

        let button = UIButton()
        loginViewController.loginButtonTapped(button)

        XCTAssertEqual(UserDefaults.standard.string(forKey: "accessToken"), "dummyToken")
    }

    class MockAPIServiceFailure: APIServiceProtocol {
        func postLogin(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
            completion(.failure(NSError(domain: "test", code: 1, userInfo: nil)))
        }
    }

    func testLoginFailure() {
        let mockAPIService = MockAPIServiceFailure()
        loginViewController.apiService = mockAPIService

        loginViewController.accountTextField.text = "invalidUsername"
        loginViewController.passwordTextField.text = "invalidPassword"

        let button = UIButton()
        loginViewController.loginButtonTapped(button)

        XCTAssertFalse(loginViewController.warningPasswordLabel.isHidden)
        XCTAssertEqual(loginViewController.warningPasswordLabel.text, Constants.MessageLogin.loginFailed)
    }
}
