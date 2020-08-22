# AshOrderFile
为 Xcode 项目创建 orderfile 

## 主工程设置 Build Settings

```xcodeproj 
Other C Flags       :   -fsanitize-coverage=func,trace-pc-guard
Other Swift Flags   :   -sanitize=undefined -sanitize-coverage=func
```

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