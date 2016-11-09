//
//  GCReplyThreadView.m
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReplyThreadView.h"
#import "GCReplyAddImageCell.h"

#define AddImage @"upload_img"

@interface GCReplyThreadView() <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GCReplyThreadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureView];
        [self configureFrame];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)configureView {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.placeholderLabel];
    [self.scrollView addSubview:self.separatorView];
    [self.scrollView addSubview:self.collectionView];
}

- (void)configureFrame {
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 + 1);
    self.textView.frame = CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight / 3);
    self.placeholderLabel.frame = CGRectMake(15, 18, 200, 20);
    self.separatorView.frame = CGRectMake(10, self.textView.frame.origin.y + self.textView.frame.size.height - 1, ScreenWidth - 20, 0.5);
    self.collectionView.frame = CGRectMake(0, self.textView.frame.origin.y + self.textView.frame.size.height, ScreenWidth, ((ScreenWidth - 10 * 5) / 4) * 2 + 30);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCReplyAddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GCReplyAddImageCell" forIndexPath:indexPath];
    if ([[self.array objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]) {
        cell.imageView.image = [self.array objectAtIndex:indexPath.row];
    } else {
        cell.imageView.image = [UIImage imageNamed:AddImage];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 10 * 5) / 4, (ScreenWidth - 10 * 5) / 4);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.textView resignFirstResponder];

    if ([[self.array objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        @weakify(self);
        [APP selectImage:self.viewController success:^(UIImage *image, NSDictionary *info) {
            @strongify(self);
            [self.array insertObject:image atIndex:self.array.count - 1];
            [self.collectionView reloadData];
        }];
    } else {
        
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textViewChange];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textViewChange];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewChange];
}

#pragma mark - Event Responses

#pragma mark - Private Methods

- (void)textViewChange {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    
    return _scrollView;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
        [_array addObject:AddImage];
    }
    
    return _array;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UIView createTextView:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UIView createLabel:CGRectZero
                                           text:NSLocalizedString(@"Write reply.", nil)
                                           font:[UIFont systemFontOfSize:16] textColor:[GCColor grayColor3]];
    }
    return _placeholderLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [GCColor separatorLineColor];
    }
    
    return _separatorView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GCReplyAddImageCell class] forCellWithReuseIdentifier:@"GCReplyAddImageCell"];
    }
    return _collectionView;
}

@end
