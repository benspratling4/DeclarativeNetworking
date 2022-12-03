//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


public struct IdempotencyKey : URLRequestHeader {
	
	public init(key:String) {
		self.key = key
	}
	
	public var key:String
	
	
	//MARK: - URLRequestHeader
	
	public var name:String { "Idempotency-Key" }
	public var value:String { key }
}
