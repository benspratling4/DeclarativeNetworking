//
//  String+URLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


//Strings correspond to path elements
extension String : URLRequestUpdating {
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		let newUrl = request.url!.appendingPathComponent(self)
		var newRequest = request
		newRequest.url = newUrl
		return newRequest
	}
}
