//
//  GCTableViewKit.h
//  TableDatasourceSeparation
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableViewCell+Extension.h"
#import "UIScrollView+Extension.h"
#import "UITableView+Extention.h"

typedef NS_ENUM(NSInteger, ConfigureStyle) {
    ConfigureStyleSystem,
    ConfigureStyleCustom
};

typedef NS_ENUM(NSInteger, ConfigureCellType) {
    ConfigureCellTypeNib,
    ConfigureCellTypeClass
};

@interface GCTableViewKit : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) ConfigureStyle configureStyle;

//Custom
@property (nonatomic, assign) ConfigureCellType configureCellType;
@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSArray *(^getItemsBlock)(void);
@property (nonatomic, copy) void (^cellForRowBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell);
@property (nonatomic, copy) CGFloat (^heightForRowBlock)(NSIndexPath *indexPath, id item);
@property (nonatomic, copy) void (^didSelectCellBlock)(NSIndexPath *indexPath, id item);

//System
//UITableViewDataSource
@property (nonatomic, copy) NSInteger (^numberOfSectionsInTableViewBlock)(void);
@property (nonatomic, copy) NSInteger (^numberOfRowsInSectionBlock)(NSInteger section);
@property (nonatomic, copy) UITableViewCell *(^cellForRowAtIndexPathBlock)(NSIndexPath *indexPath);
//UITableViewDelegate
@property (nonatomic, copy) CGFloat (^heightForRowAtIndexPathBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) UIView *(^viewForHeaderInSectionBlock)(NSInteger section);
@property (nonatomic, copy) CGFloat (^heightForHeaderInSectionBlock)(NSInteger section);
@property (nonatomic, copy) UIView *(^viewForFooterInSectionBlock)(NSInteger section);
@property (nonatomic, copy) CGFloat (^heightForFooterInSectionBlock)(NSInteger section);
@property (nonatomic, copy) void (^didSelectRowAtIndexPathBlock)(NSIndexPath *indexPath);

- (id)initWithSystem;

- (id)initWithCellType:(ConfigureCellType)cellType
        cellIdentifier:(NSString *)cellIdentifier;

- (void)configureTableView:(UITableView *)tableView;

@end
