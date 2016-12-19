//
//  GCTableViewKit.h
//  TableDatasourceSeparation
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableViewCell+Extension.h"

typedef NS_ENUM(NSInteger, ConfigureStyle) {
    ConfigureStyleSystem,
    ConfigureStyleCustom
};

typedef NS_ENUM(NSInteger, ConfigureCellType) {
    ConfigureCellTypeNib,
    ConfigureCellTypeClass
};


//UITableViewDataSource
typedef NSInteger (^NumberOfSectionsInTableViewBlock)(void);
typedef NSInteger (^NumberOfRowsInSectionBlock)(NSInteger section);
typedef UITableViewCell* (^CellForRowAtIndexPathBlock)(NSIndexPath *indexPath);
//UITableViewDelegate
typedef CGFloat (^HeightForRowAtIndexPathBlock)(NSIndexPath *indexPath);
typedef UIView* (^ViewForHeaderInSectionBlock)(NSInteger section);
typedef CGFloat (^HeightForHeaderInSectionBlock)(NSInteger section);
typedef UIView* (^ViewForFooterInSectionBlock)(NSInteger section);
typedef CGFloat (^HeightForFooterInSectionBlock)(NSInteger section);
typedef void (^DidSelectRowAtIndexPathBlock)(NSIndexPath *indexPath);
//Custom
typedef void (^CellForRowBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell);
typedef CGFloat (^HeightForRowBlock)(NSIndexPath *indexPath, id item);
typedef void (^DidSelectRowBlock)(NSIndexPath *indexPath, id item);


@interface GCTableViewKit : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) ConfigureStyle configureStyle;

//Custom
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) ConfigureCellType configureCellType;
@property (nonatomic, copy) NSString *cellIdentifier;

//UITableViewDataSource
@property (nonatomic, copy) NumberOfSectionsInTableViewBlock numberOfSectionsInTableViewBlock;
@property (nonatomic, copy) NumberOfRowsInSectionBlock numberOfRowsInSectionBlock;
@property (nonatomic, copy) CellForRowAtIndexPathBlock cellForRowAtIndexPathBlock;
//UITableViewDelegate
@property (nonatomic, copy) HeightForRowAtIndexPathBlock heightForRowAtIndexPathBlock;
@property (nonatomic, copy) ViewForHeaderInSectionBlock viewForHeaderInSectionBlock;
@property (nonatomic, copy) HeightForHeaderInSectionBlock heightForHeaderInSectionBlock;
@property (nonatomic, copy) ViewForFooterInSectionBlock viewForFooterInSectionBlock;
@property (nonatomic, copy) HeightForFooterInSectionBlock heightForFooterInSectionBlock;
@property (nonatomic, copy) DidSelectRowAtIndexPathBlock didSelectRowAtIndexPathBlock;
//Custom
@property (nonatomic, copy) CellForRowBlock cellForRowBlock;
@property (nonatomic, copy) HeightForRowBlock heightForRowBlock;
@property (nonatomic, copy) DidSelectRowBlock didSelectCellBlock;

- (id)initWithSystem;

- (id)initWithItems:(NSArray *)items
           cellType:(ConfigureCellType)cellType
     cellIdentifier:(NSString *)cellIdentifier;

- (void)configureTableView:(UITableView *)tableView;

@end
