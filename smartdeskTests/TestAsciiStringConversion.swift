//
//  TestAsciiStringConversion.swift
//  smartdeskTests
//
//  Created by Jing Wei Li on 10/17/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import XCTest
@testable import SwiftMessages

class TestAsciiStringConversion: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAsciiConversion() {
        XCTAssertEqual("ABC", BLEManager.string(ascii: "65\r\n66\r\n67"))
        XCTAssertEqual("scrub", BLEManager.string(ascii: "115\r\n099\r\n114\r\n117\r\n098"))
        XCTAssertEqual("", BLEManager.string(ascii: ""))
    }

}
