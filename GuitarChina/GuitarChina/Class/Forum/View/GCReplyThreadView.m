//
//  GCReplyThreadView.m
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReplyThreadView.h"
#import "GCAddImageCell.h"
#import "ZLPhoto.h"

#define AddImage @"upload_img"

@interface GCReplyThreadView() <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ZLPhotoPickerBrowserViewControllerDelegate, ZLPhotoPickerBrowserViewControllerDataSource>

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
    GCAddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GCAddImageCell" forIndexPath:indexPath];
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
        ZLPhotoPickerViewController *controller = [[ZLPhotoPickerViewController alloc] init];
        controller.status = PickerViewShowStatusCameraRoll;
        if ([[self.array objectAtIndex:self.array.count - 1] isKindOfClass:[NSString class]]) {
            controller.maxCount = 8 - (self.array.count - 1);
        } else {
            controller.maxCount = 8;
        }
        controller.callBack = ^(id obj) {
            @strongify(self);
            if ([obj isKindOfClass:[NSArray class]]) {
                for (ZLPhotoAssets *asset in obj) {
//                    [self.array insertObject:UIImageJPEGRepresentation(asset.originImage, 0.1) atIndex:0];
                    [self.array insertObject:asset.originImage atIndex:0];
                }
                if (self.array.count == 9) {
                    [self.array removeObjectAtIndex:8];
                }
                [self.collectionView reloadData];
            }
        };
        [controller showPickerVc:self.viewController];
        
    } else {
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        pickerBrowser.delegate = self;
        pickerBrowser.dataSource = self;
        //是否可以删除照片
        pickerBrowser.editing = YES;
        pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        //当前选中的值
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
        [pickerBrowser showPickerVc:self.viewController];
    }
}

#pragma mark - ZLPhotoPickerBrowserViewControllerDataSource

- (long)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    if ([[self.array objectAtIndex:self.array.count - 1] isKindOfClass:[NSString class]]) {
        return self.array.count - 1;
    } else {
        return self.array.count;
    }
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[self.array objectAtIndex:indexPath.row]];
    
    return photo;
}

#pragma mark - ZLPhotoPickerBrowserViewControllerDelegate

//删除照片
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.array count]) {
        return;
    }
    [self.array removeObjectAtIndex:indexPath.row];
    if (![[self.array objectAtIndex:self.array.count - 1] isKindOfClass:[NSString class]]) {
        [self.array addObject:AddImage];
    }
    [self.collectionView reloadData];
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
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
        [_collectionView registerClass:[GCAddImageCell class] forCellWithReuseIdentifier:@"GCAddImageCell"];
    }
    return _collectionView;
}

- (NSArray *)imageArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.array];
    if ([[array lastObject] isKindOfClass:[NSString class]]) {
        [array removeLastObject];
    }
    return array;
}

@end
