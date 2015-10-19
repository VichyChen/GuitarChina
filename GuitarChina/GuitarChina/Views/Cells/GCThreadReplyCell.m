//
//  GCThreadReplyCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadReplyCell.h"

@interface GCThreadReplyCell() <UIWebViewDelegate>


@end

@implementation GCThreadReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configureView];
        self.messageWebViewHeight = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.authorLabel.frame = CGRectMake(15, 10, ScreenWidth - 30, 20);
    [self.authorLabel sizeToFit];
    self.datelineLabel.frame = CGRectMake(15 + self.authorLabel.frame.size.width, 10, ScreenWidth - self.authorLabel.frame.size.width - 30, 20);
    self.numberLabel.frame = CGRectMake(15, 10, ScreenWidth - 30, 20);
    
//    self.messageWebView.frame = CGRectMake(15, 40, ScreenWidth - 30, self.messageWebViewHeight);
//    [self.messageWebView sizeToFit];

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    NSLog(@"%ld", self.indexPath.row);
    //    self.messageWebViewHeight = self.messageWebView.scrollView.contentSize.height;
    //    self.messageWebView.frame = CGRectMake(15, 40, ScreenWidth - 30, self.messageWebViewHeight);
    //    NSLog(@"%.f",self.messageWebViewHeight);
    
    self.messageWebViewHeight = [[self.messageWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    NSLog(@"%.f", self.messageWebViewHeight);
    NSLog(@"%.f", self.messageWebView.scrollView.contentSize.height);

    self.messageWebView.frame = CGRectMake(15, 40, ScreenWidth - 30, self.messageWebViewHeight
                                           );
//    self.ReloadAction(self.indexPath, self.messageWebViewHeight);
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCThreadDetailPostModel *)model {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth - 30, 1)];
    webView.dataDetectorTypes = UIDataDetectorTypeLink;
    [webView loadHTMLString:model.message baseURL:nil];
    
    
    return 200 + 50;
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
//    [self.contentView addSubview:self.messageWebView];
    [self.contentView addSubview:self.numberLabel];
}

#pragma mark - Setters

- (void)setModel:(GCThreadDetailPostModel *)model {
    _model = model;
    
    self.authorLabel.text = model.author;
    self.datelineLabel.text = model.dateline;
    self.numberLabel.text = model.number;
//    self.messageWebView.delegate = self;
//    [self.messageWebView loadHTMLString:model.message baseURL:nil];
}

#pragma mark - Getters

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor GCFontColor]];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                        text:@""
                                        font:[UIFont systemFontOfSize:14]
                                   textColor:[UIColor GCDeepGrayColor]];
    }
    return _datelineLabel;
}

- (UIWebView *)messageWebView {
    if (!_messageWebView) {
        _messageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth - 30, 1)];
        _messageWebView.dataDetectorTypes = UIDataDetectorTypeLink;
        _messageWebView.scrollView.scrollEnabled = NO;
//        _messageWebView.delegate = self;
    }
    return _messageWebView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:15]
                                 textColor:[UIColor GCFontColor]];
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
}

//- (DTAttributedTextContentView *)testView {
//    if (!_testView) {
//        _testView = [[DTAttributedTextContentView alloc] init];
//        _testView.frame = CGRectMake(15, 40, ScreenWidth - 30, 100);
//        _testView.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//        _testView.shouldDrawImages = YES;
//        _testView.delegate = self;
//    }
//    return _testView;
//}


@end
