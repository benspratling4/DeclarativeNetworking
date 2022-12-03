//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation

///a minimal URL, to which we can add things and guarantee we get a new URL out
struct MinUrl {
	
	init(_ url:URL) {
		self.url = url
	}
	
	var url:URL
	
	func appendingPathComponent(_ pathComponent:String)->MinUrl {
		return MinUrl(url.appendingPathComponent(pathComponent))
	}
	
	func appendingQueryItems(_ items:[URLQueryItem], alreadyPercentEncoded:Bool = false)->MinUrl {
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		var queryItems = (alreadyPercentEncoded ? components.percentEncodedQueryItems : components.queryItems) ?? []
		items.forEach { item in queryItems.append(item) }
		if alreadyPercentEncoded {
			components.percentEncodedQueryItems = queryItems
		}
		else {
			components.queryItems = queryItems
		}
		return MinUrl(components.url!)
	}
	
}
