//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation



public struct CacheControl : URLRequestHeader {
	
	public init(_ directives:[Directive]) {
		self.directives = directives
	}
	
	public enum Directive {
		case noStore
		case noCache
		case maxAge(_ seconds:Int)
		case maxStale(_ seconds:Int)
		case minFresh(_ seconds:Int)
		case noTransform
		case onlyIfCached
		
		var statement:String {
			switch self {
			case .noCache:
				return "no-cache"
			case .noStore:
				return "no-store"
			case .maxAge(let seconds):
				return "max-age=\(seconds)"
			case .maxStale(let seconds):
				return "max-stale=\(seconds)"
			case .minFresh(let seconds):
				return "max-fresh=\(seconds)"
			case .noTransform:
				return "no-transform"
			case .onlyIfCached:
				return "only-if-cached"
			}
		}
	}
	
	public var directives:[Directive]
	
	
	//MARK: - URLRequestHeader
	
	public var name: String { "Cache-Control" }
	
	public var value: String {
		return directives
			.map { $0.statement }
			.joined(separator: ", ")
	}
	
}
