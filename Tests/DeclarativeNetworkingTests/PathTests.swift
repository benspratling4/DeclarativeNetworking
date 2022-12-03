//
//  PathTests.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import XCTest
import DeclarativeNetworking

final class PathTests: XCTestCase {

	let rootUrl:URL = URL(string: "https://api.example.com")!
	
	func testNoLeadingSlash()throws {
		let req = try URLRequest(url: rootUrl).updating {
			"api/v1"
		}
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1")
	}
	
	func testMultipleAppending()throws {
		let accountId:String = "12345"
		let req = try URLRequest(url: rootUrl).updating {
			"api"
			"v1"
			"accounts"
			accountId
		}
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1/accounts/12345")
	}
	
}
