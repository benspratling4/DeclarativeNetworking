//
//  TypedDataURLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation

public struct TypedDataURLRequestUpdating : URLRequestUpdating {
	
	public init(_ tuple:(Data, String)) {
		self.data = tuple.0
		self.mimeType = tuple.1
	}
	
	public init(data:Data, mimeType:String) {
		self.data = data
		self.mimeType = mimeType
	}
	
	public var data:Data
	public var mimeType:String
	
	
	//MARK: - URLRequestUpdating
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.httpBody = data
		newRequest.addValue(mimeType, forHTTPHeaderField: "Content-Type")
		return newRequest
	}
}
