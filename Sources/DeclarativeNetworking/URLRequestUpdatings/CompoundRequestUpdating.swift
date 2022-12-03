//
//  CompoundRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation

public struct CompoundRequestUpdating : URLRequestUpdating {
	
	public init(actions:[URLRequestUpdating]) {
		self.actions = actions
	}
	
	public var actions:[URLRequestUpdating]
	
	
	//MARK: - URLRequestUpdating
	
	public var allURLRequestUpdating:[URLRequestUpdating] {
		return actions
	}
	
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		for item in actions {
			newRequest = try item.updatingUrlRequest(newRequest)
		}
		return newRequest
	}
	
}
