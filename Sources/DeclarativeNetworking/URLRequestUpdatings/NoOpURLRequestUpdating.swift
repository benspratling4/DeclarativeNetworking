//
//  NullURLRequestBuilderAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation

///does not modify the url request
public struct NoOpURLRequestUpdating : URLRequestUpdating {
	public init() {}
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		return request
	}
}
