//
//  NSObject+Safe.m
//  multi-ios
//
//  Created by 程家明 on 2018/6/7.
//  Copyright © 2018年 CRNet. All rights reserved.
//

#import "NSObject+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation NSObject (Swizzle)

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class cls = [self class];
    Method originalMethod = class_getClassMethod(cls, origSelector);
    Method swizzleMethod  = class_getClassMethod(cls, newSelector);
    
    Class metaCls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    BOOL isDidAdd = class_addMethod(metaCls, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (isDidAdd) {
        
        class_replaceMethod(metaCls, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        
        IMP originalIMP = class_replaceMethod(metaCls, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        class_replaceMethod(metaCls, newSelector, originalIMP, method_getTypeEncoding(originalMethod));
    }
}

- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class cls = [self class];
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzleMethod  = class_getInstanceMethod(cls, newSelector);
    BOOL isDidAdd = class_addMethod(cls, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (isDidAdd) {

        class_replaceMethod(cls, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {

        IMP originalIMP = class_replaceMethod(cls, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        class_replaceMethod(cls, newSelector, originalIMP, method_getTypeEncoding(originalMethod));
    }
}

@end

@implementation NSObject (Safe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSObject *object = [[NSObject alloc] init];
        [object swizzleInstanceMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(hookAddObserver:forKeyPath:options:context:)];
        [object swizzleInstanceMethod:@selector(removeObserver:forKeyPath:) withMethod:@selector(hookRemoveObserver:forKeyPath:)];
    });
}

- (void)hookAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    if (!observer || !keyPath.length) {

        NSAssert(NO, @"hookAddObserver invalid args: %@", self);
        return;
    }
    @try {

        [self hookAddObserver:observer forKeyPath:keyPath options:options context:context];
    }
    @catch (NSException *exception) {

        NSLog(@"hookAddObserver ex: %@", [exception callStackSymbols]);
    }
}

- (void)hookRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if (!observer || !keyPath.length) {

        NSAssert(NO, @"hookRemoveObserver invalid args: %@", self);
        return;
    }
    @try {

        [self hookRemoveObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {

        NSLog(@"hookAddObserver ex: %@", [exception callStackSymbols]);
    }
}

@end

@implementation NSArray (Safe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        /* 数组有内容obj类型才是__NSArrayI */
        NSArray *array = [[NSArray alloc] initWithObjects:@1, @2, nil];
        [array swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(hookObjectAtIndex:)];
        [array swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(hookObjectAtIndexedSubscript:)];
        [array swizzleInstanceMethod:@selector(subarrayWithRange:) withMethod:@selector(hookSubarrayWithRange:)];

        /* iOS10 以上，单个内容类型是__NSArraySingleObjectI */
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {

            NSArray *array = [[NSArray alloc] initWithObjects:@1, nil];
            [array swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(hookObjectAtIndex:)];
            [array swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(hookObjectAtIndexedSubscript:)];
            [array swizzleInstanceMethod:@selector(subarrayWithRange:) withMethod:@selector(hookSubarrayWithRange:)];
        }

        /* iOS9 以上，没内容类型是__NSArray0 */
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {

            NSArray *array = [[NSArray alloc] init];
            [array swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(hookObjectAtIndex:)];
            [array swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(hookObjectAtIndexedSubscript:)];
            [array swizzleInstanceMethod:@selector(subarrayWithRange:) withMethod:@selector(hookSubarrayWithRange:)];
        }
    });
}

- (id)hookObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndex:index];
    }

    NSAssert(NO, @"NSArray invalid index:[%@]", @(index));
    return nil;
}

- (id)hookObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndexedSubscript:index];
    }
    NSAssert(NO, @"NSArray invalid index:[%@]", @(index));
    return nil;
}

- (NSArray *)hookSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count) {
        return [self hookSubarrayWithRange:range];
    } else if (range.length < self.count) {
        return [self hookSubarrayWithRange:NSMakeRange(range.location, self.count - range.location)];
    }
    return nil;
}

@end

@implementation NSMutableArray (Safe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        [mutableArray swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(hookObjectAtIndex:)];
        [mutableArray swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(hookObjectAtIndexedSubscript:)];
        [mutableArray swizzleInstanceMethod:@selector(subarrayWithRange:) withMethod:@selector(hookSubarrayWithRange:)];
    });
}

- (id)hookObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndex:index];
    }

    NSAssert(NO, @"NSArray invalid index:[%@]", @(index));
    return nil;
}

- (id)hookObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndexedSubscript:index];
    }
    NSAssert(NO, @"NSArray invalid index:[%@]", @(index));
    return nil;
}

- (NSArray *)hookSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count) {
        return [self hookSubarrayWithRange:range];
    } else if (range.length < self.count) {
        return [self hookSubarrayWithRange:NSMakeRange(range.location, self.count - range.location)];
    }
    return nil;
}

@end


