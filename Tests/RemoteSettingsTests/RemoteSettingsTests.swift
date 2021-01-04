import XCTest
import RemoteSettings

final class RemoteSettingsTests: XCTestCase {
    static var settings: RemoteSettings!
    
    override class func setUp() {
        guard let settings = try? RemoteSettings(settingsJsonURLString: "https://api.github.com/users/github") else {
            XCTFail("Failed to create RemoteSettings object")
            return
        }
        
        self.settings = settings
    }
    
    override func setUp() {
        let settings = RemoteSettingsTests.settings!
        
        let result = expectation(description: "Request result")
        settings.refreshSettings(completion: { (error) in
            if let error = error {
                XCTFail("Failed to fetch data: \(error)")
            }
            
            result.fulfill()
        })
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectations: \(error)")
            }
        }
    }
    
    func testReadString() {
        let settings = RemoteSettingsTests.settings!
        
        let value: String? = try? settings.getValue(forKey: "login")
        XCTAssertEqual(value, "github")
        
        let objcValue = settings.getString(forKey: "login")
        XCTAssertEqual(objcValue.value as! String, "github")
    }
    
    func testReadNull() {
        let settings = RemoteSettingsTests.settings!
        
        let value: String? = try? settings.getValue(forKey: "wrong_key")
        XCTAssertEqual(value, nil)
        
        let objcValue = settings.getString(forKey: "wrong_key")
        XCTAssertEqual(objcValue.success, false)
    }
    
    func testReadInt() {
        let settings = RemoteSettingsTests.settings!
        
        let value: Int? = try? settings.getValue(forKey: "id")
        XCTAssertEqual(value, 9919)
        
        let objcValue = settings.getInt(forKey: "id")
        XCTAssertEqual(objcValue.value as! Int, 9919)
    }
    
    func testReadDouble() {
        let settings = RemoteSettingsTests.settings!
        
        let value: Double? = try? settings.getValue(forKey: "id")
        XCTAssertEqual(value, 9919.0)
        
        let objcValue = settings.getDouble(forKey: "id")
        XCTAssertEqual(objcValue.value as! Double, 9919.0)
    }
    
//    // Don't remove, it's working, just needs correct credentials to run
//    func testBasicAuth() {
//        /// Enter a valid endpoint and credentials to test against
//        let endpointWithAuth = ""
//        let basicAuth = BasicAuthCredentials(login: "", password: "")
//
//        if endpointWithAuth.isEmpty { return }
//
//        guard let settingsWithAuth = try? RemoteSettings(settingsJsonURLString: endpointWithAuth, basicAuth: basicAuth) else {
//            XCTFail("Failed to create RemoteSettings object")
//            return
//        }
//
//        let result = expectation(description: "Request result")
//        settingsWithAuth.refreshSettings(completion: { (error) in
//            if let error = error {
//                XCTFail("Failed to fetch data: \(error)")
//            }
//
//            XCTAssertNil(error)
//
//            result.fulfill()
//        })
//
//        waitForExpectations(timeout: 5) { (error) in
//            if let error = error {
//                XCTFail("waitForExpectations: \(error)")
//            }
//        }
//    }
}
