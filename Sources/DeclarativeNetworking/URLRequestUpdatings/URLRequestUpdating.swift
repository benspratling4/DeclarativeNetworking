//
//  URLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation



public protocol URLRequestUpdating {
	func updatingUrlRequest(_ request:URLRequest)throws->URLRequest
}

extension URLRequestUpdating {
	public var allURLRequestUpdating:[URLRequestUpdating] {
		return [self]
	}
}
