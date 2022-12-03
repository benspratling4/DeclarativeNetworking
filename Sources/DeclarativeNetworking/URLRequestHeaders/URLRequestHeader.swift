//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


public protocol URLRequestHeader : URLRequestUpdating {
	var name:String { get }
	var value:String { get }
}


extension URLRequestHeader {
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.addValue(value, forHTTPHeaderField: name)
		return newRequest
	}
}
