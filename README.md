# AshOrderFile
为 Xcode 项目创建 orderfile 

## Podfile

```ruby
pod 'AshOrderFile', :path => '../'

post_install do |installer|
    require '../AshOrderFile/AshOrderFile.rb'
    updateInstall(installer)
end
```

## AppDelegate

```objc
#import <AshOrderFile.h>

NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"OrderFile.order"];
[AshOrderFile exportOrderFileWithFilePath:filePath];
```

```swift
import AshOrderFile

let filePath = NSTemporaryDirectory().appending("/OrderFile.order")
AshOrderFile.exportOrderFile(filePath: filePath)
```