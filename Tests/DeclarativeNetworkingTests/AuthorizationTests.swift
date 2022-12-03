//
//  AuthorizationTests.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import XCTest

import DeclarativeNetworking

final class AuthorizationTests: XCTestCase {

	let templateRequest = URLRequest(url: URL(string: "https://www.apple.com")!)
	
	func testBearerToken()throws {
		let finalRequest:URLRequest = try templateRequest.updating {
			Authorization(.bearer("12345"))
		}
		
		let authHeader:String = try XCTUnwrap(finalRequest.value(forHTTPHeaderField: "Authorization"))
		XCTAssertEqual(authHeader, "Bearer 12345")
	}
	
}
