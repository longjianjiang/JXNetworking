//
//  JXDemoCell.m
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoCell.h"

@interface JXDemoCell()

@property (nonatomic, strong) UILabel *msgLabel;
@end


NSString * const kJXDemoCellReuseIdentifier = @"kJXDemoCellReuseIdentifier";

@implementation JXDemoCell

- (void)updateMsg:(NSString *)msg {
    self.msgLabel.text = msg;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"create video item cell");
        
        [self.contentView addSubview:self.msgLabel];
        
        [[self.msgLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12] setActive:YES];
        [[self.msgLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12] setActive:YES];
    }
    return self;
}


#pragma mark - getter and setter
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        _msgLabel = [UILabel new];
        _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}
@end
