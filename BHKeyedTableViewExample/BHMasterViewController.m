//
//  BHMasterViewController.m
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHMasterViewController.h"
#import "BHDetailViewController.h"
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

    self.dataSource = [[BHExampleDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
}

@end
