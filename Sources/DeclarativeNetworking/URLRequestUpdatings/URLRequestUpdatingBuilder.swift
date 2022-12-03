//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation




@resultBuilder public struct URLRequestUpdatingBuilder {
	
	public static func buildOptional(_ component: URLRequestUpdating?) -> URLRequestUpdating {
		if let existing = component {
			return existing
		}
		return NoOpURLRequestUpdating()
	}
	
	public static func buildEither(first component: URLRequestUpdating) -> URLRequestUpdating {
		return component
	}
	
	public static func buildEither(second component: URLRequestUpdating) -> URLRequestUpdating {
		return component
	}
	
	public static func buildExpression(_ expression: (Data, String)) -> URLRequestUpdating {
		return TypedDataURLRequestUpdating(expression)
	}
	
	public static func buildExpression(_ expression: URLRequestUpdating) -> URLRequestUpdating {
		return expression
	}
	
	public static func buildExpression<BodyType:Encodable>(_ expression: BodyType) -> URLRequestUpdating {
		return BodyEncodingUrlUpdating(body: expression, encoder: JSONEncoder())
	}
	
	public static func buildBlock(_ components: URLRequestUpdating...) -> URLRequestUpdating {
		return CompoundRequestUpdating(actions: components.flatMap({ $0.allURLRequestUpdating }))
	}
	
}
