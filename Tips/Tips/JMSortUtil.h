//
//  JMSortUtil.h
//  Tips
//
//  Created by 程家明 on 2018/6/10.
//  Copyright © 2018年 程家明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSortUtil : NSObject

#pragma mark - 冒泡排序
+ (void)bubbleSort:(NSMutableArray *)array;
#pragma mark - 选择排序
+ (void)selectSort:(NSMutableArray *)array;
#pragma mark - 插入排序
+ (void)inserSort:(NSMutableArray *)array;
#pragma mark - 快速排序
+ (void)quickSort:(NSMutableArray *)array low:(int)low high:(int)high;
#pragma mark - 堆排序
+ (void)heapsortAsendingOrderSort:(NSMutableArray *)ascendingArr;
#pragma mark - 归并升序排序
+ (void)megerSortAscendingOrderSort:(NSMutableArray *)ascendingArr;
#pragma mark - 希尔排序
+ (void)shellAscendingOrderSort:(NSMutableArray *)ascendingArr;
#pragma mark - 基数排序
+ (void)radixAscendingOrderSort:(NSMutableArray *)ascendingArr;

@end
