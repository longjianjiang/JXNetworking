//
//  ViewController.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXDemoAPIManager.h"

@interface ViewController ()<JXAPIManagerDelegate, UITableViewDelegate, UITableViewDataSource>
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
    NSInteger requestId = [self.demoManager loadData];
}



#pragma mark - JXAPIManagerDelegate
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager {
    NSLog(@"call api manager success");
    [self.tableView reloadData];
}

- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem {
    NSLog(@"call api manager fail");
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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
