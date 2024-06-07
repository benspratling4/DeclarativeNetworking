//
//  SubDomainTests.swift
//
//
//  Created by Ben Spratling on 6/7/24.
//

import XCTest
@testable import DeclarativeNetworking



final class SubDomainTests: XCTestCase {
	let rootUrl:URL = URL(string: "https://example.com")!
	
	func testMinUrl() {
		let oneSubDomain = MinUrl(rootUrl)
			.prependingSubDomain("api")
			.url
		XCTAssertEqual(oneSubDomain, URL(string:"https://api.example.com"))
		
		let twoSubDomains = MinUrl(rootUrl)
			.prependingSubDomain("api")
			.prependingSubDomain("v2")
			.url
		XCTAssertEqual(twoSubDomains, URL(string:"https://v2.api.example.com"))
	}
	
	func testOneSubDomain()throws {
		let req = try URLRequest(url: rootUrl).updating {
			SubDomain("api")
		}
		let url = try XCTUnwrap(req.url)
		let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
		
		XCTAssertEqual(components.host, "api.example.com")
	}
	
	func testTwoSubDomains()throws {
		let req = try URLRequest(url: rootUrl).updating {
			SubDomain("api")
			SubDomain("v2")
		}
		let url = try XCTUnwrap(req.url)
		let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
		
		XCTAssertEqual(components.host, "v2.api.example.com")
	}
	
	func testConcatenatedSubDomains()throws {
		let req = try URLRequest(url: rootUrl).updating {
			SubDomain("v2.api")
		}
		let url = try XCTUnwrap(req.url)
		let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
		
		XCTAssertEqual(components.host, "v2.api.example.com")
	}

}
