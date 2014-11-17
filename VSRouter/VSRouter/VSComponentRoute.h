//
//  VSComponentRoute.h
//  Spec
//
//  Created by linwaiwai on 10/27/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSRoute.h"

static NSString *const kJLRouteWildcardComponentsKey = @"JLRouteWildcardComponents";

@interface VSComponentRoute : VSRoute  <VSRoute>

-(NSDictionary*)match:(NSString *)path;



@end
