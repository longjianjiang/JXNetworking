//
//  ViewController.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXDemoViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "UIScrollView+PullUp.h"
#import "JXDemoCell.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *normalManagerBtn;
@property (weak, nonatomic) IBOutlet UIButton *pageableManagerBtn;


@property (nonatomic, strong) JXDemoViewModel *viewModel;

@end


@implementation ViewController


#pragma mark - life cycle
- (void)setupSubview {
    [self.view addSubview:self.tableView];
}

- (void)setupRAC {
    
    @weakify(self);
    [[RACObserve(self.viewModel, videoList) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView.indicator hideIndicator];
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].requestErrorSignal subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"error msg is %@", x.userInfo[kJXResponseFailItemErrorMessageKey]);
        [self.tableView.indicator hideIndicator];
        [self.tableView.refreshControl endRefreshing];
    }];
    
}

- (void)setupPage {
    
    @weakify(self);
    [self.tableView addPullUpWithActionHandler:^{
        @strongify(self);
        if (self.viewModel.hasNextPage) {
            [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].loadNextPageCommand execute:nil];
        } else {
            self.tableView.pullUpGetMore = NO;
            NSLog(@"到底了");
        }
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.tintColor = [UIColor grayColor];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = refreshControl;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    [self setupRAC];
    [self setupPage];

    
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].executionSignal subscribeNext:^(JXResponseSuccessItem * _Nullable x) {
        NSLog(@"************normal manager load data success");
    }];
    
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"************normal manager loading");
        }
    }];
    
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].requestErrorSignal subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"************normal manager load data fail");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - response method
- (void)refreshPage {
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].refreshPageCommand execute:nil];
}

- (IBAction)didClickBtn:(id)sender {
    
    if (sender == self.normalManagerBtn) {
        [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypeNormal].requestCommand execute:nil];
    }
    
    if (sender == self.pageableManagerBtn) {
    }
    
}


#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.videoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.viewModel.videoList[indexPath.row];
    

    JXDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:kJXDemoCellReuseIdentifier forIndexPath:indexPath];
    [cell updateMsg:[NSString stringWithFormat:@"video item %ld",(long)indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - getter and setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JXDemoCell class] forCellReuseIdentifier:kJXDemoCellReuseIdentifier];
        _tableView.rowHeight = 64;
    }
    return _tableView;
}


- (JXDemoViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [JXDemoViewModel new];
    }
    return _viewModel;
}
@end
