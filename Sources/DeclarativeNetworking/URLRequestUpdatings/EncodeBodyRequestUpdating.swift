//
//  EncodeBodyAction.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation
import Combine


public struct BodyEncodingUrlUpdating<Encoder:MimeTypingTopLevelEncoder> : URLRequestUpdating where Encoder.Output == Data {
	
	public init(body:Encodable, encoder:Encoder) {
		self.body = body
		self.encoder = encoder
	}
	
	public var body:Encodable
	public var encoder:Encoder
	
	//MARK: - URLRequestUpdating
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.httpBody = try encoder.encode(body)
		newRequest.addValue(encoder.encodingMimeType, forHTTPHeaderField:"Content-Type")
		return newRequest
	}
}


public protocol MimeTypingTopLevelEncoder : TopLevelEncoder {
	var encodingMimeType:String { get }
}
