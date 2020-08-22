//
//  AshOrderFile.h
//
//  Created by Harry Houdini on 2020/8/22.
//  Copyright © 2020 ParadoxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AshOrderFile : NSObject

+ (BOOL)exportOrderFileWithFilePath:(NSString *)filePath NS_SWIFT_NAME(exportOrderFile(filePath:));

@end
