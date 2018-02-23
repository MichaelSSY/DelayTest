//
//  ViewController.m
//  DelayTest
//
//  Created by weiyun on 2018/2/22.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self method4];
}

// 1. performSelector方法
- (void)method1
{
    // 开启延时
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2];
    
    // 特定的取消延时
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    // 取消performSelector的所有被延迟执行
    // [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSLog(@"结束");
    
}

// 2. NSTimer定时器
- (void)method2
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    
    // 销毁定时器，就取消了延时
    [timer invalidate];
    
    NSLog(@"结束");
}

// 3. NSThread线程的sleep
- (void)method3
{
    [NSThread sleepForTimeInterval:2.0];
    // 堵住了主线程，只有延时结束才能往下执行
    NSLog(@"结束");
    [self delayMethod];
}

// 4. GCD
- (void)method4
{
    __weak ViewController *weakSelf = self;
    
    /*延迟执行时间2秒*/
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    // 分线程中也可以执行
    dispatch_queue_t globle = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 也可以回到主线程执行
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_after(delayTime, main, ^{
        [weakSelf delayMethod];
    });
    // 先打印“结束”然后才走的 delayMethod 方法，说明主线程没有堵塞的，延时是在分线程中进行
    NSLog(@"结束");
}

- (void)delayMethod
{
    NSLog(@"delayMethodEnd = %@",[NSThread currentThread]);
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
