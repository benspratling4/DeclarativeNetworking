//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


public struct AcceptLanguage : URLRequestHeader {
	
	///uses NSLocale.preferredLanguages
	public init() {
		var quality:Float = 1.0
		languages = NSLocale.preferredLanguages.compactMap { code in
			guard quality >= 0.0 else { return nil }
			defer {
				quality -= 0.1
			}
			return AcceptibleLanguage(code: code, quality:quality)
		}
	}
	
	public init(languages:[AcceptibleLanguage]) {
		self.languages = languages
	}
	
	public var languages:[AcceptibleLanguage]
	
	//MARK: - URLRequestHeader
	
	public var name: String { "Accept-Language" }
	public var value:String {
		languages
			.map { $0.encoded }
			.joined(separator: ",")
	}
}




public struct AcceptibleLanguage {
	
	public init(code:String, quality:Float? = nil) {
		self.code = code
		self.quality = quality
	}
	
	///same kind of code as NSLocale's preferredLanguages
	public var code:String
	public var quality:Float?
	
	public var encoded:String {
		var string:String = code
		if let q = quality {
			string += ";q=\(q)"
		}
		return string
	}
}
