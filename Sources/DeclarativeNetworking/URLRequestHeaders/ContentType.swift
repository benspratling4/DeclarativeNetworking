//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


public struct ContentType : URLRequestHeader {
	
	public init(_ type:String) {
		self.type = type
	}
	
	public var type:String
	
	//MARK: - URLRequestHeader
	
	public var name: String {
		"Content-Type"
	}
	
	public var value: String {
		type
	}
	
}


#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers
 
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 9.0, macCatalyst 13.0, *)
extension ContentType {
	
	public init?(_ utType:UTType) {
		guard let type = utType.preferredMIMEType else { return nil }
		self.type = type
	}
}

#endif
