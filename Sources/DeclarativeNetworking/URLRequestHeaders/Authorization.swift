//
//  Authorization.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation



public struct Authorization : URLRequestHeader {
	
	public init(_ scheme:AuthorizationScheme) {
		self.scheme = scheme
	}
	
	public var scheme:AuthorizationScheme
	
	
	//MARK: - URLRequestHeader
	
	public var name:String { "Authorization" }
	public var value:String { scheme.name + " " + scheme.authorizationParameters }
}


extension Authorization {
	
	public init(_ predefinedScheme:PredefinedAuthorizationSchemeWrapper) {
		self.scheme = predefinedScheme.scheme
	}
	
}


public enum PredefinedAuthorizationSchemeWrapper {
	case bearer(_ token:String)
	case basic(username:String, password:String)
	
	var scheme:AuthorizationScheme {
		switch self {
		case .bearer(let token):
			return BearerAuthorizationScheme(token)
			
		case .basic(username: let username, password: let password):
			return BasicAuthorizationScheme(username: username, password: password)
		}
	}
}


public protocol AuthorizationScheme {
	
	var name:String { get }
	var authorizationParameters:String { get }
	
}


public struct BearerAuthorizationScheme : AuthorizationScheme {
	
	public init(_ token:String) {
		self.token = token
	}
	
	public var token:String
	
	public var name:String { "Bearer" }
	public var authorizationParameters:String { token }
	
}


public struct BasicAuthorizationScheme : AuthorizationScheme {
	
	public init(username:String, password:String) {
		self.username = username
		self.password = password
	}
	
	public var username:String
	public var password:String
	
	public var name:String { "Basic" }
	
	public var authorizationParameters:String {
		(username + ":" + password)
			.data(using: .utf8)!
			.base64EncodedString()
	}
	
}
