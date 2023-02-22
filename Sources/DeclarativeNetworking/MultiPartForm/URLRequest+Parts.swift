//
//  File.swift
//  
//
//  Created by Ben Spratling on 2/21/23.
//

import Foundation


//Should there be a "Form" object, which takes "Field" and "Attachment" things?
public func FormAttachment(_ fieldName:String, filename:String? = nil, contentType:String? = nil, body:Data)->URLRequest.FormPart {
	URLRequest.FormPart.attachment(name: fieldName, filename: filename, contentType: contentType, body: body)
}

public func FormField(_ fieldName:String, value:String)->URLRequest.FormPart {
	return URLRequest.FormPart.field(name: fieldName, value: value)
}


extension Array : URLRequestUpdating where Element == URLRequest.FormPart {
	
	public func updatingUrlRequest(_ request:URLRequest)throws->URLRequest {
		var newRequest = request
		let boundary:String = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
		newRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		var bodyData:Data = Data()
		for part in self {
			bodyData.appendBeginningOfPart(boundary:boundary)
			switch part {
			case .field(name:let name, value:let value):
				bodyData.appendString("Content-Disposition: form-data; name=\"\(name)\"")
				bodyData.appendCrLf()
				bodyData.appendCrLf()
				bodyData.appendString(value)
				
			case .attachment(name:let name, filename:let filenameOrNil, contentType:let contentTypeOrNil, body:let body):
				//Content-disposition: attachment; filename="file2.gif"
				bodyData.appendString("Content-Disposition: form-data; name=\"\(name)\";")
				if let filename:String = filenameOrNil {
					bodyData.appendString(" filename=\""+filename+"\"")
				}
				bodyData.appendCrLf()
				//Content-type: image/gif
				if let type:String = contentTypeOrNil {
					bodyData.appendString("Content-Type: "+type)
					bodyData.appendCrLf()
				}
				
				//Content-Transfer-Encoding: binary
				bodyData.appendString("Content-Transfer-Encoding: binary")
				bodyData.appendCrLf()
				bodyData.appendCrLf()
				bodyData.append(body)
			}
		}
		bodyData.appendEndOfParts(boundary: boundary)
		newRequest.httpBody = bodyData
		newRequest.addValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
		return newRequest
	}
}



extension Data {
	
	fileprivate mutating func appendBeginningOfPart(boundary:String) {
		appendCrLf()
		appendString("--")
		appendString(boundary)
		appendCrLf()
	}
	
	fileprivate mutating func appendEndOfParts(boundary:String) {
		appendCrLf()
		appendString("--")
		appendString(boundary)
		appendString("--")
	}
	
	fileprivate mutating func appendCrLf() {
		appendString("\r\n")
	}
	
	fileprivate mutating func appendString(_ string:String) {
		append(string.data(using: .utf8)!)
	}
}

