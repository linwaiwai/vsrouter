//
//  VSRegexRoute.h
//  Spec
//
//  Created by linwaiwai on 10/27/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSRoute.h"
@interface VSRegexRoute : VSRoute<VSRoute>

- (id)initWithPattern:(NSString *)urlPattern map:(NSDictionary *)map handler:(BOOL (^)(NSDictionary *parameters))handler;

@end
