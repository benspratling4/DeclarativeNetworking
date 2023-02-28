//
//  MultiPartFormTests.swift
//  
//
//  Created by Ben Spratling on 2/21/23.
//

import XCTest
import DeclarativeNetworking


final class MultiPartFormTests: XCTestCase {
	
	let rootUrl:URL = URL(string: "https://api.example.com")!

	var fakeImageData:Data = Data([0xEF, 0x01, 0x02, 0x03])
	
	func testFields() throws {
		let req = try URLRequest(url: rootUrl).updating({
			HTTPMethod.POST
			"/api/v1/groups"
			MultiPartForm {
				FormField("display_name", value: "A Group")
				FormAttachment("avatar", body: fakeImageData)
			}
		})
		XCTAssertEqual(req.httpMethod, "POST")
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1/groups")
		let bodyData = try XCTUnwrap(req.httpBody)
		
		//check length of body data to match header field
		let reportedLengthString:String = try XCTUnwrap(req.value(forHTTPHeaderField: "Content-Length"))
		let reportedLength:Int = try XCTUnwrap(Int(reportedLengthString))
		XCTAssertEqual(reportedLength, bodyData.count)
		
		//check for field value
		let fieldData = "Content-Disposition: form-data; name=\"display_name\"\r\n\r\nA Group".data(using: .utf8)!
		XCTAssertNotNil(bodyData.range(of: fieldData))
		
		//look for the binary data
		let binaryData:Data = "Content-Disposition: form-data; name=\"avatar\";\r\nContent-Transfer-Encoding: binary\r\n\r\n".data(using: .utf8)!
			+ Data([0xEF, 0x01, 0x02, 0x03])
			+ "\r\n".data(using: .utf8)!
		
		XCTAssertNotNil(bodyData.range(of: binaryData))
	}
	
	
	func testArrayOfValues() throws {
		let values = ["a", "b", "c"]
		
		let req = try URLRequest(url: rootUrl).updating({
			HTTPMethod.POST
			"/api/v1/groups"
			MultiPartForm {
				values.map({ FormField("tags[]", value: $0) })
				FormAttachment("avatar", body: fakeImageData)
			}
		})
		XCTAssertEqual(req.httpMethod, "POST")
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1/groups")
		let bodyData = try XCTUnwrap(req.httpBody)
		
		//check length of body data to match header field
		let reportedLengthString:String = try XCTUnwrap(req.value(forHTTPHeaderField: "Content-Length"))
		let reportedLength:Int = try XCTUnwrap(Int(reportedLengthString))
		XCTAssertEqual(reportedLength, bodyData.count)
		
		//check for field value
		//find it three times
		let fieldDataA = "Content-Disposition: form-data; name=\"tags[]\"\r\n\r\na".data(using: .utf8)!
		XCTAssertNotNil(bodyData.range(of: fieldDataA))
		
		let fieldDataB = "Content-Disposition: form-data; name=\"tags[]\"\r\n\r\nb".data(using: .utf8)!
		XCTAssertNotNil(bodyData.range(of: fieldDataB))
		
		let fieldDataC = "Content-Disposition: form-data; name=\"tags[]\"\r\n\r\nc".data(using: .utf8)!
		XCTAssertNotNil(bodyData.range(of: fieldDataC))
		
		//look for the binary data
		let binaryData:Data = "Content-Disposition: form-data; name=\"avatar\";\r\nContent-Transfer-Encoding: binary\r\n\r\n".data(using: .utf8)!
			+ Data([0xEF, 0x01, 0x02, 0x03])
			+ "\r\n".data(using: .utf8)!
		
		XCTAssertNotNil(bodyData.range(of: binaryData))
	}
	
	
	
	func testOptional() throws {
		let possible:String? = nil
		let req:URLRequest = try URLRequest(url: rootUrl).updating({
			HTTPMethod.POST
			"/api/v1/groups"
			MultiPartForm {
				FormField("some other", value: "a")
				if let possible {
					FormField("display_name", value: possible)
				}
			}
		})
		XCTAssertEqual(req.httpMethod, "POST")
		let url = try XCTUnwrap(req.url)
		XCTAssertEqual(url.path, "/api/v1/groups")
		let bodyData = try XCTUnwrap(req.httpBody)
		
		//check length of body data to match header field
		let reportedLengthString:String = try XCTUnwrap(req.value(forHTTPHeaderField: "Content-Length"))
		let reportedLength:Int = try XCTUnwrap(Int(reportedLengthString))
		XCTAssertEqual(reportedLength, bodyData.count)
		
		//check for field value
		let fieldData = "Content-Disposition: form-data; name=\"display_name\"\r\n\r\nA Group".data(using: .utf8)!
		XCTAssertNil(bodyData.range(of: fieldData))
		
	}
	
	
	
}

