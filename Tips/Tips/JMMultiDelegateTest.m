//
//  JMMultiDelegateTest.m
//  Tips
//
//  Created by 程家明 on 2018/6/11.
//  Copyright © 2018年 程家明. All rights reserved.
//

#import "JMMultiDelegateTest.h"



@implementation JMMultiDelegateTest

- (void)invokeDelegate
{
    [multicastDelegate xmppStreamWillConnect];
}

- (void)addDelegateWith:(id<MMultiDelegate>)delegate
{
    if (multicastDelegate == nil) {
        
        multicastDelegate = [[GCDMulticastDelegate<MMultiDelegate> alloc] init];
    }
    
    [multicastDelegate addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

@end
