//
//  MultiPartForm.swift
//  
//
//  Created by Ben Spratling on 2/21/23.
//

import Foundation



public func MultiPartForm(@MultiPartFormBuilder buildForm:()->[URLRequest.FormPart])->URLRequestUpdating {
	return buildForm()
}


@resultBuilder public struct MultiPartFormBuilder {
	
	public static func buildPartialBlock(first content:URLRequest.FormPart)->[URLRequest.FormPart] {
		return [content]
	}
	
	public static func buildPartialBlock(accumulated content:[URLRequest.FormPart], next:URLRequest.FormPart)->[URLRequest.FormPart] {
		var newContent = content
		newContent.append(next)
		return newContent
	}
	
}


extension URLRequest {
	
	public enum FormPart {
		case field(name:String, value:String)
		case attachment(name:String, filename:String?, contentType:String?, body:Data)
		//TODO: consider better name for init'ing?
	}
	
}

