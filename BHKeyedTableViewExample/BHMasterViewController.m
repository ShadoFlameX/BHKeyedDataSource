//
//  BHMasterViewController.m
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHMasterViewController.h"
#import "BHExampleDataSource.h"

@interface BHMasterViewController ()

@property (strong, nonatomic) BHExampleDataSource *dataSource;

@end

@implementation BHMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(toggleAddress)];

    self.dataSource = [[BHExampleDataSource alloc] init];
    self.dataSource.moreItems = @[@"Content", @"can", @"also", @"be", @"driven", @"by", @"data", @"collections"];
    self.tableView.dataSource = self.dataSource;
}

- (void)toggleAddress
{
    if (self.dataSource.showAddressSection) {
        NSUInteger section = [self.dataSource indexForSection:AddressSection];
        self.dataSource.showAddressSection = NO;
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];

    } else {
        self.dataSource.showAddressSection = YES;
        NSUInteger section = [self.dataSource indexForSection:AddressSection];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self.dataSource sectionInfoForIndexPath:indexPath];

    if ([sectionInfo[BHKeyedDataSourceSectionKey] isEqualToString:HeaderSection]) {
        return 90.0f;

    } else {
        return 44.0f;
    }
}

@end
