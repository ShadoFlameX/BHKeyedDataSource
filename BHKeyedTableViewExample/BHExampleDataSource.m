//
//  BHExampleDataSource.m
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHExampleDataSource.h"

NSString * const NameSection = @"Name";
NSString * const AddressSection = @"Address";
NSString * const ContactSection = @"Contact";

static NSString * const FirstNameRow = @"FirstName";
static NSString * const MiddleNameRow = @"MiddleName";
static NSString * const LastNameRow = @"LastName";

static NSString * const StreetRow = @"Street";
static NSString * const CityRow = @"City";
static NSString * const StateRow = @"State";

static NSString * const EmailRow = @"Email";
static NSString * const PhoneRow = @"Phone";

static NSString * const CellIdentifier = @"Cell";

@implementation BHExampleDataSource

#pragma mark - Properties

- (void)setShowAddressSection:(BOOL)showAddressSection
{
    if (_showAddressSection == showAddressSection) return;

    _showAddressSection = showAddressSection;

    if (_showAddressSection) {
        [self insertSection:AddressSection atIndex:[self indexForSection:NameSection] + 1 withRows:@[StreetRow, CityRow, StateRow]];

    } else {
        [self removeSection:AddressSection];
    }
}

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self) {
        [self addSection:NameSection withRows:@[FirstNameRow, MiddleNameRow, LastNameRow]];
        [self addSection:ContactSection withRows:@[EmailRow, PhoneRow]];

        self.showAddressSection = YES;
    }
    return self;
}

#pragma mark - TableView Content

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSString *)rowKey inSection:(NSString *)sectionKey atIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }

    if ([sectionKey isEqualToString:NameSection]) {
        if ([rowKey isEqualToString:FirstNameRow]) {
            cell.textLabel.text = @"First Name";
            cell.detailTextLabel.text = @"Bryan";

        } else if ([rowKey isEqualToString:MiddleNameRow]) {
            cell.textLabel.text = @"Middle Name";
            cell.detailTextLabel.text = @"E";

        } else if ([rowKey isEqualToString:LastNameRow]) {
            cell.textLabel.text = @"Last Name";
            cell.detailTextLabel.text = @"Hansen";
        }
    }

    if ([sectionKey isEqualToString:AddressSection]) {
        if ([rowKey isEqualToString:StreetRow]) {
            cell.textLabel.text = @"Street";
            cell.detailTextLabel.text = @"123 Oak St";

        } else if ([rowKey isEqualToString:CityRow]) {
            cell.textLabel.text = @"City";
            cell.detailTextLabel.text = @"San Francisco";

        } else if ([rowKey isEqualToString:StateRow]) {
            cell.textLabel.text = @"State";
            cell.detailTextLabel.text = @"California";
        }
    }

    if ([sectionKey isEqualToString:ContactSection]) {
        if ([rowKey isEqualToString:EmailRow]) {
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = @"bryanehansen@gmail.com";

        } else if ([rowKey isEqualToString:PhoneRow]) {
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = @"800-555-1212";
        }
    }

    return cell;
}

@end
