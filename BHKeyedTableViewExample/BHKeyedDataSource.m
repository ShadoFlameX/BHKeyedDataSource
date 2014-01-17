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
    [self addSection:sectionKey];

    [rowKeys enumerateObjectsUsingBlock:^(NSString *rowKey, NSUInteger idx, BOOL *stop) {
        [self addRow:rowKey inSection:sectionKey];
    }];
}

- (void)insertSection:(NSString *)sectionKey atIndex:(NSUInteger)index withRows:(NSArray *)rowKeys
{
    [self insertSection:sectionKey atIndex:index];

    [rowKeys enumerateObjectsUsingBlock:^(NSString *rowKey, NSUInteger idx, BOOL *stop) {
        [self addRow:rowKey inSection:sectionKey];
    }];
}

- (void)addSection:(NSString *)sectionKey
{
    [self insertSection:sectionKey atIndex:self.sectionKeys.count];
}

- (void)insertSection:(NSString *)sectionKey atIndex:(NSUInteger)index
{
    NSParameterAssert(sectionKey);
    NSAssert([self.sectionKeys containsObject:sectionKey] == NO, @"Section key already exists: %@", sectionKey);
    [self.sectionKeys insertObject:sectionKey atIndex:index];
}

- (void)removeSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);
    NSAssert([self.sectionKeys containsObject:sectionKey], @"Section key does not exist: %@", sectionKey);
    [self.sectionKeys removeObject:sectionKey];
    [self.rowKeysBySection removeObjectForKey:sectionKey];
}

- (void)removeAllSections
{
    [self.sectionKeys removeAllObjects];
    [self.rowKeysBySection removeAllObjects];
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

    NSAssert([rowKeys containsObject:rowKey] == NO, @"Row key: %@ already exists in section: %@", rowKey, sectionKey);
    [rowKeys insertObject:rowKey atIndex:index];
}

- (void)removeRow:(NSString *)rowKey inSection:(NSString *)sectionKey
{
    NSParameterAssert(rowKey);
    NSParameterAssert(sectionKey);
    NSAssert([self.sectionKeys containsObject:sectionKey], @"Section key does not exist: %@", sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    NSAssert([rowKeys containsObject:rowKey], @"Row key: %@ does not exist in section: %@", rowKey, sectionKey);
    [rowKeys removeObject:sectionKey];
}

- (void)removeAllRowsInSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);
    NSAssert([self.sectionKeys containsObject:sectionKey], @"Section key does not exist: %@", sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    [rowKeys removeAllObjects];
}

- (NSUInteger)indexForSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);
    return [self.sectionKeys indexOfObject:sectionKey];
}

- (NSIndexPath *)indexPathForRow:(NSString *)rowKey inSection:(NSString *)sectionKey
{
    NSParameterAssert(rowKey);
    NSParameterAssert(sectionKey);
    NSAssert([self.sectionKeys containsObject:sectionKey], @"Section key does not exist: %@", sectionKey);

    NSInteger sectionIndex = [self.sectionKeys indexOfObject:sectionKey];

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    NSAssert([rowKeys containsObject:rowKey], @"Row key: %@ does not exist in section: %@", rowKey, sectionKey);

    NSInteger rowIndex = [rowKeys indexOfObject:rowKey];

    return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
}

- (NSString *)sectionForSectionIndex:(NSInteger)sectionIndex
{
    NSAssert(sectionIndex < self.sectionKeys.count, @"Invalid section for sectionIndex");
    return self.sectionKeys[sectionIndex];
}

- (NSDictionary *)sectionInfoForIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section < self.sectionKeys.count, @"Invalid section for indexPath");

    NSString *sectionKey = self.sectionKeys[indexPath.section];
    NSOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    NSString *rowKey = indexPath.row < rowKeys.count ? rowKeys[indexPath.row] : nil;

    NSMutableDictionary *sectionInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    sectionInfo[BHKeyedDataSourceSectionKey] = sectionKey;
    if (rowKey) sectionInfo[BHKeyedDataSourceRowKey] = rowKey;

    return sectionInfo;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWithKey:(NSString *)sectionKey
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
    return [self tableView:tableView numberOfRowsInSectionWithKey:self.sectionKeys[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self sectionInfoForIndexPath:indexPath];
    return [self tableView:tableView cellForRow:sectionInfo[BHKeyedDataSourceRowKey] inSection:sectionInfo[BHKeyedDataSourceSectionKey] atIndexPath:indexPath];
}

@end
