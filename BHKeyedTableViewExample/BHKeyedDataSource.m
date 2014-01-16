//
//  BHKeyedDataSource.m
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHKeyedDataSource.h"

NSString * BHKeyedDataSourceSectionKey = @"section";
NSString * BHKeyedDataSourceRowKey = @"row";


@interface BHKeyedDataSource ()

@property (strong, nonatomic, readonly) NSMutableOrderedSet *sectionKeys;
@property (strong, nonatomic, readonly) NSMutableDictionary *rowKeysBySection;

@end

@implementation BHKeyedDataSource

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self) {
        _sectionKeys = [NSMutableOrderedSet orderedSet];
        _rowKeysBySection = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - TableView Content

- (void)addSection:(NSString *)sectionKey withRows:(NSArray *)rowKeys
{
    NSParameterAssert(sectionKey);
    [self.sectionKeys addObject:sectionKey];

    [rowKeys enumerateObjectsUsingBlock:^(NSString *rowKey, NSUInteger idx, BOOL *stop) {
        [self addRow:rowKey inSection:sectionKey];
    }];
}

- (void)insertSection:(NSString *)sectionKey atIndex:(NSUInteger)index withRows:(NSArray *)rowKeys
{
    NSParameterAssert(sectionKey);
    [self.sectionKeys insertObject:sectionKey atIndex:index];

    [rowKeys enumerateObjectsUsingBlock:^(NSString *rowKey, NSUInteger idx, BOOL *stop) {
        [self addRow:rowKey inSection:sectionKey];
    }];
}

- (void)addSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);
    [self.sectionKeys addObject:sectionKey];
}

- (void)insertSection:(NSString *)sectionKey atIndex:(NSUInteger)index
{
    NSParameterAssert(sectionKey);
    [self.sectionKeys insertObject:sectionKey atIndex:index];
}

- (void)removeSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);
    [self.sectionKeys removeObject:sectionKey];
}

- (void)removeAllSections
{
    [self.sectionKeys removeAllObjects];
}

- (NSUInteger)indexForSection:(NSString *)sectionKey
{
    return [self.sectionKeys indexOfObject:sectionKey];
}

- (void)addRow:(NSString *)rowKey inSection:(NSString *)sectionKey
{
    NSUInteger index = ((NSMutableOrderedSet *)self.rowKeysBySection[sectionKey]).count;
    [self insertRow:rowKey atIndex:index inSection:sectionKey];
}

- (void)insertRow:(NSString *)rowKey atIndex:(NSUInteger)index inSection:(NSString *)sectionKey
{
    NSParameterAssert(rowKey);
    NSParameterAssert(sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    if (rowKeys == nil) {
        rowKeys = [NSMutableOrderedSet orderedSet];
        self.rowKeysBySection[sectionKey] = rowKeys;
    }

    [rowKeys insertObject:rowKey atIndex:index];
}

- (void)removeRow:(NSString *)rowKey inSection:(NSString *)sectionKey
{
    NSParameterAssert(rowKey);
    NSParameterAssert(sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    [rowKeys removeObject:sectionKey];
}

- (void)removeAllRowsInSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    [rowKeys removeAllObjects];
}

- (NSUInteger)indexForRow:(NSString *)rowKey inSection:(NSString *)sectionKey
{
    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    return [rowKeys indexOfObject:rowKey];
}

- (NSDictionary *)sectionInfoForIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = self.sectionKeys[indexPath.section];
    NSString *rowKey = ((NSOrderedSet *)self.rowKeysBySection[sectionKey])[indexPath.row];

    return @{BHKeyedDataSourceRowKey: rowKey,
             BHKeyedDataSourceSectionKey: sectionKey};
}

- (NSInteger)numberOfRowsInSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    return rowKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSString *)rowKey inSection:(NSString *)sectionKey atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"BHKeyedDataSource subclass must implement tableView:cellForRowKey:sectionKey:atIndexPath:");
    return nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[self.sectionKeys[section]];
    return rowKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self sectionInfoForIndexPath:indexPath];
    return [self tableView:tableView cellForRow:sectionInfo[BHKeyedDataSourceRowKey] inSection:sectionInfo[BHKeyedDataSourceSectionKey] atIndexPath:indexPath];
}

@end
