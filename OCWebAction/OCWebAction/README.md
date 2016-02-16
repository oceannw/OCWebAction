# OCWebAction

OCWebAction is a simple way to package the NSURLSession and handler the data(json、xml and so on ) to the entity class

#Implement Entity Class
Use the OCTransferableProtocol in your entity class.
```swift
class YourClass:OCTransferableProtocol{
}
```

if you need to return a list data , use the OCTransferableListProtocol.
```swift
class YourClass:OCTransferableListProtocol {
    var list:[OCTransferableProtocol] = [OCTransferableNilObject]()
}
```

#Configure 
Implement the OCWebActionConfigureProtocol or use the OCDefaultWebActionConfigure to configure the HTTP setting and transfer the return data to the OCTransferableProtocol entity class.
Default,you just override the OCDefaultWebActionConfigure:
```swift
class YourConfigureClass : OCDefaultWebActionConfigure{
    func transfer(dictionary: NSDictionary) -> OCTransferableProtocol{
        \\ Your code , handler the return data as NSDictionary and tranfer to OCTransferableProtocol entity class
    }
}
```
#Usage
When finish above configure , you can use it easy.
```swift
        let configure = YourConfigureClass()
        configure.url = Target URL
        configure.parameters = [String:String]() // Get or Post Parameters
        let action = OCWebActionManager.shareManager.getSynchronousAction() //if use the asynchronous action, you can user the OCWebActionManager.shareManager.getAsynchronousAction()
        action.action(configure, success: { (result) -> Void in
            \\Success 
            }) { (error) -> Void in
                \\Failure
        }
```
