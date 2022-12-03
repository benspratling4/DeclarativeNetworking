//
//  File.swift
//  
//
//  Created by Benjamin Spratling on 12/2/22.
//

import Foundation


@resultBuilder public struct JSONEncoderBuilder {
	public static func buildPartialBlock(first content:JSONEncoder.DateEncodingStrategy)->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:JSONEncoder.DateEncodingStrategy)->JSONEncoder {
		content.dateEncodingStrategy = next
		return content
	}
	
	public static func buildPartialBlock(first content:JSONEncoder.DataEncodingStrategy)->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dataEncodingStrategy = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:JSONEncoder.DataEncodingStrategy)->JSONEncoder {
		content.dataEncodingStrategy = next
		return content
	}
	
	public static func buildPartialBlock(first content:JSONEncoder.OutputFormatting)->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.outputFormatting = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:JSONEncoder.OutputFormatting)->JSONEncoder {
		content.outputFormatting = next
		return content
	}
	
	public static func buildPartialBlock(first content:JSONEncoder.KeyEncodingStrategy)->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:JSONEncoder.KeyEncodingStrategy)->JSONEncoder {
		content.keyEncodingStrategy = next
		return content
	}
	
	public static func buildPartialBlock(first content:JSONEncoder.NonConformingFloatEncodingStrategy)->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.nonConformingFloatEncodingStrategy = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:JSONEncoder.NonConformingFloatEncodingStrategy)->JSONEncoder {
		content.nonConformingFloatEncodingStrategy = next
		return content
	}
	
	public static func buildPartialBlock(first content:[CodingUserInfoKey : Any])->JSONEncoder {
		let encoder = JSONEncoder()
		encoder.userInfo = content
		return encoder
	}
	
	public static func buildPartialBlock(accumulated content:JSONEncoder, next:[CodingUserInfoKey : Any])->JSONEncoder {
		content.userInfo = next
		return content
	}
}

