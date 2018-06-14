//
//  UITest.swift
//  UITest
//
//  Created by 배지호 on 2018. 6. 12..
//

import XCTest

class UITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
      let app = XCUIApplication()
      setupSnapshot(app)
//      XCUIApplication().launch()
      app.launch()
      

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
  func testSnapShot(){
    let app = XCUIApplication()
    let tabBarsQuery = app.tabBars
    snapshot("0_Launch")
    var button = app.buttons.element(matching: .button, identifier: "test")
    
    button.tap()
    snapshot("1_Main")
    
    
  }
    
}
