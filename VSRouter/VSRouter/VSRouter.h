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

@required
-(Class)objectMapperClass;// 内部数据格式
-(void)setObjects:(id)objects;// 内部的数据为对象，那么objects中只有一个

@end


typedef id (^MapperBlock) (VSRoute *route, NSDictionary *params);

@interface VSRouter : NSObject

@property (nonatomic, strong) MapperBlock mapper;// 可以使用自动转换器

+ (VSRouter *)sharedInstance;
-(void)addRoute:(VSRoute *)route ;
- (void)route:(NSString *)urlPattern;
- (void)route:(NSString *)urlPattern withParams:(NSDictionary *)aParams;


@end
