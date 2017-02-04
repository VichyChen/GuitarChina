//
//  GCNewPostThreadViewController.m
//  GuitarChina
//
//  Created by mac on 17/1/31.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewPostThreadViewController.h"
#import "GCNewPostThreadCell.h"

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

@end

@implementation GCNewPostThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Post Thread", nil);
    
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor whiteColor];
        
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
                    cell.titleLabel.text = dictionary[@"title"];
                    cell.textField.text = dictionary[@"value"];
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
                    cell.textField.text = dictionary[@"value"];
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
                    cell.titleLabel.text = dictionary[@"title"];
                    NSString *value = dictionary[@"value"];
                    cell.valueLabel.text = value.length > 0 ? value : @"请选择";
                    cell.valueLabel.textColor = [cell.valueLabel.text isEqualToString:@"请选择"] ? [GCColor placeHolderColor] : [GCColor fontColor];
                    void (^block)(void) = dictionary[@"block"];
                    cell.didSelectRowBlock = ^{
                        if (block) {
                            block();
                        }
                    };
                    break;
            }
            
            return cell;
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            @strongify(self);
            NSArray *array = [self.data objectAtIndex:indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            return [GCNewPostThreadCell getCellHeightWithDictionary:dictionary];
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            UIView *view = [[UIView alloc] init];
            if (section == 3) {
                view.frame = CGRectMake(0, 0, ScreenWidth, 13);
                view.backgroundColor = [GCColor backgroundColor];
            } else {
                view.frame = CGRectMake(0, 0, ScreenWidth, 0);
                view.backgroundColor = [UIColor clearColor];
            }
            
            return view;
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            if (section == 3) {
                return 13;
            } else {
                return 0.01;
            }
        };
        self.tableViewKit.viewForFooterInSectionBlock = ^(NSInteger section) {
            return [[UIView alloc] init];
        };
        self.tableViewKit.heightForFooterInSectionBlock = ^CGFloat(NSInteger section) {
            return 0.01f;
        };
        self.tableViewKit.didSelectRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            
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
                          @"value" : (self.sortid ? self.sortid : SortIDArray[0]),
                          @"block" : ^(NSInteger selectedIndex){@strongify(self); self.sortid = SortIDArray[selectedIndex];}}];
    NSArray *array1 = @[@{@"title" : @"品牌",
                          @"type" : @1,
                          @"value" : (self.sPinPai ? self.sPinPai : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sPinPai = text;}},
                        @{@"title" : @"型号",
                          @"type" : @1,
                          @"value" : (self.sXingHao ? self.sXingHao : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sXingHao = text;}},
                        @{@"title" : @"成色",
                          @"type" : @5,
                          @"dataArray" : ChengSeDataArray,
                          @"valueArray" : ChengSeValueArray,
                          @"value" : (self.sChengSe ? self.sChengSe : @""),
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
                          @"value" : (self.sTrade_num ? self.sTrade_num : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sTrade_num = text;}},
                        @{@"title" : @"价格",
                          @"type" : @1,
                          @"value" : (self.sJiaGe ? self.sJiaGe : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sJiaGe = text;}},
                        @{@"title" : @"详细描述",
                          @"type" : @3,
                          @"value" : (self.sXiangXi ? self.sXiangXi : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sXiangXi = text;}},
                        @{@"title" : @"姓名",
                          @"type" : @1,
                          @"value" : (self.sName ? self.sName : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sName = text;}},
                        @{@"title" : @"电话",
                          @"type" : @1,
                          @"value" : (self.sPhone ? self.sPhone : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sPhone = text;}},
                        @{@"title" : @"QQ",
                          @"type" : @1,
                          @"value" : (self.sQQ ? self.sQQ : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sQQ = text;}},
                        @{@"title" : @"电子邮件",
                          @"type" : @1,
                          @"value" : (self.sEmail ? self.sEmail : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sEmail = text;}},
                        @{@"title" : @"商品所在地",
                          @"type" : @1,
                          @"value" : (self.sAddress ? self.sAddress : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.sAddress = text;}},
                        @{@"title" : @"是否中介",
                          @"type" : @5,
                          @"dataArray" : ZhongJieDataArray,
                          @"valueArray" : ZhongJieValueArray,
                          @"value" : (self.sZhongJie ? self.sZhongJie : @""),
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
                          @"block" : ^(NSArray *array){@strongify(self); self.sFuKuangFangShi = array;}}];
    NSArray *array2 = @[@{@"title" : @"品牌",
                          @"type" : @1,
                          @"value" : (self.bPinPai ? self.bPinPai : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.bPinPai = text;}},
                        @{@"title" : @"成色",
                          @"type" : @5,
                          @"dataArray" : ChengSeDataArray,
                          @"valueArray" : ChengSeValueArray,
                          @"value" : (self.bChengSe ? self.bChengSe : @""),
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
                          @"value" : (self.bXingHao ? self.bXingHao : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.bXingHao = text;}},
                        @{@"title" : @"QQ",
                          @"type" : @1,
                          @"value" : (self.bQQ ? self.bQQ : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.bQQ = text;}},
                        @{@"title" : @"商品所在地",
                          @"type" : @1,
                          @"value" : (self.bAddress ? self.bAddress : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.bAddress = text;}}];
    NSArray *array3 = @[@{@"title" : @"标题",
                          @"type" : @2,
                          @"value" : (self.subject ? self.subject : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.subject = text;}},
                        @{@"title" : @"选择主题分类",
                          @"type" : @7,
                          @"value" : (self.selectedType ? self.selectedType : @""),
                          @"block" : ^{@strongify(self);        }},
                        @{@"title" : @"内容",
                          @"type" : @4,
                          @"value" : (self.message ? self.message : @""),
                          @"block" : ^(NSString *text){@strongify(self); self.message = text;}}];
    _data = @[array0, array1, array2, array3];
    return _data;
}
/*
 
 */
@end
