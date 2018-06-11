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
#import "JMSortUtil.h"
#import "JMMultiDelegateTest.h"
#import "JMDelegate1.h"
#import "JMDelegate2.h"

@interface ViewController ()

@property(nonatomic, strong) JMDelegate1 *delegate1;
@property(nonatomic, strong) JMDelegate2 *delegate2;

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
    
//    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@39, @67, @20, @1, @9, @59, @9, @7, @4, @9, @20, @24, @19, @9, @5, @98, @71, @4, nil];
//    [JMSortUtil quickSort:array low:0 high:array.count - 1];
    
    
    //测试多播代理和safe冲突问题。
    JMMultiDelegateTest *test = [[JMMultiDelegateTest alloc] init];
    _delegate1 = [[JMDelegate1 alloc] init];
    _delegate2 = [[JMDelegate2 alloc] init];
    [test addDelegateWith:_delegate1];
    [test addDelegateWith:_delegate2];
    [test invokeDelegate];
    
}

- (void)subViewAction
{
    NSLog(@"事件接收成功");
}

@end

