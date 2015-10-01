//
//  GCThreadRightMenuViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadRightMenuViewController.h"
#import "GCThreadRightMenuCell.h"

#define GCThreadRightMenuCellHeightIniPhone 50
#define GCThreadRightMenuCellHeightIniPad 60

@interface GCThreadRightMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation GCThreadRightMenuViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = @[NSLocalizedString(@"Reply", nil),
                        NSLocalizedString(@"Collect", nil),
                        NSLocalizedString(@"Share", nil),
                        NSLocalizedString(@"Report", nil),
                        NSLocalizedString(@"Open in Safari", nil),
                        NSLocalizedString(@"Copy url", nil)];
        _imageArray = @[@"icon_reply", @"icon_collect", @"icon_share", @"icon_report", @"icon_open", @"icon_copy"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.tableView];
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
    if (cell == nil) {
        cell = [[GCThreadRightMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.iconImageView.image = [[UIImage imageNamed:self.imageArray[indexPath.row]] imageWithTintColor:[UIColor blackColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
            break;
            
        case 2:
            break;
            
        case 3:
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DeviceiPhone) {
        return GCThreadRightMenuCellHeightIniPhone;
    } else {
        return GCThreadRightMenuCellHeightIniPad;
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (_tableView == nil) {
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
    }
    return _tableView;
}

@end
