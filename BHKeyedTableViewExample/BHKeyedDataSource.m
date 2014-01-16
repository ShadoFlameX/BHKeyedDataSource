//
//  BHKeyedDataSource.m
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHKeyedDataSource.h"

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

    [rowKeys addObject:rowKey];
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

- (NSInteger)numberOfRowsInSection:(NSString *)sectionKey
{
    NSParameterAssert(sectionKey);

    NSMutableOrderedSet *rowKeys = self.rowKeysBySection[sectionKey];
    return rowKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowKey:(NSString *)rowKey sectionKey:(NSString *)sectionKey atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"BHKeyedDataSource subclass must implement tableView:cellForRowKey:sectionKey:");
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
    NSString *sectionKey = self.sectionKeys[indexPath.section];
    NSString *rowKey = ((NSOrderedSet *)self.rowKeysBySection[sectionKey])[indexPath.row];

    return [self tableView:tableView cellForRowKey:rowKey sectionKey:sectionKey atIndexPath:indexPath];
}

@end
