//
//  QueryTests.swift
//  
//
//  Created by Ben Spratling on 2/22/23.
//

import XCTest
import DeclarativeNetworking

final class QueryTests: XCTestCase {
	let rootUrl:URL = URL(string: "https://api.example.com")!
	
	func testOneQueryItem() throws {
		//TODO: write me
	}
	
	func testTwoQueryItems() throws {
		//TODO: write me
	}
	
	func testQueryArray() throws {
		let values = ["a", "b", "c"]
		let req = try URLRequest(url: rootUrl).updating {
			"/api/v1/stuffs"
			values.map({ URLQueryItem(name: "items[]", value: $0) })
		}
		
		let url = try XCTUnwrap(req.url)
		let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try XCTUnwrap(components.queryItems)
		
		XCTAssertEqual(items.count, 3)
		
		XCTAssertEqual(items[0].name, "items[]")
		XCTAssertEqual(items[0].value, "a")
		
		XCTAssertEqual(items[1].name, "items[]")
		XCTAssertEqual(items[1].value, "b")
		
		XCTAssertEqual(items[2].name, "items[]")
		XCTAssertEqual(items[2].value, "c")
	}
	
	
	func testOptionalQueries()throws {
		
		func reqGenerator(sinceId:String?)throws->URLRequest {
			return try URLRequest(url: rootUrl).updating {
				HTTPMethod.POST
				"api/v1/samples"
				Authorization(.bearer("12345"))
				CacheControl([.noCache, .noStore])
				if let lowId = sinceId {
					URLQueryItem(name: "sinceId", value: lowId)
				}
				JSON(SampleBody(content: "value"))
			}
		}
		
		let withSinceId = try reqGenerator(sinceId: "123")
		XCTAssertEqual(withSinceId.httpMethod, "POST")
		let withSinceIdUrl = try XCTUnwrap(withSinceId.url)
		XCTAssertEqual(withSinceIdUrl.path, "/api/v1/samples")
		XCTAssertEqual(withSinceIdUrl.query, "sinceId=123")
		
		
		let withoutSinceId = try reqGenerator(sinceId: nil)
		let withoutSinceIdUrl = try XCTUnwrap(withoutSinceId.url)
		XCTAssertNil(withoutSinceIdUrl.query)
		
	}
	
	struct SampleBody : Encodable {
		var content:String
	}

}
