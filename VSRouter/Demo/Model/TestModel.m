//
//  TestModel.m
//  VSRouter
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (NSSet *)propertiesForJson {
    return [NSSet setWithObject:@"test"];
}
- (NSDictionary *)propertiesMap{
    return @{@"test": @"test"};
}

@end
