//
//  URLRequest+updating.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation




extension URLRequest {
	public func updating(@URLRequestUpdatingBuilder _ builder:()throws->URLRequestUpdating)throws->URLRequest {
		let actions = try builder().allURLRequestUpdating
		var finalRequest = self
		for action in actions {
			finalRequest = try action.updatingUrlRequest(finalRequest)
		}
		return finalRequest
	}
}
