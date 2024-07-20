//
//  URLRequest+NetworkAccess.swift
//
//
//  Created by Ben Spratling on 7/20/24.
//

import Foundation



public struct AllowsConstrainedNetworkAccess : Hashable {
	
	public init(_ allowsConstrainedNetworkAccess:Bool) {
		self.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess
	}
	
	public var allowsConstrainedNetworkAccess:Bool
	
}


extension AllowsConstrainedNetworkAccess : URLRequestUpdating {
	
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		if request.allowsConstrainedNetworkAccess == allowsConstrainedNetworkAccess {
			return request
		}
		var newRequest = request
		newRequest.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess
		return newRequest
	}
	
}


public struct AllowsExpensiveNetworkAccess : Hashable {
	
	public init(_ allowsExpensiveNetworkAccess:Bool) {
		self.allowsExpensiveNetworkAccess = allowsExpensiveNetworkAccess
	}
	
	public var allowsExpensiveNetworkAccess:Bool
	
}


extension AllowsExpensiveNetworkAccess : URLRequestUpdating {
	
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		if request.allowsExpensiveNetworkAccess == allowsExpensiveNetworkAccess {
			return request
		}
		var newRequest = request
		newRequest.allowsExpensiveNetworkAccess = allowsExpensiveNetworkAccess
		return newRequest
	}
	
}
