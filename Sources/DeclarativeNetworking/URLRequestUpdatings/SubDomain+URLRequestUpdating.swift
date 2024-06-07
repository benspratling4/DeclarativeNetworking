//
//  File.swift
//  
//
//  Created by Ben Spratling on 6/7/24.
//

import Foundation



/**
 Prepend a subdomain onto the URL.  Will include the trailing ".", does not do anything "intelligent" with the concatenation involving conditionally adding the ".".
 
 ```try urlRequest.updating {
	SubDomain("api")
 }
 ```
 
 To avoid confusion prepending multiple subdomains, I recommend doing them all at once.
 
 For instance, if you have and api that requires multiple sub domains, like  `v2.api.example.com`, then the corect order is:
 
 ```try urlRequest.updating {
	SubDomain("api")
	SubDomain("v2")
 }
 ```
 
 but to avoid confusion, you can do:
 
 ```try urlRequest.updating {
	SubDomain("v2.api")
 }
 ```
 
 
 */
public struct SubDomain : Hashable {
	
	public init(_ subdomain:String) {
		self.subdomain = subdomain
	}
	
	public var subdomain:String
}


extension SubDomain : URLRequestUpdating {
	
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		newRequest.url = MinUrl(request.url!)
			.prependingSubDomain(subdomain)
			.url
		return newRequest
	}
	
}
