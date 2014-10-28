//
//  VSRouter.h
//  Spec
//
//  Created by linwaiwai on 10/24/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSRoute.h"
#import "VSMacro.h"
#import "VSComponentRoute.h"
#import "VSRegexRoute.h"

@protocol VSRouterViewController

// 内部数据格式
-(Class)objectMapperClass;

// 两个协议至少实现一个
@optional
-(void)setObject:(id)object;
-(void)setObjects:(id)objects;

@end

@interface VSRouter : NSObject

+ (VSRouter *)sharedInstance;
-(void)addRoute:(VSRoute *)route ;
- (void)route:(NSString *)urlPattern;

@end
