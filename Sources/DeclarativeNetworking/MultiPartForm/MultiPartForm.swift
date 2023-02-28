//
//  MultiPartForm.swift
//  
//
//  Created by Ben Spratling on 2/21/23.
//

import Foundation



public func MultiPartForm(@MultiPartFormBuilder buildForm:()->[URLRequest.FormPart])->URLRequestUpdating {
	return MultiPartFormItems(fields: buildForm())
}


@resultBuilder public struct MultiPartFormBuilder {
	
	public static func buildExpression(_ component: URLRequest.FormPart?)->SecretMultiPartFormBuildingComponent {
		return SecretMultiPartFormBuildingComponent(parts: component.flatMap({ [$0] }) ?? [])
	}
	
	public static func buildExpression(_ component: URLRequest.FormPart)->SecretMultiPartFormBuildingComponent {
		return SecretMultiPartFormBuildingComponent(parts: [component])
	}
	
	public static func buildExpression(_ components:[URLRequest.FormPart])->SecretMultiPartFormBuildingComponent {
		return SecretMultiPartFormBuildingComponent(parts: components)
	}
	
	public static func buildOptional(_ component: SecretMultiPartFormBuildingComponent?) -> SecretMultiPartFormBuildingComponent {
		return component ?? SecretMultiPartFormBuildingComponent(parts: [])
	}
	
	public static func buildPartialBlock(first content:SecretMultiPartFormBuildingComponent)->SecretMultiPartFormBuildingComponent {
		return content
	}
	
	public static func buildPartialBlock(accumulated content:SecretMultiPartFormBuildingComponent, next:SecretMultiPartFormBuildingComponent)->SecretMultiPartFormBuildingComponent {
		return SecretMultiPartFormBuildingComponent(parts: content.parts + next.parts)
	}
	
	
	public static func buildFinalResult(_ component: SecretMultiPartFormBuildingComponent) -> [URLRequest.FormPart] {
		return component.parts
	}
	
}


extension URLRequest {
	
	public enum FormPart {
		case field(name:String, value:String)
		case attachment(name:String, filename:String?, contentType:String?, body:Data)
		//TODO: consider better name for init'ing?
	}
	
}



public struct SecretMultiPartFormBuildingComponent {
	var parts:[URLRequest.FormPart]
}


