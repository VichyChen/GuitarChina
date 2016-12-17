//
//  GCTableViewDataDelegate.h
//  TableDatasourceSeparation
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSInteger (^NumberOfSectionsBlock)(void);
typedef void (^CellForRowBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell);
typedef CGFloat (^HeightForRowBlock)(NSIndexPath *indexPath, id item);
typedef void (^DidSelectRowBlock)(NSIndexPath *indexPath, id item);

@interface GCTableViewDataDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NumberOfSectionsBlock numberOfSectionsBlock;
@property (nonatomic, copy) CellForRowBlock cellForRowBlock;
@property (nonatomic, copy) HeightForRowBlock heightForRowBlock;
@property (nonatomic, copy) DidSelectRowBlock didSelectCellBlock;


- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureTableView:(UITableView *)tableView;

@end
