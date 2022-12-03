# DeclarativeNetworking
 Constructing URLRequests declaratively


For Apple platforms, `Foundation`'s `URL` and `URLRequest` are object-oriented types.  For clarity and correctness, we'd like to have declarative / functional API's for providing aspects to `URLRequest`s.
This library offers simple `resultBuilders` which make constructing `URLRequest`s for large applications doable with declarative syntax. 


## URLRequests (`@URLRequestUpdating`)

### `func updating { ... }`

Large apps will want to provide `URLRequest`s from common code to establish their domains, schemes, and many common headers, such as `Cache-Control` or `AcceptLanguage`.  They may need to be modified after the fact for request signing for `Authorization`.  To support these workflows, instead of requiring you to construct a fresh `URLRequest` and then pass it off to updating for common values, this library assumes you have vended a request with minimal pre-configuration and focuses on how to update an existing `URLRequest` which already has a basic `URL`.

```swift
func createTemplateURLRequest()->URLRequest { ... }

let request = createTemplateURLRequest().updating {
	HTTPMethod.POST
	"/v1/statuses"
}

```


Of course, if you want to start from scratch, you can always just:

```swift
let rootUrl = URL(string:"https://api.myserver.com")!
let request = URLRequest(url:rootUrl).updating {
	HTTPMethod.POST
	"/v1/statuses"
}
```  



### Methods

This library defines `HTTPMethod`, a `String`-based `enum` for all standard HTTP methods.  You can modify the methods of a URLRequest just by adding an expression of a method case:

```swift
let request = templateRequest.updating {
	HTTPMethod.POST
}
```

### Paths

Plain `String`s are interpretted as path components, each `String` in the closure is a call to `appendingPathComponent` on the `URL`.

```swift
let request = templateRequest.updating {
	"v1/statuses"
}
```

The path of the resulting URLRequest would be "/v1/statuses"

While 

```swift
let request = templateRequest.updating {
	"v1"
	"statuses"
}
```
produces the same result, thus allowing you to intersperse String variables within the body without the need for additional syntax:

```swift
let accountId:String = ...
let request = templateRequest.updating {
	"v1/accounts"
	accountId
	"media"
}
```


### Query Items

Foundation's `URLQueryItem` will append the item to the request's url.  Often query items are optional, resulting in lots of code.  With Swift result builders, this is dramatically simplified.  Consider a "sinceId" which is an optional query parameter:

```swift
let sinceId:String? = ...
let request = templateRequest.updating {
	"v1/posts"
	if let arg = sinceId {
		URLQueryItem(name:"sinceId", value:arg)
	}
	URLQueryItem(name:"limit", value:"20")
}
```

The result builder handles the optional inclusion of the sinceId paramter, while the limit parameter is always included.


### Extensibility

`URLRequest.updating` is implemented with a protocol, `URLRequestUpdating`, and as a result, you can declare your own types to conform, allowing them to update the `URLRequest` as needed. 

They merely need to implement the `func updatingUrlRequest(_ request:URLRequest)throws->URLRequest` method.


## Headers

This package contains several convenient header types, which all conform to `URLRequestUpdating`, and thus can be used as direct declarations inside a `@URLRequestUpdating` block.


### ContentType

Declares the `Content-Type` header:

```swift
let sinceId:String? = ...
let request = templateRequest.updating {
	HTTPMethod.POST
	"v1/media"
	ContentType("image/jpeg")
}
```

On platforms which have the `UniformTypeIdentifiers` framework, you can pass a `UTType` into the initializer, which will create the header with the `.preferredMimeType`.  Keep in mind `UTTypes` are not required to provide MIME types, and thus this `init` method is optional 



### Authorization

If you heave a bearer token, add the authorization header like so:
```swift
let bearerToken:String = ...
let request = templateRequest.updating {
	Authorization(.bearer(bearerToken))
}
```

There is an enum with 2 predefined standard Authorization schemes, .bearer and .basic.


#### Authorization Extensibility

You can implement your own Authorization schemes by creating a type which conforms to the `AuthorizationScheme` protocol.  See implementtions for `BearerAuthorizationScheme` and `BasicAuthorizationScheme` to do that.


### AcceptLanguage

To set the languages the user may be able to read, use the Accept-Language header via `AcceptLanguage`.  Usually, you'll want to use the ones set by the system, and the `init` method with no arguments is the one which does that.

```swift
let bearerToken:String = ...
let request = templateRequest.updating {
	AcceptLanguage()
}
```

Will include a list of the `NSLocale.preferredLanguages` with quality paramters in order.

### IdempotencyKey

//TODO: write me

### Cache-Control

```swift
let request = templateRequest.updating {
	CacheControl([.noCache, .noStore])
}
```


### Header Extensibility

All the included header types conform to the `URLRequestHeader` protocol, which allows you to provide your own header types, merely by implementing the `name` and `value` properties.
Types which conform to the `URLRequestHeader` protocol automatically conform to the `URLRequestUpdating` protocol.


## Body

### `Data`

If you provide a `Data` directly, it will be added as the `httpBody` of the request.
This builder does not attempt to validate that you do not add bodies to GET methods.


### (Data, String)

To provide a mime type directly when you have one handy, you can provide a tuple of the data and the mime type.


### JSON Encoding

Often, you'll have identical settings for your `JSONEncoder` for most endpoints in your app.  So for encoding bodies into json, we assume you'll ant to build your `JSONEncoder` independently and reuse it across many api calls. 

But once you have your `JSONEncoder`, there's a quick public function called `JSON`:

```swift
let encoder:JSONEncoder = ...
let someEncodable:Encodable = ...
let request = templateRequest.updating {
	JSON(someEncodable, encoder)
}
```

The `JSON` convenience function also sets your `Content-Type` header to "application/json"

You'll notice that encodable body comes first, that's so the various options for providing JSONEncoders are always second.

If you want to configure a one-off JSONEncoder, you can do so with the builder:

 ```swift
let someEncodable:Encodable = ...
let request = templateRequest.updating {
	JSON(someEncodable) {
		JSONEncoder.DateEncodingStrategy.millisecondsSince1970
		JSONEncoder.DataEncodingStrategy.base64
		JSONEncoder.OutputFormatting([.sortedKeys, .withoutEscapingSlashes])
	}
}
```


#### @JSONEncoderBuilder

The independent JSONEncoderBuilder takes declarative values for any property on a `JSONEncoder` instance, and sets them on the right property, in any order.

You can use the values with the JSON function, as in the pervious example, or your can declare your own builder closures which use the `@JSONEncoderBuilder` resultBuilder to return a `JSONEncoder` instance.
	


### Extensible body encoding

Any encoder which conforms to Combine's TopLevelEncoder can be used to set the body.  First, add an extension to your encoder so it conforms to `MimeTypingTopLevelEncoder`, which declares one property `var encodingMimeType:String`.  Return the correct MIME type from that.

Then construct a `BodyEncodingUrlUpdating` from with a body (which conforms to `Encodable` and your encoder instance.)

This `BodyEncodingUrlUpdating` instance may be provided directly into the url request builder closure  


