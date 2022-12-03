//
//  MethodTests.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import XCTest
import DeclarativeNetworking

final class MethodTests: XCTestCase {
	let rootUrl:URL = URL(string: "https://api.example.com")!
	
	
	func testPost()throws {
		let req = try URLRequest(url: rootUrl).updating {
			HTTPMethod.POST
		}
		XCTAssertEqual(req.httpMethod, "POST")
	}

}
