//
//  JMMultiDelegateTest.h
//  Tips
//
//  Created by 程家明 on 2018/6/11.
//  Copyright © 2018年 程家明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"

@protocol MMultiDelegate
@optional

/**
 * This method is called before the stream begins the connection process.
 *
 * If developing an iOS app that runs in the background, this may be a good place to indicate
 * that this is a task that needs to continue running in the background.
 **/
- (void)xmppStreamWillConnect;

@end

@interface JMMultiDelegateTest : NSObject
{
    GCDMulticastDelegate<MMultiDelegate> *multicastDelegate;
}

- (void)invokeDelegate;
- (void)addDelegateWith:(id<MMultiDelegate>)delegate;

@end
