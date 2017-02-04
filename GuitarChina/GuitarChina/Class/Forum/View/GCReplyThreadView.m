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
#define ImageViewWidth ((ScreenWidth - 10 * 4) / 3)

@interface GCReplyThreadView() <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ZLPhotoPickerBrowserViewControllerDelegate, ZLPhotoPickerBrowserViewControllerDataSource>

@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation GCReplyThreadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        [self configureView];
        [self configureFrame];
        
        @weakify(self);
        [self.scrollView bk_whenTapped:^{
            @strongify(self);
            [self.textView becomeFirstResponder];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNC removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)configureView {
    [self addSubview:self.scrollView];
    [self addSubview:self.toolBarView];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.collectionView];
}

- (void)configureFrame {
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height - 44);
    self.toolBarView.frame = CGRectMake(0, self.frame.size.height - 44, ScreenWidth, 44);
    self.textView.frame = CGRectMake(6, 0, ScreenWidth - 12, 100);
    self.collectionView.frame = CGRectMake(0, self.textView.frame.size.height, ScreenWidth, [self calculateCollectionViewHeight]);
    
    CGFloat scrollViewContentSizeHeight = self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 10;
    if (scrollViewContentSizeHeight <= self.scrollView.frame.size.height) {
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.frame.size.height + 1);
    } else {
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, scrollViewContentSizeHeight);
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat textViewHeight = [self calculateTextViewHeightWithText:self.textView.text];
    if (textViewHeight > 100) {
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, textViewHeight);
    } else {
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, 100);
    }
    self.collectionView.frame = CGRectMake(0, self.textView.frame.size.height, ScreenWidth, [self calculateCollectionViewHeight]);

    [self updateScrollViewContentSizeWithoutKeyboard];
    [self updateScrollViewContentOffset];
}

- (void)updateScrollViewContentOffset {
    NSInteger index = self.textView.selectedRange.location;
    NSString *string = [self.textView.text substring:0 length:index];
    CGFloat textHeight = [self calculateTextViewHeightWithText:string] - self.scrollView.contentOffset.y;
    if (textHeight + self.keyboardHeight > self.scrollView.frame.size.height) {
        NSLog(@"%.f", self.scrollView.contentOffset.y);
        CGFloat contentOffsetY = self.scrollView.contentOffset.y + (textHeight + self.keyboardHeight - self.scrollView.frame.size.height);
        [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY)];

//        [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
//        [UIView animateWithDuration:0.1 delay:0.15 options:0 animations:^{
//            [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY)];
//        } completion:^(BOOL finished) {
//            
//        }];
//        NSLog(@"%.f", self.scrollView.contentOffset.y);
    }
}

- (void)updateScrollViewContentSizeWithoutKeyboard {
    CGFloat scrollViewContentSizeHeight = self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 10;
    if (scrollViewContentSizeHeight <= self.scrollView.frame.size.height) {
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.frame.size.height + 1);
    } else {
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, scrollViewContentSizeHeight);
    }
}

- (CGFloat)calculateTextViewHeightWithText:(NSString *)text {
    UITextView *textView = [[UITextView alloc] init];
    textView.text = text;
    textView.font = [UIFont systemFontOfSize:16];
    return [textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, 9999)].height;
}

- (CGFloat)calculateCollectionViewHeight {
    if (self.imageArray.count == 0) {
        return 0;
    } else {
        return self.imageArray.count / 3 * (ImageViewWidth + 10) + (self.imageArray.count % 3 == 0 ? 0 : (ImageViewWidth + 10)) + 10;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    self.keyboardHeight = keyboardRect.size.height ;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height + self.keyboardHeight);

    CGFloat delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self updateScrollViewContentOffset];
    });

    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.toolBarView.frame = CGRectMake(0, self.frame.size.height - 44 - self.keyboardHeight, ScreenWidth, 44);

    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self updateScrollViewContentSizeWithoutKeyboard];
    
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.toolBarView.frame = CGRectMake(0, self.frame.size.height - 44, ScreenWidth, 44);

    [UIView commitAnimations];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCAddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GCAddImageCell" forIndexPath:indexPath];
    cell.imageView.image = [self.imageArray objectAtIndex:indexPath.row];
    @weakify(self);
    cell.deleteActionBlock = ^{
        @strongify(self);
        [self.imageArray removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
        self.collectionView.frame = CGRectMake(0, self.textView.frame.size.height, ScreenWidth, [self calculateCollectionViewHeight]);
        [self updateScrollViewContentSizeWithoutKeyboard];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageViewWidth, ImageViewWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.textView resignFirstResponder];

//    if ([[self.array objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
//        @weakify(self);
//        ZLPhotoPickerViewController *controller = [[ZLPhotoPickerViewController alloc] init];
//        controller.status = PickerViewShowStatusCameraRoll;
//        if ([[self.array objectAtIndex:self.array.count - 1] isKindOfClass:[NSString class]]) {
//            controller.maxCount = 8 - (self.array.count - 1);
//        } else {
//            controller.maxCount = 8;
//        }
//        controller.callBack = ^(id obj) {
//            @strongify(self);
//            if ([obj isKindOfClass:[NSArray class]]) {
//                for (ZLPhotoAssets *asset in obj) {
////                    [self.array insertObject:UIImageJPEGRepresentation(asset.originImage, 0.1) atIndex:0];
//                    [self.array insertObject:asset.originImage atIndex:0];
//                }
//                if (self.array.count == 9) {
//                    [self.array removeObjectAtIndex:8];
//                }
//                [self.collectionView reloadData];
//            }
//        };
//        [controller showPickerVc:self.viewController];
//        
//    } else {
//        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
//        pickerBrowser.delegate = self;
//        pickerBrowser.dataSource = self;
//        //是否可以删除照片
//        pickerBrowser.editing = YES;
//        pickerBrowser.status = UIViewAnimationAnimationStatusFade;
//        //当前选中的值
//        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//        [pickerBrowser showPickerVc:self.viewController];
//    }
}

#pragma mark - ZLPhotoPickerBrowserViewControllerDataSource

- (long)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    if ([[self.imageArray objectAtIndex:self.imageArray.count - 1] isKindOfClass:[NSString class]]) {
        return self.imageArray.count - 1;
    } else {
        return self.imageArray.count;
    }
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[self.imageArray objectAtIndex:indexPath.row]];
    
    return photo;
}

#pragma mark - ZLPhotoPickerBrowserViewControllerDelegate

//删除照片
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.imageArray count]) {
        return;
    }
    [self.imageArray removeObjectAtIndex:indexPath.row];
    if (![[self.imageArray objectAtIndex:self.imageArray.count - 1] isKindOfClass:[NSString class]]) {
        [self.imageArray addObject:AddImage];
    }
    [self.collectionView reloadData];
}


#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UIView createTextView:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.scrollEnabled = NO;
        _textView.placeholder = NSLocalizedString(@"Write reply.", nil);
        _textView.delegate = self;
 }
    return _textView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GCAddImageCell class] forCellWithReuseIdentifier:@"GCAddImageCell"];
        [_collectionView bk_whenTapped:^{

        }];
    }
    return _collectionView;
}

- (GCReplyPostThreadToolBarView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[GCReplyPostThreadToolBarView alloc] init];
        @weakify(self);
        _toolBarView.selectImageBlock = ^{
            @strongify(self);
            if (self.imageArray.count == 9) {
                return;
            }
            ZLPhotoPickerViewController *controller = [[ZLPhotoPickerViewController alloc] init];
            controller.status = PickerViewShowStatusCameraRoll;
            controller.maxCount = 9 - self.imageArray.count;
            controller.callBack = ^(id obj) {
                @strongify(self);
                if ([obj isKindOfClass:[NSArray class]]) {
                    for (ZLPhotoAssets *asset in obj) {
                        //[self.array insertObject:UIImageJPEGRepresentation(asset.originImage, 0.1) atIndex:0];
                        //[self.array insertObject:asset.originImage atIndex:0];
                        [self.imageArray addObject:asset.originImage];
                    }
                    [self.collectionView reloadData];
                    self.collectionView.frame = CGRectMake(0, self.textView.frame.size.height, ScreenWidth, [self calculateCollectionViewHeight]);
                    [self updateScrollViewContentSizeWithoutKeyboard];
                }
            };
            [controller showPickerVc:self.viewController];
        };
    }
    return _toolBarView;
}

@end
