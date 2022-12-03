//
//  HeaderTests.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import XCTest
import DeclarativeNetworking

final class IntegrationTests: XCTestCase {
	let rootUrl:URL = URL(string: "https://api.example.com")!
	
	struct SampleBody : Encodable {
		var content:String
	}
	
	func testSeveral()throws {
		let req = try URLRequest(url: rootUrl).updating {
			HTTPMethod.POST
			"api/v1/samples"
			Authorization(.bearer("12345"))
			CacheControl([.noCache, .noStore])
			JSON(SampleBody(content: "value"))
		}
		XCTAssertEqual(req.httpMethod, "POST")
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1/samples")
		let authHeader:String = try XCTUnwrap(req.value(forHTTPHeaderField: "Authorization"))
		XCTAssertEqual(authHeader, "Bearer 12345")
		
		let cacheHeader:String = try XCTUnwrap(req.value(forHTTPHeaderField: "Cache-Control"))
		XCTAssertEqual(cacheHeader, "no-cache, no-store")
		
		let body = try XCTUnwrap(req.httpBody)
		XCTAssertEqual(body, "{\"content\":\"value\"}".data(using: .utf8)!)
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
	

}
