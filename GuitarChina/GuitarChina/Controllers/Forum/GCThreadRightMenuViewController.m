//
//  GCThreadRightMenuViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadRightMenuViewController.h"
#import "GCThreadRightMenuCell.h"
#import "GCReplyThreadViewController.h"
#import "GCNavigationController.h"
#import "GCThreadRightMenuCollectionCell.h"

#define GCThreadRightMenuCellHeightIniPhone 55
#define GCThreadRightMenuCellHeightIniPad 55

@interface GCThreadRightMenuViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation GCThreadRightMenuViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = @[NSLocalizedString(@"Reply", nil),
                        NSLocalizedString(@"Collect", nil),
                        NSLocalizedString(@"Share", nil),
                        NSLocalizedString(@"Open in Safari", nil),
                        NSLocalizedString(@"Copy URL", nil),
                        NSLocalizedString(@"Report", nil)];
        _imageArray = @[@"icon_reply", @"icon_collect", @"icon_share", @"icon_compass", @"icon_link", @"icon_error"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GCThreadRightMenuCell";
    GCThreadRightMenuCell *cell = (GCThreadRightMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GCThreadRightMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.iconImageView.image = [[UIImage imageNamed:self.imageArray[indexPath.row]] imageWithTintColor:[UIColor GCRedColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0: {
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_REPLY object:nil];
            break;
        }
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_COLLECT object:nil];
            break;
            
        case 2:
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_SHARE object:nil];
            break;
            
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_SAFARI object:nil];
            break;

        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_COPYURL object:nil];
            break;

        case 5:
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_REPORT object:nil];
            break;

        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DeviceiPhone) {
        return GCThreadRightMenuCellHeightIniPad;
    } else {
        return GCThreadRightMenuCellHeightIniPad;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titleArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadRightMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GCThreadRightMenuCollectionCell" forIndexPath:indexPath];
//    [self.titleArray objectAtIndex:indexPath.item]
    cell.backgroundView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 50) / 4, (ScreenWidth - 50) / 4);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame;
        if (DeviceiPhone) {
            frame = CGRectMake(ScreenWidth - (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone), (ScreenHeight - GCThreadRightMenuCellHeightIniPhone * self.titleArray.count) / 2, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone, GCThreadRightMenuCellHeightIniPhone * self.titleArray.count);
        } else {
            frame = CGRectMake(ScreenWidth - (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad), (ScreenHeight - GCThreadRightMenuCellHeightIniPad * self.titleArray.count) / 2, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad, GCThreadRightMenuCellHeightIniPad * self.titleArray.count);
        }
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, ScreenWidth / 2, ScreenWidth - 10, 10 + (ScreenWidth - 50) / 4) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GCThreadRightMenuCollectionCell class] forCellWithReuseIdentifier:@"GCThreadRightMenuCollectionCell"];
    }
    
    return _collectionView;
}


@end
