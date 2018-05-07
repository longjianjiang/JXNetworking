//
//  ViewController.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXDemoAPIManager.h"

@interface ViewController ()<JXAPIManagerDelegate>
@property (nonatomic, strong) JXDemoAPIManager *demoManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickBtn:(id)sender {
    NSInteger requestId = [self.demoManager loadData];
    [self.demoManager cancelRequestWithRequestId:requestId];
}



#pragma mark - JXAPIManagerDelegate
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager {
    NSLog(@"call api manager success");
}

- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem {
    NSLog(@"call api manager fail");
}


#pragma mark - getter and setter
- (JXDemoAPIManager *)demoManager {
    if (_demoManager == nil) {
        _demoManager = [JXDemoAPIManager new];
        _demoManager.cachePolicy = JXNetworkingCachePolicyDisk;
        _demoManager.delegate = self;
    }
    return _demoManager;
}
@end
