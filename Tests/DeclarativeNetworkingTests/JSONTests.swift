//
//  JSONTests.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import XCTest
import DeclarativeNetworking

final class JSONTests: XCTestCase {

	struct SampleBody : Encodable {
		var date:Date?
		var data:Data?
	}
	
	let testDate:Date = Date(timeIntervalSince1970: 1000000)
	
	func testDateStrategy()throws {
		let testBody = SampleBody(date:testDate)
		let positiveBodyResult = "{\"date\":1000000000}".data(using: .utf8)!
		
		//validate test - ensure the encoding we'll later set is not the default encoding
		let defaultEncoder = JSONEncoder()
		//date encoding stragy can't conform to encodable because one case is a block
		let validationValue = JSON(testBody, defaultEncoder)
		let validationBody = try validationValue.encoder.encode(testBody)
		XCTAssertNotEqual(validationBody, positiveBodyResult, "validating that the json encoder didn't come with our target date enoding stragegy by dfault failed")
		
		//perform the test
		let testValue = JSON(SampleBody(date:testDate)) {
			JSONEncoder.DateEncodingStrategy.millisecondsSince1970
		}
		let body = try testValue.encoder.encode(testBody)
		XCTAssertEqual(body, positiveBodyResult, "updating json encoder with date encoding strategy failed")
	}

}
