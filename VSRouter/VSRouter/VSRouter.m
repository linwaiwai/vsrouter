//
//  VSRouter.m
//  Spec
//
//  Created by linwaiwai on 10/24/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "VSRouter.h"

@interface VSRouter ()

@property(nonatomic, retain) NSMutableArray * routes;

@end

@implementation VSRouter

DECLARE_SINGLETON(VSRouter)


- (id)init{
    if (self = [super init]) {
        self.routes = [NSMutableArray array];
    }
    return self;
}



- (void)route:(NSString *)urlPattern withParams:(NSDictionary *)aParams {
    NSString *scheme = nil;
    NSString *pattern = nil;
    if ([urlPattern rangeOfString:@"://"].location != NSNotFound) {
        NSURL *url = [NSURL URLWithString:urlPattern];
        scheme = url.scheme;
        pattern = [urlPattern substringFromIndex:(scheme.length + 2)];
    } else {
        pattern = urlPattern;
    }
    for (VSRoute<VSRoute> * route in self.routes){
        // 这里要区分是否有scheme限定，没有限定的话则是所有协议都是监听到
        if (route.scheme) {
            if (scheme) {
                if (![route.scheme isEqualToString:scheme] ) {
                    continue;
                }
            } else {
                continue;
            }
            
        }
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[route match:pattern]];
        if (aParams) {
            [params addEntriesFromDictionary:aParams];
        }
        
        if ([params count] == 0) {
            continue ;
        }
        
        
        if (route.handler) {
            route.matched = urlPattern;
            route.params = params;
            if (self.mapper) {
                id object = self.mapper(route, params);
                route.object = object;
            }
            if ( !route.handler(route)){
                continue;
            } else {
                break;
            }
        } else {
            continue ;
        }
    }
}

- (void)route:(NSString *)urlPattern {
    [self route:urlPattern withParams:nil];
}

-(void)addRoute:(VSRoute *)route {
    if (route.priority == 0) {
        [self.routes addObject:route];
    } else {
        NSArray *existingRoutes = self.routes;
        NSUInteger index = 0;
        for (VSRoute *existingRoute in existingRoutes) {
            if (existingRoute.priority < route.priority) {
                [self.routes insertObject:route atIndex:index];
                break;
            }
            index++;
        }
    }
}

@end
