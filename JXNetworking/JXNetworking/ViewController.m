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

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - response method
- (void)refreshPage {
    [self.viewModel.reactiveTable[kJXDemoViewModelReactiveTypePageable].refreshPageCommand execute:nil];
}

- (void)testRACCommand {
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"nancy"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return signal;
        [subject sendNext:@"nancy"];
        return subject;
    }];
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"command's inner signal is be send");
    }];
    
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [command execute:nil];
}

- (IBAction)didClickBtn:(id)sender {
    
    if (sender == self.normalManagerBtn) {
        [self testRACCommand];
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
