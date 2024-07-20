//
//  File.swift
//  
//
//  Created by Ben Spratling on 7/20/24.
//

import XCTest
import DeclarativeNetworking



final class NetworkAccessTests : XCTestCase {
	
	let rootUrl:URL = URL(string: "https://api.example.com")!
	
	func testConstrainedAccess()throws {
		let req = try URLRequest(url: rootUrl).updating {
			AllowsConstrainedNetworkAccess(false)
		}
		XCTAssertEqual(req.allowsConstrainedNetworkAccess, false)
		XCTAssertEqual(req.allowsExpensiveNetworkAccess, true)
	}
	
	func testExpensiveAccess()throws {
		let req = try URLRequest(url: rootUrl).updating {
			AllowsExpensiveNetworkAccess(false)
		}
		XCTAssertEqual(req.allowsConstrainedNetworkAccess, true)
		XCTAssertEqual(req.allowsExpensiveNetworkAccess, false)
	}
	
}

