//
//  URLQueryItem+URLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


extension URLQueryItem : URLRequestUpdating {
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.url = MinUrl(request.url!).appendingQueryItems([self]).url
		return newRequest
	}
}


extension Optional : URLRequestUpdating where Wrapped == URLQueryItem {
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		switch self {
		case .some(let item):
			return try item.updatingUrlRequest(request)
		case .none:
			return request
		}
	}
}
