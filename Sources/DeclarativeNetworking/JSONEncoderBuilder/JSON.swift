//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation



/**
 If your json protocol uses the default settings on a `JSONEncoder`, you can use this directly on any `Encodable` type:
 
 ```swift
 let someValue:Encodable = ...
 let request = templateRequest.updating {
	...
	JSON(someValue)
	...
 }
 ```
 */
public func JSON<Body:Encodable>(_ body:Body)->BodyEncodingUrlUpdating<JSONEncoder> {
	JSON(body, JSONEncoder())
}

/**
 If you have your own pre-configured `JSONEncoder`, you can use this directly on any `Encodable` type:
 
 ```swift
 let someValue:Encodable = ...
 let encoder:JSONEncoder = ...
 let request = templateRequest.updating {
	...
	JSON(someValue, encoder)
	...
 }
 ```
 */
public func JSON<Body:Encodable>(_ body:Body, _ encoder:JSONEncoder)->BodyEncodingUrlUpdating<JSONEncoder> {
	BodyEncodingUrlUpdating(body: body, encoder: encoder)
}

/**
 Here's the fun: if you want to be able to construct a `JSONEncoder` merely from specific settings:
 ```swift
 let someValue:Encodable = ...
 let request = templateRequest.updating {
	...
	JSON(someValue) {
		JSONEncoder.DateEncodingStrategy.millisecondsSince1970
		JSONEncoder.DataEncodingStrategy.base64
		JSONEncoder.OutputFormatting([.sortedKeys, .withoutEscapingSlashes])
	}
	...
 }
 ```
 
 */

public func JSON<Body:Encodable>(_ body:Body, @JSONEncoderBuilder buildEncoder:()->JSONEncoder)->BodyEncodingUrlUpdating<JSONEncoder> {
	JSON(body, buildEncoder())
}



extension JSONEncoder : MimeTypingTopLevelEncoder {
	public var encodingMimeType:String { "application/json" }
}
