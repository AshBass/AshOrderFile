//
//  AshOrderFile.m
//
//  Created by Harry Houdini on 2020/8/22.
//  Copyright © 2020 ParadoxStudio. All rights reserved.
//

#import "AshOrderFile.h"
#import <dlfcn.h>
#import <pthread.h>
#import <libkern/OSAtomicQueue.h>

static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;

typedef struct {
    void *pc;
    void *next;
} Node;

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    static uint32_t N;
    if (start == stop || *start) {
        return;
    }
    for (uint32_t *x = start; x < stop; x++) {
        *x = ++N;
    }
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//    这里可以标记已经遍历过的方法，避免再进入
    if (!*guard) {
        return;
    }
    *guard = 0;
    
    /// 构建链表
    void *PC = __builtin_return_address(0);
    Node *node = malloc(sizeof(Node));
    *node = (Node){PC, NULL};
    /// OSAtomicEnqueue 原子队列 线程安全
    OSAtomicEnqueue(&symbolList, node, offsetof(Node, next));
}

@implementation AshOrderFile

+ (BOOL)exportOrderFileWithFilePath:(NSString *)filePath {
    if (![NSURL fileURLWithPath:filePath]) {
        return NO;
    }
    NSMutableArray<NSString*> *symbolNames = [NSMutableArray array];
    while (YES) {
        /// 取链表
        Node *node = OSAtomicDequeue(&symbolList, offsetof(Node, next));
        if (node == NULL) {
            break;
        }
        
        ///获取地址符号
        Dl_info info;
        dladdr(node->pc, &info);
        
        NSString *symbolName = @(info.dli_sname);
        // Objective-C 方法
        BOOL objc = [symbolName hasPrefix:@"+["] || [symbolName hasPrefix:@"-["];
        // C 方法要以下划线开头
        symbolName = objc? symbolName : [@"_" stringByAppendingString:symbolName];
        [symbolNames addObject:symbolName];
    }
    
    /// 符号排序
    NSMutableArray<NSString*> *funcs = [symbolNames reverseObjectEnumerator].allObjects.mutableCopy;
    
    /// 去除当前方法
    NSString *exclude = [NSString stringWithFormat:@"_%s", __FUNCTION__];
    [funcs removeObject:exclude];
    
    NSString *funcStr = [funcs componentsJoinedByString:@"\n"];
    NSData *fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
}

@end
