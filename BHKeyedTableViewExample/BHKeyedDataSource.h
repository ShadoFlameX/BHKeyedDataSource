//
//  BHKeyedDataSource.h
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * BHKeyedDataSourceSectionKey;
extern NSString * BHKeyedDataSourceRowKey;

@interface BHKeyedDataSource : NSObject <UITableViewDataSource>

// TableView Content

- (void)addSection:(NSString *)sectionKey;
- (void)insertSection:(NSString *)sectionKey atIndex:(NSUInteger)index;
- (void)removeSection:(NSString *)sectionKey;
- (void)removeAllSections;

- (void)addRow:(NSString *)rowKey inSection:(NSString *)sectionKey;
- (void)insertRow:(NSString *)rowKey atIndex:(NSUInteger)index inSection:(NSString *)sectionKey;
- (void)removeRow:(NSString *)rowKey inSection:(NSString *)sectionKey;
- (void)removeAllRowsInSection:(NSString *)sectionKey;

- (NSDictionary *)sectionInfoForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfRowsInSection:(NSString *)sectionKey;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSString *)rowKey section:(NSString *)sectionKey atIndexPath:(NSIndexPath *)indexPath;

@end
