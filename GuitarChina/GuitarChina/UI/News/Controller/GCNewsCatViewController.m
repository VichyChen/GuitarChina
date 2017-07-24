//
//  GCNewsCatViewController.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsCatViewController.h"
#import "GCNewsCatLeftMenuCell.h"
#import "GCNewsCatRightMenuCell.h"
#import "GCNewsCatListViewController.h"

@interface GCNewsCatViewController ()

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) GCTableViewKit *leftTableViewKit;

@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) GCTableViewKit *rightTableViewKit;

@property (nonatomic, copy) NSArray *menuArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation GCNewsCatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    
    [self configureView];
}

- (void)configureView {
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}

- (void)refresh:(NSArray<GCNewsMenuModel *> *)menuArray {
    self.menuArray = menuArray;
    
    if (menuArray.count > 0) {
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.backgroundColor = [GCColor backgroundColor];
        _leftTableView.frame = CGRectMake(0, 0, 120, ScreenHeight - 64 - 48);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        [_leftTableView initFooterView];

        self.leftTableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCNewsCatLeftMenuCell"];
        @weakify(self);
        [self.leftTableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.menuArray;
        }];
        self.leftTableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCNewsCatLeftMenuCell *newsCatLeftMenuCell = (GCNewsCatLeftMenuCell *)cell;
            GCNewsMenuModel *model = (GCNewsMenuModel *)item;
            newsCatLeftMenuCell.titleLabel.text = model.value;
        };
        self.leftTableViewKit.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
            return 44;
        };
        self.leftTableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            self.selectIndex = indexPath.row;
            [self.rightTableView reloadData];
        };
        [self.leftTableViewKit configureTableView:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.frame = CGRectMake(self.leftTableView.frame.size.width, 0, ScreenWidth - self.leftTableView.frame.size.width, ScreenHeight - 64 - 48);
        _rightTableView.leftSeparatorInset = 13;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView initFooterView];

        self.rightTableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCNewsCatRightMenuCell"];
        @weakify(self);
        [self.rightTableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            if (self.menuArray.count > 0) {
                GCNewsMenuModel *model = self.menuArray[self.selectIndex];
                NSMutableArray *array = [NSMutableArray arrayWithArray:model.subMenuArray];
                [array insertObject:model atIndex:0];
                return array;
            } else {
                return [NSMutableArray array];
            }
        }];
        self.rightTableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCNewsCatRightMenuCell *newsCatRightMenuCell = (GCNewsCatRightMenuCell *)cell;
            GCNewsMenuModel *model = (GCNewsMenuModel *)item;
            newsCatRightMenuCell.titleLabel.text = model.value;
            newsCatRightMenuCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        };
        self.rightTableViewKit.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
            return 44;
        };
        self.rightTableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.rightTableView deselectRowAtIndexPath:indexPath animated:YES];
            
            GCNewsMenuModel *model = (GCNewsMenuModel *)item;

            GCNewsCatListViewController *controller = [[GCNewsCatListViewController alloc] init];
            controller.title = model.value;
            controller.catID = model.catID;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.rightTableViewKit configureTableView:_rightTableView];
    }
    return _rightTableView;
}


@end
