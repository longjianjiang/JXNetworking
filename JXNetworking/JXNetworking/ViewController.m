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
        [self.tableView reloadData];
    }];
    
    [self.viewModel.reactive.requestErrorSignal subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"error msg is %@", x.userInfo[kJXResponseFailItemErrorMessageKey]);
        [self.tableView.indicator hideIndicator];
    }];
    
}

- (void)setupPage {
    
    @weakify(self);
    [self.tableView addPullUpWithActionHandler:^{
        @strongify(self);
        if (self.viewModel.hasNextPage) {
            [self.viewModel.reactive.loadNextPageCommand execute:nil];
        } else {
            self.tableView.pullUpGetMore = NO;
            NSLog(@"到底了");
        }
    }];
    
}


- (void)testSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(5)];
        [subscriber sendNext:@(6)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal be disposable");
        }];
    }];
    

    RACSignal *anotherSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(7)];
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"anotherSignal be disposable");
        }];
    }];
    
    RACSignal *flattenMapSignal = [signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSInteger twoTimes = [value integerValue] * [value integerValue];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@(twoTimes)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
   
    
//    RACSignal *concatSignal = [signal concat:anotherSignal];
//    RACSignal *zipSignal = [signal zipWith:anotherSignal];
    
    RACDisposable *disposable = [flattenMapSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %@",x);
    } completed:^{
        NSLog(@"signal completed");
    }];
    
}

- (void)testSequence {
    RACSequence *sequence = [RACSequence sequenceWithHeadBlock:nil tailBlock:nil];
}




- (void)testCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSInteger integer = [input integerValue];
            for (int i = 0; i < integer; ++i) {
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [command execute:@(1)];
    
//    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
//        [command execute:@(2)];
//    }];
//
//    [[RACScheduler mainThreadScheduler] afterDelay:0.2 schedule:^{
//        [command execute:@(3)];
//    }];
    
    
}

- (void)testSubject {
    
    
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"nancy"];
    [subject sendCompleted];
    
    
    
    /*
     RACBehaviorSubject *behaviorSubject = [RACBehaviorSubject subject];
     [behaviorSubject sendNext:@"88"];
     
     [behaviorSubject subscribeNext:^(id  _Nullable x) {
     NSLog(@"first %@",x);
     }];
     
     [behaviorSubject sendNext:@"77"];
     
     [behaviorSubject subscribeNext:^(id  _Nullable x) {
     NSLog(@"second %@",x);
     }];
     */
    
    
}

- (void)testConnection {
    RACSignal *connection = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(5)];
        [subscriber sendNext:@(6)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal be disposable");
        }];
    }] replayLazily];
    
    
    [connection subscribeNext:^(id  _Nullable x) {
        NSLog(@"===%@",x);
    }];

//    [connection subscribeNext:^(id  _Nullable x) {
//        NSLog(@"---%@",x);
//    }];

//    [connection connect];
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


- (IBAction)didClickBtn:(id)sender {
    
    if (sender == self.normalManagerBtn) {
        [self testSubject];
    }
    
    if (sender == self.pageableManagerBtn) {
        [self testCommand];
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
