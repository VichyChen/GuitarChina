//
//  GCForumIndexViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexViewController.h"
#import "GCForumDisplayViewController.h"
#import "GCForumIndexCell.h"
#import "GCForumIndexCollectionViewCell.h"
#import "GCForumIndexCollectionReusableView.h"

@interface GCForumIndexViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumIndexViewController

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
        
    self.title = NSLocalizedString(@"Forum", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    return model.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    return [model.forums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCForumIndexCell";
    GCForumIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCForumIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    cell.model = forumModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    view.backgroundColor = [GCColor backgroundColor];
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    UILabel *label = [UIView createLabel:CGRectMake(15, 0, ScreenWidth, 35)
                                    text:[NSString stringWithFormat:@"%@", model.name]
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[GCColor blueColor]];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *heightArray = [self.rowHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    NSNumber *number = [heightArray objectAtIndex:indexPath.row];
    return [number floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    controller.title = forumModel.name;
    controller.fid = forumModel.fid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //记录论坛浏览记录
    NSMutableArray *array = [NSMutableArray arrayWithArray:([NSUD arrayForKey:kGCForumBrowseRecord] ? [NSUD arrayForKey:kGCForumBrowseRecord] : @[])];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:forumModel.fid]) {
            //移除原有浏览记录
            [array removeObjectAtIndex:i];
            break;
        }
    }
    [array insertObject:forumModel.fid atIndex:0];
    array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, array.count >= 5 ? 5 : array.count)]];
    [NSUD setObject:array forKey:kGCForumBrowseRecord];
    [NSUD synchronize];
}

*/

#pragma mark - UICollectionView Delegate/dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.data count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    return [model.forums count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCForumIndexCollectionViewCell *cell = (GCForumIndexCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GCForumIndexCollectionViewCell" forIndexPath:indexPath];
    
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    
    NSString *title = forumModel.name;
    title = [title replace:@"&amp;" toNewString:@"&"];
//    cell.titleLabel.text = title;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    if (![forumModel.todayposts isEqualToString:@"0"]) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)", forumModel.todayposts] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [GCColor grayColor2] }]];
    }
    cell.titleLabel.attributedText = string;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
//    return [GCForumIndexCollectionViewCell getCellHeight:forumGroupModel.forums];
    if (indexPath.section == self.data.count - 1 && indexPath.row == forumGroupModel.forums.count - 1) {
        return CGSizeMake((ScreenWidth - 13 * 3) / 2, 55);
    } else {
        return CGSizeMake((ScreenWidth - 13 * 3) / 2, 40);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        GCForumIndexCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GCForumIndexCollectionReusableView" forIndexPath:indexPath];
        GCForumGroupModel *model = [self.data objectAtIndex:indexPath.section];
        reusableView.titleLabel.text = model.name;
        
        return reusableView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 44);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 13, 0, 13);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 13;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 13;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    controller.title = forumModel.name;
    controller.fid = forumModel.fid;
    [self.navigationController pushViewController:controller animated:YES];
    
    //记录论坛浏览记录
    NSMutableArray *array = [NSMutableArray arrayWithArray:([NSUD arrayForKey:kGCForumBrowseRecord] ? [NSUD arrayForKey:kGCForumBrowseRecord] : @[])];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:forumModel.fid]) {
            //移除原有浏览记录
            [array removeObjectAtIndex:i];
            break;
        }
    }
    [array insertObject:forumModel.fid atIndex:0];
    array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, array.count >= 5 ? 5 : array.count)]];
    [NSUD setObject:array forKey:kGCForumBrowseRecord];
    [NSUD synchronize];
}

#pragma mark - HTTP

- (void)getForumIndex {
    @weakify(self);
    [GCNetworkManager getForumIndexSuccess:^(GCForumIndexArray *array) {
        @strongify(self);
        self.data = array.data;
        
        //增加最近浏览分类
        //最近浏览记录
        NSArray *browseArray = [NSMutableArray arrayWithArray:([NSUD arrayForKey:kGCForumBrowseRecord] ? [NSUD arrayForKey:kGCForumBrowseRecord] : @[])];
        if (browseArray.count > 0) {
            GCForumGroupModel *forumGroupModel = [[GCForumGroupModel alloc] init];
            forumGroupModel.fid = @"0";
            forumGroupModel.name = @"最近浏览";
            forumGroupModel.forums = [NSMutableArray arrayWithArray:browseArray];
            for (GCForumGroupModel *tempForumGroupModel in array.data) {
                for (GCForumModel *tempForumModel in tempForumGroupModel.forums) {
                    if ([browseArray containsObject:tempForumModel.fid]) {
                        for (int i = 0; i < browseArray.count; i++) {
                            if ([browseArray[i] isEqualToString:tempForumModel.fid]) {
                                [forumGroupModel.forums replaceObjectAtIndex:i withObject:[tempForumModel copy]];
                                //                                    ((GCForumModel *)forumGroupModel.forums[i]).todayposts = @"0";
                                break;
                            }
                        }
                    }
                }
            }
            [self.data insertObject:forumGroupModel atIndex:0];
        }
        
        for (int i = 0; i < self.data.count; i++) {
            GCForumGroupModel *model = (GCForumGroupModel *)self.data[i];
            NSMutableArray *heightArray = [NSMutableArray array];
            for (GCForumModel *forumModel in model.forums) {
                [heightArray addObject: [NSNumber numberWithFloat:[GCForumIndexCell getCellHeightWithModel:forumModel]]];
            }
        }
        
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _collectionView.backgroundColor = [GCColor backgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"GCForumIndexCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GCForumIndexCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"GCForumIndexCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GCForumIndexCollectionReusableView"];

        _collectionView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getForumIndex)];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
    }
    return _collectionView;
}

@end
