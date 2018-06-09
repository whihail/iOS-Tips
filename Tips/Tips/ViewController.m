//
//  ViewController.m
//  Tips
//
//  Created by 程家明 on 2018/6/7.
//  Copyright © 2018年 程家明. All rights reserved.
//

#import "ViewController.h"
#import "JMSubView.h"
#import "JMSuperView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    /*让子view能接收到事件*/
    JMSuperView *superView = [[JMSuperView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    superView.userInteractionEnabled = YES;
    superView.backgroundColor = [UIColor redColor];
    [self.view addSubview:superView];
    
    JMSubView *subView = [[JMSubView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200)];
    subView.userInteractionEnabled = YES;
    subView.backgroundColor = [UIColor blueColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewAction)];
    [subView addGestureRecognizer:tap];
    [superView addSubview:subView];
}

- (void)subViewAction
{
    NSLog(@"事件接收成功");
}

@end

