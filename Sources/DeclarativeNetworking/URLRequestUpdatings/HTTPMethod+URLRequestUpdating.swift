//
//  HTTPMethod+URLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation

extension HTTPMethod : URLRequestUpdating {
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.httpMethod = rawValue
		return newRequest
	}
}
