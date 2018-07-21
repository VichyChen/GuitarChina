//
//  GCDiscoveryPromptProView.m
//  GuitarChina
//
//  Created by mac on 2017/6/23.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCDiscoveryPromptProView.h"

@implementation GCDiscoveryPromptProView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(13, 6, 36, 36);
    imageView.image = [UIImage imageNamed:@"icon_new"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(54, 13, kScreenWidth - 26, 20);
    label.text = @"吉他中国Pro - 无广告清爽版 上线啦！";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [GCColor fontColor];
    [self addSubview:label];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kScreenWidth - 13 - 60 - 13 - 60, 46, 60, 28);
    button1.backgroundColor = [GCColor redColor];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 3;
    [button1 setTitle:@"前往" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(goToAppStore) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kScreenWidth - 13 - 60, 46, 60, 28);
    button2.backgroundColor = [UIColor whiteColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 3;
    button2.layer.borderColor = [GCColor redColor].CGColor;
    button2.layer.borderWidth = 1;
    [button2 setTitle:@"关闭" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
}

- (void)goToAppStore {
    [GCStatistics event:GCStatisticsEventDiscoveryGoToAppStore extra:nil];
    [Util openAppInAppStore:ProAppleID];
    [self close];
}

- (void)close {
    [GCStatistics event:GCStatisticsEventDiscoveryClose extra:nil];
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        [NSUD setObject:@1 forKey:kGCFirstPromptPro];
        [NSUD synchronize];
    }];
}

@end
