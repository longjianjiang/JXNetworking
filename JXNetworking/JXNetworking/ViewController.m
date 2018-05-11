//
//  ViewController.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXDemoManager.h"
#import "JXPageableDemoManager.h"


@interface ViewController ()<JXAPIManagerDataSource, JXAPIManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;




@property (weak, nonatomic) IBOutlet UIButton *normalManagerBtn;
@property (weak, nonatomic) IBOutlet UIButton *pageableManagerBtn;


@property (nonatomic, strong) JXDemoManager *normalManager;
@property (nonatomic, strong) JXPageableDemoManager *pageableManager;

@end

static NSString * const kCellReuseIdentifier = @"kCellReuseIdentifier";

@implementation ViewController


#pragma mark - life cycle
- (void)setupSubview {
    [self.view addSubview:self.tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - response method
- (IBAction)didClickBtn:(id)sender {
    
    if (sender == self.normalManagerBtn) {
        [self.normalManager loadData];
    }
    
    if (sender == self.pageableManagerBtn) {
        if (self.pageableManager.hasNextPage) {
            [self.pageableManager loadNextPage];
        } else {
            NSLog(@"已经到底了");
        }
        
        if (self.pageableManager.currentPageNumber == 3) {
            [self.pageableManager resetPage:5];
        }
    }
    
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
    if (manager == self.normalManager) {
        return @{@"token": @"0e7e8f19-401b-47d4-8658-e296bea5411c",
                 @"type": @(1)
                 };
    } else if (manager == self.pageableManager) {
        return @{@"token": @"0e7e8f19-401b-47d4-8658-e296bea5411c"};
    }
    
    return nil;
    
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


#pragma mark - getter and setter
- (JXDemoManager *)normalManager {
    if (_normalManager == nil) {
        _normalManager = [JXDemoManager new];
        _normalManager.cachePolicy = JXNetworkingCachePolicyDisk;
        _normalManager.delegate = self;
        _normalManager.paramsSource = self;
    }
    return _normalManager;
}

- (JXPageableDemoManager *)pageableManager {
    if (_pageableManager == nil) {
        _pageableManager = [JXPageableDemoManager new];
        _pageableManager.cachePolicy = JXNetworkingCachePolicyNoCache;
        _pageableManager.delegate = self;
        _pageableManager.paramsSource = self;
    }
    return _pageableManager;
    
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
