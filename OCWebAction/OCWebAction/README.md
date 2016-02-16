# OCWebAction

OCWebAction is a simple way to package the NSURLSession and handler the data(json、xml and so on) to the entity class

#Manager
User the Manager `OCWebActionManager`,the funcion include:      
>1. Get the Action(implement OCWebActionProtocol) with Synchronous or Asynchronous.
>2. Enable the logging

#Implement Entity Class
The entity class is which you get the data from Http Server and transfer to.Use the OCTransferableProtocol in your entity class.
```swift
class YourClass:OCTransferableProtocol{
}
```

if you want to transfer to a Array type,use the OCTransferableListProtocol.
```swift
class YourClass:OCTransferableListProtocol {
    var list:[OCTransferableProtocol] = [OCTransferableProtocol]()
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
After configure , you can use it easy.
```swift
        let configure = YourConfigureClass()
        configure.url = Target URL
        configure.parameters = [String:String]() // Get or Post Parameters
        let action = OCWebActionManager.shareManager.getSynchronousAction() //if use the asynchronous action, you can user the OCWebActionManager.shareManager.getAsynchronousAction()
        action.action(configure, success: { (result) -> Void in
            //Success 
            }) { (error) -> Void in
                //Failure
        }
```
