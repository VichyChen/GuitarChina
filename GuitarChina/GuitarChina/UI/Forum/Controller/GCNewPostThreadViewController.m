//
//  GCNewPostThreadViewController.m
//  GuitarChina
//
//  Created by mac on 17/1/31.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewPostThreadViewController.h"
#import "GCNewPostThreadCell.h"
#import "GCLoginPickerView.h"
#import "ZLPhoto.h"
#import "VCValidateUtil.h"

#define SortIDArray @[@"182", @"192"]
#define ChengSeDataArray @[@"9成新", @"8成新", @"7成新", @"6成新", @"5成新", @"4成新", @"3成新"]
#define ChengSeValueArray @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"]
#define ZhongJieDataArray @[@"是", @"否", @"无所谓"]
#define ZhongJieValueArray @[@"1", @"2", @"3"]
#define FuKuangFangShiDataArray @[@"中介", @"支付宝", @"银行汇款", @"现金面交", @"严禁先款"]
#define FuKuangFangShiValueArray @[@"1", @"2", @"3", @"4", @"5"]

@interface GCNewPostThreadViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, copy) NSArray *data;

@property (nonatomic, copy) NSString *sortid;

@property (nonatomic, copy) NSString *sPinPai;
@property (nonatomic, copy) NSString *sXingHao;
@property (nonatomic, copy) NSString *sChengSe;
@property (nonatomic, copy) NSString *sTrade_num;
@property (nonatomic, copy) NSString *sJiaGe;
@property (nonatomic, copy) NSString *sXiangXi;
@property (nonatomic, copy) NSString *sName;
@property (nonatomic, copy) NSString *sPhone;
@property (nonatomic, copy) NSString *sQQ;
@property (nonatomic, copy) NSString *sEmail;
@property (nonatomic, copy) NSString *sAddress;
@property (nonatomic, copy) NSString *sZhongJie;
@property (nonatomic, copy) NSArray *sFuKuangFangShi;

@property (nonatomic, copy) NSString *bPinPai;
@property (nonatomic, copy) NSString *bChengSe;
@property (nonatomic, copy) NSString *bXingHao;
@property (nonatomic, copy) NSString *bQQ;
@property (nonatomic, copy) NSString *bAddress;

@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *selectedType;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation GCNewPostThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布帖子";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.imageArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
    [self configureView];
}

- (void)dealloc {
    NSLog(@"GCNewPostThreadViewController dealloc");
}

- (void)configureView {
    [self.view addSubview:self.tableView];
}

- (void)sendAction {
    if (StringIsEmpty(self.subject)) {
        [self showAlertView:@"请输入标题！"];
        return;
    }
    if ([self.message trim].length < 8) {
        [self showAlertView:@"回复内容要多于8个字！"];
        return;
    }
    if (self.threadTypes && StringIsEmpty(self.selectedType)) {
        [self showAlertView:@"请选择帖子分类！"];
        return;
    }
    
    if (!self.threadTypes) {
        NSString *sortid = StringIfEmptyWithDefault(self.sortid, SortIDArray[0]);
        if ([sortid isEqualToString:SortIDArray[0]]) {
            if (StringIsEmpty(self.sPinPai)) {
                [self showAlertView:@"请输入品牌！"];
                return;
            }
            if (StringIsEmpty(self.sPinPai)) {
                [self showAlertView:@"请选择成色！"];
                return;
            }
            if (StringIsEmpty(self.sJiaGe)) {
                [self showAlertView:@"请输入价格！"];
                return;
            }
            if (StringIsEmpty(self.sXiangXi)) {
                [self showAlertView:@"请输入详细描述！"];
                return;
            }
            if (StringIsEmpty(self.sName)) {
                [self showAlertView:@"请输入姓名！"];
                return;
            }
            if (StringIsEmpty(self.sPhone)) {
                [self showAlertView:@"请输入电话！"];
                return;
            }
            if (StringIsEmpty(self.sAddress)) {
                [self showAlertView:@"请输入商品所在地！"];
                return;
            }
            if (!StringIsEmpty(self.sEmail) && ![VCValidateUtil isValidateEmail:String(self.sEmail)]) {
                [self showAlertView:@"请输入正确的邮箱格式！"];
                return;
            }
        }
        else if ([sortid isEqualToString:SortIDArray[1]]) {
            
        }
    }
    
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    @weakify(self);
    void (^postNewThreadBlock)(NSArray *, NSString *) = ^(NSArray *attachArray, NSString *posttime){
        @strongify(self);
        
        NSMutableDictionary *tableDictionary = [NSMutableDictionary dictionary];
        if (!self.threadTypes) {
            NSString *sortid = StringIfEmptyWithDefault(self.sortid, SortIDArray[0]);
            if ([sortid isEqualToString:SortIDArray[0]]) {
                [tableDictionary addEntriesFromDictionary:@{@"selectsortid" : sortid,
                                                            @"sortid" : sortid,
                                                            @"typeoption[pinpai]" : String(self.sPinPai),
                                                            @"typeoption[xinghao]" : String(self.sXingHao),
                                                            @"typeoption[chengse]" : StringIfEmptyWithDefault(self.sChengSe, ChengSeValueArray[0]),
                                                            @"typeoption[trade_num]" : String(self.sTrade_num),
                                                            @"typeoption[jiage]" : String(self.sJiaGe),
                                                            @"typeoption[xiangxi]" : String(self.sXiangXi),
                                                            @"typeoption[name]" : String(self.sName),
                                                            @"typeoption[phone]" : String(self.sPhone),
                                                            @"typeoption[QQ]" : String(self.sQQ),
                                                            @"typeoption[email1]" : String(self.sEmail),
                                                            @"typeoption[address]" : String(self.sAddress),
                                                            @"typeoption[zhongjie]" : StringIfEmptyWithDefault(self.sZhongJie, ZhongJieValueArray[2])}];
                if (ArrayHasObject(self.sFuKuangFangShi)) {
                    [tableDictionary setObject:[NSSet setWithArray:self.sFuKuangFangShi] forKey:@"typeoption[fukangfang][]"];
                } else {
                    [tableDictionary setObject:FuKuangFangShiValueArray[4] forKey:@"typeoption[fukangfang][]"];
                }
            }
            else if ([sortid isEqualToString:SortIDArray[1]]) {
                [tableDictionary addEntriesFromDictionary:@{@"selectsortid" : sortid,
                                                            @"sortid" : sortid,
                                                            @"typeoption[pinpai]" : String(self.bPinPai),
                                                            @"typeoption[chengse]" : StringIfEmptyWithDefault(self.bChengSe, ChengSeValueArray[0]),
                                                            @"typeoption[xinghao]" : String(self.bXingHao),
                                                            @"typeoption[QQ]" : String(self.bQQ),
                                                            @"typeoption[address]" : String(self.bAddress)}];
            }
        }
        
        [GCNetworkManager postWebNewThreadWithFid:self.fid typeid:self.selectedType subject:self.subject message:[self.message stringByAppendingString:kSuffix] attachArray:attachArray tableDictionary:tableDictionary posttime:posttime formhash:self.formhash success:^{
            @strongify(self);
            [SVProgressHUD showSuccessWithStatus:@"发帖成功"];
            [GCStatistics event:GCStatisticsEventPostThread extra:@{ @"fid" : self.fid, @"subjectText" : self.subject}];
            [self closeAction];
            
        } failure:^(NSError *error) {
            @strongify(self);
            [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    };
    
    [GCNetworkManager getWebNewThreadWithFid:self.fid sortid:self.sortid success:^(NSData *htmlData) {
        [GCHTMLParse parseWebNewThread:htmlData result:^(NSString *formhash, NSString *posttime) {
            @strongify(self);
            __block int tempCount = 0;
            NSMutableArray *attachArray = [NSMutableArray array];
            NSArray *imageArray = self.imageArray;
            NSUInteger imageCount = self.imageArray.count;
            
            if (imageCount > 0) {
                for (int i = 0; i < imageCount; i++) {
                    [GCNetworkManager postWebReplyImageWithFid:self.fid image:imageArray[i] formhash:formhash success:^(NSString *imageID) {
                        tempCount++;
                        [attachArray addObject:imageID];
                        if (tempCount == imageCount) {
                            postNewThreadBlock(attachArray, posttime);
                        }
                    } failure:^(NSError *error) {
                        @strongify(self);
                        [SVProgressHUD showErrorWithStatus:@"图片上传错误！"];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }];
                }
            } else {
                postNewThreadBlock(nil, posttime);
            }
        }];
    } failure:^(NSError *error) {
        @strongify(self);
        [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight) style:UITableViewStyleGrouped];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.separatorHorizontalInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin);
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithSystem];
        @weakify(self);
        self.tableViewKit.numberOfSectionsInTableViewBlock = ^NSInteger{
            @strongify(self);
            return self.data.count;
        };
        self.tableViewKit.numberOfRowsInSectionBlock = ^NSInteger(NSInteger section) {
            @strongify(self);
            NSArray *array = [self.data objectAtIndex:section];
            return array.count;
        };
        self.tableViewKit.cellForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            static NSString *identifier = @"GCNewPostThreadCell";
            GCNewPostThreadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[GCNewPostThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSArray *array = [self.data objectAtIndex:indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            NSNumber *cellStyle = dictionary[@"type"];
            cell.cellStyle = cellStyle.integerValue;
            switch (cell.cellStyle) {
                case GCNewPostThreadCellStyleSegmentedControl:
                {
                    cell.titleLabel.text = dictionary[@"title"];
                    NSArray *dataArray = dictionary[@"dataArray"];
                    [cell.segmentedControl removeAllSegments];
                    for (int i = 0; i < dataArray.count; i++) {
                        [cell.segmentedControl insertSegmentWithTitle:dataArray[i] atIndex:i animated:NO];
                    }
                    NSArray *valueArray = dictionary[@"valueArray"];
                    NSString *value = dictionary[@"value"];
                    for (int i = 0; i <valueArray.count; i++) {
                        if ([valueArray[i] isEqualToString:value]) {
                            cell.segmentedControl.selectedSegmentIndex = i;
                            break;
                        }
                    }
                    void (^block)(NSInteger selectedIndex) = dictionary[@"block"];
                    cell.segmentControlValueChangeBlock = ^(UISegmentedControl *segmentedControl) {
                        if (block) {
                            block(segmentedControl.selectedSegmentIndex);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleTextField:
                {
                    cell.textField.placeholder = @"请输入";
                    cell.titleLabel.text = dictionary[@"title"];
                    cell.textField.text = dictionary[@"value"];
                    cell.textField.keyboardType = ((NSNumber *)dictionary[@"keyboardType"]).integerValue;
                    void (^block)(NSString *text) = dictionary[@"block"];
                    cell.textFieldValueChangeBlock = ^(UITextField *textField) {
                        if (block) {
                            block(textField.text);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleOnlyTextField:
                {
                    cell.textField.placeholder = dictionary[@"title"];
                    cell.textField.text = dictionary[@"value"];
                    cell.textField.keyboardType = ((NSNumber *)dictionary[@"keyboardType"]).integerValue;
                    void (^block)(NSString *text) = dictionary[@"block"];
                    cell.textFieldValueChangeBlock = ^(UITextField *textField) {
                        if (block) {
                            block(textField.text);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleTextView:
                {
                    cell.titleLabel.text = dictionary[@"title"];
                    cell.textView.text = dictionary[@"value"];
                    
                    void (^block)(NSString *text) = dictionary[@"block"];
                    cell.textViewValueChangeBlock = ^(UITextView *textView) {
                        if (block) {
                            block(textView.text);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleOnlyTextView:
                {
                    cell.textView.text = dictionary[@"value"];
                    
                    void (^block)(NSString *text) = dictionary[@"block"];
                    cell.textViewValueChangeBlock = ^(UITextView *textView) {
                        if (block) {
                            block(textView.text);
                        }
                    };
                    @weakify(self);
                    cell.addImageBlock = ^{
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
                                    [self.imageArray addObject:asset.originImage];
                                }
                                [self.tableView reloadData];
                                if (self.tableView.contentOffset.y + self.tableView.frame.size.height < self.tableView.contentSize.height) {
                                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + (self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableView.frame.size.height)) animated:YES];
                                }
                            }
                        };
                        [controller showPickerVc:self];
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleRadioButton:
                {
                    cell.titleLabel.text = dictionary[@"title"];
                    NSArray *dataArray = dictionary[@"dataArray"];
                    NSArray *valueArray = dictionary[@"valueArray"];
                    NSString *value = dictionary[@"value"];
                    NSString *defaultValue = @"";
                    for (int i = 0; i < valueArray.count; i++) {
                        if ([valueArray[i] isEqualToString:value]) {
                            defaultValue = dataArray[i];
                        }
                    }
                    [cell setRadioButtonTitleArray:dataArray value:defaultValue];
                    void (^block)(NSString *text) = dictionary[@"block"];
                    cell.radioButtonSelectBlock = ^(UIButton *button) {
                        if (block) {
                            block(button.titleLabel.text);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleCheckButton:
                {
                    cell.titleLabel.text = dictionary[@"title"];
                    NSArray *dataArray = dictionary[@"dataArray"];
                    NSArray *valueArray = dictionary[@"valueArray"];
                    NSArray *value = dictionary[@"value"];
                    NSMutableArray *defaultValue = [NSMutableArray array];
                    for (NSString *string in value) {
                        for (int i = 0; i < valueArray.count; i++) {
                            if ([valueArray[i] isEqualToString:string]) {
                                [defaultValue addObject:dataArray[i]];
                            }
                        }
                    }
                    [cell setCheckButtonTitleArray:dataArray value:defaultValue];
                    void (^block)(NSArray *array) = dictionary[@"block"];
                    cell.checkButtonSelectBlock = ^(NSArray *buttonArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (UIButton *button in buttonArray) {
                            for (int i = 0; i < dataArray.count; i++) {
                                if ([button.titleLabel.text isEqualToString:dataArray[i]]) {
                                    [array addObject:valueArray[i]];
                                }
                            }
                        }
                        if (block) {
                            block(array);
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleLabelArrow:
                {
                    cell.titleLabel.text = dictionary[@"title"];
                    NSString *value = dictionary[@"value"];
                    if (value.length > 0) {
                        cell.valueLabel.text = dictionary[@"dictionary"][value];
                    } else {
                        cell.valueLabel.text = @"请选择";
                    }
                    cell.valueLabel.textColor = [cell.valueLabel.text isEqualToString:@"请选择"] ? [GCColor placeHolderColor] : [GCColor fontColor];
                    void (^block)(void) = dictionary[@"block"];
                    cell.didSelectRowBlock = ^{
                        if (block) {
                            block();
                        }
                    };
                }
                    break;
                    
                case GCNewPostThreadCellStyleCollectionView:
                {
                    NSArray *imageArray = dictionary[@"value"];
                    cell.imageArray = imageArray;
                    @weakify(self);
                    cell.deleteImageBlock = ^(NSInteger index) {
                        @strongify(self);
                        [self.imageArray removeObjectAtIndex:index];
                        [self.tableView reloadData];
                    };
                }
                    break;
            }
            
            return cell;
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            @strongify(self);
            NSArray *array = [self.data objectAtIndex:indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            
            if ([dictionary.allKeys containsObject:@"rowHeight"]) {
                CGFloat (^block)(void) = dictionary[@"rowHeight"];
                CGFloat height = block();
                return height;
            }
            
            if (self.threadTypes && (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 )) {
                return 0;
            }
            
            if (indexPath.section == 1 && [self.sortid isEqualToString:SortIDArray[1]]) {
                return 0;
            }
            if (indexPath.section == 2 && (!self.sortid || [self.sortid isEqualToString:SortIDArray[0]])) {
                return 0;
            }
            
            return [GCNewPostThreadCell getCellHeightWithDictionary:dictionary];
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            UIView *view = [[UIView alloc] init];
            if (section == 3) {
                view.frame = CGRectMake(0, 0, kScreenWidth, 13);
                view.backgroundColor = [GCColor backgroundColor];
            } else {
                view.frame = CGRectMake(0, 0, kScreenWidth, 0);
                view.backgroundColor = [UIColor clearColor];
            }
            
            return view;
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            if (section == 3 && !self.threadTypes) {
                return 13;
            } else {
                return 0.01;
            }
        };
        self.tableViewKit.viewForFooterInSectionBlock = ^(NSInteger section) {
            return [[UIView alloc] init];
        };
        self.tableViewKit.heightForFooterInSectionBlock = ^CGFloat(NSInteger section) {
            if (section == 0 && !self.threadTypes) {
                return 13;
            }
            return 0.01f;
        };
        self.tableViewKit.didSelectRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

#pragma mark - Getters

- (NSArray *)data {
    @weakify(self);
    NSArray *array0 = @[@{@"title" : @"发帖说明",
                          @"type" : @0,
                          @"dataArray" : @[@"诚意转让", @"我要求购"],
                          @"valueArray" : SortIDArray,
                          @"value" : StringIfEmptyWithDefault(self.sortid, SortIDArray[0]),
                          @"block" : ^(NSInteger selectedIndex){
                              @strongify(self);
                              self.sortid = SortIDArray[selectedIndex];
                              [self.tableView reloadData];
                          }}];
    NSArray *array1 = @[@{@"title" : @"品牌",
                          @"type" : @1,
                          @"value" : String(self.sPinPai),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sPinPai = text;
                          }},
                        @{@"title" : @"型号",
                          @"type" : @1,
                          @"value" : String(self.sXingHao),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sXingHao = text;
                          }},
                        @{@"title" : @"成色",
                          @"type" : @5,
                          @"dataArray" : ChengSeDataArray,
                          @"valueArray" : ChengSeValueArray,
                          @"value" : String(self.sChengSe),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              for (int i = 0; i < ChengSeDataArray.count; i++) {
                                  if ([ChengSeDataArray[i] isEqualToString:text]) {
                                      self.sChengSe = ChengSeValueArray[i];
                                  }
                              }
                          }
                          },
                        @{@"title" : @"数量",
                          @"type" : @1,
                          @"value" : String(self.sTrade_num),
                          @"keyboardType" : @(UIKeyboardTypeNumberPad),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sTrade_num = text;
                          }},
                        @{@"title" : @"价格",
                          @"type" : @1,
                          @"value" : String(self.sJiaGe),
                          @"keyboardType" : @(UIKeyboardTypeDecimalPad),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sJiaGe = text;
                          }},
                        @{@"title" : @"详细描述",
                          @"type" : @3,
                          @"value" : String(self.sXiangXi),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sXiangXi = text;
                          }},
                        @{@"title" : @"姓名",
                          @"type" : @1,
                          @"value" : String(self.sName),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sName = text;
                          }},
                        @{@"title" : @"电话",
                          @"type" : @1,
                          @"value" : String(self.sPhone),
                          @"keyboardType" : @(UIKeyboardTypePhonePad),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sPhone = text;
                          }},
                        @{@"title" : @"QQ",
                          @"type" : @1,
                          @"value" : String(self.sQQ),
                          @"keyboardType" : @(UIKeyboardTypeNumberPad),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sQQ = text;
                          }},
                        @{@"title" : @"电子邮件",
                          @"type" : @1,
                          @"value" : String(self.sEmail),
                          @"keyboardType" : @(UIKeyboardTypeEmailAddress),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sEmail = text;
                          }},
                        @{@"title" : @"商品所在地",
                          @"type" : @1,
                          @"value" : String(self.sAddress),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.sAddress = text;
                          }},
                        @{@"title" : @"是否中介",
                          @"type" : @5,
                          @"dataArray" : ZhongJieDataArray,
                          @"valueArray" : ZhongJieValueArray,
                          @"value" : String(self.sZhongJie),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              for (int i = 0; i < ZhongJieDataArray.count; i++) {
                                  if ([ZhongJieDataArray[i] isEqualToString:text]) {
                                      self.sZhongJie = ZhongJieValueArray[i];
                                  }
                              }
                          }
                          },
                        @{@"title" : @"付款方式",
                          @"type" : @6,
                          @"dataArray" : FuKuangFangShiDataArray,
                          @"valueArray" : FuKuangFangShiValueArray,
                          @"value" : (self.sFuKuangFangShi ? self.sFuKuangFangShi : @[]),
                          @"block" : ^(NSArray *array){
                              @strongify(self);
                              self.sFuKuangFangShi = array;
                          }}];
    NSArray *array2 = @[@{@"title" : @"品牌",
                          @"type" : @1,
                          @"value" : String(self.bPinPai),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.bPinPai = text;
                          }},
                        @{@"title" : @"成色",
                          @"type" : @5,
                          @"dataArray" : ChengSeDataArray,
                          @"valueArray" : ChengSeValueArray,
                          @"value" : String(self.bChengSe),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              for (int i = 0; i < ChengSeDataArray.count; i++) {
                                  if ([ChengSeDataArray[i] isEqualToString:text]) {
                                      self.bChengSe = ChengSeValueArray[i];
                                  }
                              }
                          }
                          },
                        @{@"title" : @"型号",
                          @"type" : @1,
                          @"value" : String(self.bXingHao),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.bXingHao = text;
                          }},
                        @{@"title" : @"QQ",
                          @"type" : @1,
                          @"value" : String(self.bQQ),
                          @"keyboardType" : @(UIKeyboardTypeNumberPad),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.bQQ = text;
                          }},
                        @{@"title" : @"商品所在地",
                          @"type" : @1,
                          @"value" : String(self.bAddress),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.bAddress = text;
                          }}];
    NSArray *array3 = @[@{@"title" : @"请输入标题",
                          @"type" : @2,
                          @"value" : String(self.subject),
                          @"keyboardType" : @(UIKeyboardTypeDefault),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.subject = text;
                          }},
                        @{@"title" : @"选择主题分类",
                          @"type" : @7,
                          @"dictionary" : self.threadTypes ? self.threadTypes : @{},
                          @"value" : String(self.selectedType),
                          @"block" : ^{
                              @strongify(self);
                              if (!self.threadTypes) {
                                  return;
                              }
                              [self.view endEditing:YES];
                              
                              GCLoginPickerView *questionPickerView = [[GCLoginPickerView alloc] init];
                              questionPickerView.array = self.threadTypes.allValues;
                              questionPickerView.okActionBlock = ^(NSInteger index){
                                  @strongify(self);
                                  NSString *value = self.threadTypes.allValues[index];
                                  for (NSString *key in self.threadTypes.allKeys) {
                                      if ([self.threadTypes[key] isEqualToString:value]) {
                                          self.selectedType = key;
                                          break;
                                      }
                                  }
                                  [self.tableView reloadData];
                              };
                              [questionPickerView showInView:self.view];
                          },
                          @"rowHeight" : ^CGFloat {
                              @strongify(self);
                              if (self.threadTypes) {
                                  return 44.0;
                              } else {
                                  return 0.0;
                              }
                          }},
                        @{@"title" : @"内容",
                          @"type" : @4,
                          @"value" : String(self.message),
                          @"block" : ^(NSString *text){
                              @strongify(self);
                              self.message = text;
                          }}];
    NSArray *array4 = @[@{@"type" : @8,
                          @"value" : (self.imageArray.count > 0 ? self.imageArray : @[])}];
    _data = @[array0, array1, array2, array3, array4];
    return _data;
}

@end
