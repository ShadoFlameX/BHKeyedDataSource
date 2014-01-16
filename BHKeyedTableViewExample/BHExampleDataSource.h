//
//  BHExampleDataSource.h
//  BHKeyedTableViewExample
//
//  Created by Bryan Hansen on 1/16/14.
//  Copyright (c) 2014 Bryan Hansen. All rights reserved.
//

#import "BHKeyedDataSource.h"

extern NSString * const HeaderSection;
extern NSString * const NameSection;
extern NSString * const AddressSection;
extern NSString * const ContactSection;
extern NSString * const MoreSection;

@interface BHExampleDataSource : BHKeyedDataSource

@property (copy, nonatomic) NSArray *moreItems;
@property (assign, nonatomic) BOOL showAddressSection;

@end
