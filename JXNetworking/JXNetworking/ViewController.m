//
//  ViewController.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXDemoAPIManager.h"

@interface ViewController ()<JXAPIManagerDataSource, JXAPIManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JXDemoAPIManager *demoManager;
@end

static NSString * const kCellReuseIdentifier = @"kCellReuseIdentifier";

@implementation ViewController


#pragma mark - life cycle
- (void)setupSubview {
    [self.view addSubview:self.tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupSubview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - response method
- (IBAction)didClickBtn:(id)sender {
    
    if (self.demoManager.hasNextPage) {
        [self.demoManager loadNextPage];
    } else {
        NSLog(@"已经到底了");
        [self.demoManager resetPage:2];
        [self.demoManager loadNextPage];
    }
    
    
//    NSInteger requestId = [self.demoManager loadData];
//    [self.demoManager cancelRequestWithRequestId:requestId];
}



#pragma mark - JXAPIManagerDelegate
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager {
    NSLog(@"call api manager success");
    [self.tableView reloadData];
}

- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem {
    NSLog(@"call api manager fail");
}


#pragma mark - JXAPIManagerDataSource
- (NSDictionary *)paramsForCallAPI:(JXBaseAPIManager *)manager {
    return @{@"token": @"0e7e8f19-401b-47d4-8658-e296bea5411c"};
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


#pragma mark - getter and setter
- (JXDemoAPIManager *)demoManager {
    if (_demoManager == nil) {
        _demoManager = [JXDemoAPIManager new];
        _demoManager.cachePolicy = JXNetworkingCachePolicyNoCache;
        _demoManager.delegate = self;
        _demoManager.paramsSource = self;
    }
    return _demoManager;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    }
    return _tableView;
}

@end
