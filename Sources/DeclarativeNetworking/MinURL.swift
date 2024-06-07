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
	
	func settingPathQueryItemsAndFragment(from otherUrl:URL)->URL {
		let otherComponents = URLComponents(url: otherUrl, resolvingAgainstBaseURL: false)!
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		components.path = otherComponents.path
		components.queryItems = otherComponents.queryItems
		components.fragment = otherComponents.fragment
		return components.url!
	}
	
	func prependingSubDomain(_ subDomain:String)->MinUrl {
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		var host:String = components.host ?? ""
		host = subDomain + "." + host
		components.host = host
		return MinUrl(components.url!)
	}
	
}
