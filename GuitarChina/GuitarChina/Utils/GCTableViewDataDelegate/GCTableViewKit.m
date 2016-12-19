//
//  GCTableViewKit.m
//  TableDatasourceSeparation
//

#import "GCTableViewKit.h"

@interface GCTableViewKit ()


@end

@implementation GCTableViewKit

- (id)initWithSystem {
    self = [super init];
    if (self) {
        self.configureStyle = ConfigureStyleSystem;
    }
    
    return self;
}

- (id)initWithItems:(NSArray *)items
           cellType:(ConfigureCellType)cellType
     cellIdentifier:(NSString *)cellIdentifier {
    self = [super init];
    if (self) {
        self.configureStyle = ConfigureStyleCustom;
        self.configureCellType = cellType;
        self.items = items;
        self.cellIdentifier = cellIdentifier;
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(int)indexPath.row];
}

- (void)configureTableView:(UITableView *)tableView {
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.numberOfSectionsInTableViewBlock) {
        return self.numberOfSectionsInTableViewBlock();
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.configureStyle) {
        case ConfigureStyleSystem:
            if (self.numberOfRowsInSectionBlock) {
                self.numberOfRowsInSectionBlock(section);
            }
            break;
            
        case ConfigureStyleCustom:
            return self.items.count ;
            break;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.configureStyle) {
        case ConfigureStyleSystem:
        {
            if (self.cellForRowAtIndexPathBlock) {
                self.cellForRowAtIndexPathBlock(indexPath);
            }
        }
            break;
            
        case ConfigureStyleCustom:
        {
            id item = [self itemAtIndexPath:indexPath] ;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            if (!cell) {
                switch (self.configureCellType) {
                    case ConfigureCellTypeNib:
                        [tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil] forCellReuseIdentifier:self.cellIdentifier];
                        break;
                        
                    case ConfigureCellTypeClass:
                    {
                        [tableView registerClass:NSClassFromString(self.cellIdentifier) forCellReuseIdentifier:self.cellIdentifier];
                    }
                        break;
                }
                cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            }
            if (self.cellForRowBlock) {
                self.cellForRowBlock(indexPath, item, cell);
            }
            return cell;
        }
            break;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.configureStyle) {
        case ConfigureStyleSystem:
        {
            if (self.heightForRowAtIndexPathBlock) {
                return self.heightForRowAtIndexPathBlock(indexPath);
            }
        }
            break;
            
        case ConfigureStyleCustom:
        {
            id item = [self itemAtIndexPath:indexPath];
            if (self.heightForRowBlock) {
                return self.heightForRowBlock(indexPath, item);
            }
        }
            break;
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewForHeaderInSectionBlock) {
        self.viewForHeaderInSectionBlock(section);
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.viewForFooterInSectionBlock) {
        self.viewForFooterInSectionBlock(section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.heightForHeaderInSectionBlock) {
        self.heightForHeaderInSectionBlock(section);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.heightForFooterInSectionBlock) {
        self.heightForFooterInSectionBlock(section);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.configureStyle) {
        case ConfigureStyleSystem:
        {
            if (self.didSelectRowAtIndexPathBlock) {
                self.didSelectRowAtIndexPathBlock(indexPath);
            }
        }
            break;
            
        case ConfigureStyleCustom:
        {
            id item = [self itemAtIndexPath:indexPath];
            if (self.didSelectCellBlock) {
                self.didSelectCellBlock(indexPath,item);
            }
        }
            break;
    }
    
}

@end
