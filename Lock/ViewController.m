//
//  ViewController.m
//  Lock
//
//  Created by xiekunpeng on 2019/4/24.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSLocking>
@property (nonatomic, strong) NSMutableArray        *dataArr1;
@property (nonatomic, strong) NSMutableArray        *dataArr2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self synchronizedLockCase];
    [self nslockCase];
    // Do any additional setup after loading the view.
}




- (void)nslockCase {
    for (int i = 0; i < 5; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLock *lock = [[NSLock alloc] init];
            [lock lock];
            sleep(1);
            if (i % 2==0) {
                /**
                 这种写法会造成死锁, 要用递归锁解决;
                 [lock lock];
                 [self.dataArr2 addObject:@"ABC"];
                 [lock unlock];
                 */
                [self.dataArr2 addObject:@"ABC"];

            }else {
                [self.dataArr2 addObject:@"EFG"];
            }
//            [self.dataArr2 addObject:[@(i) stringValue]];
            NSLog(@"%@___", [NSThread currentThread]);
            [lock unlock];
        });
    }
}





///如果不对getter方法加上@synchronized锁, 程序无法运行;
- (void)synchronizedLockCase {
    for (int i = 0; i < 5; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (i % 2==0) {
                [self.dataArr1 addObject:@"ABC"];
            }else {
                [self.dataArr1 addObject:@"EFG"];
            }
            NSLog(@"%@___", [NSThread currentThread]);
        });
    }

}

#pragma mark    getter
- (NSMutableArray *)dataArr1 {
    @synchronized (self) {
        if (!_dataArr1) {
            _dataArr1 = [NSMutableArray arrayWithCapacity:0];
        }
        return  _dataArr1;
    }
}


- (NSMutableArray *)dataArr2 {
    if (!_dataArr2) {
        _dataArr2 = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr2;
}




@end
