//
//  VSRoute.h
//  Spec
//
//  Created by linwaiwai on 10/24/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kRouteClass @"kRouteClass"

@protocol VSRoute

-(NSDictionary*)match:(NSString *)path;

@end

@interface VSRoute : NSObject

@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, strong) NSString * matched;
@property (nonatomic, strong, readonly) NSString * scheme;
@property (nonatomic, strong, readonly) NSString * pattern;
@property (nonatomic, strong, readonly) BOOL (^handler)(NSDictionary *parameters);

- (id)initWithPattern:(NSString *)urlPattern handler:(BOOL (^)(NSDictionary *parameters))handler;

@end
