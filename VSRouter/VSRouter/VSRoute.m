//
//  VSRoute.m
//  Spec
//
//  Created by linwaiwai on 10/24/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "VSRoute.h"
@interface VSRoute ()



@end

@implementation VSRoute

- (id)initWithPattern:(NSString *)urlPattern handler:(BOOL (^)(VSRoute *route))handler{

    if (self = [super init]) {
        _priority = 0;
        if ([urlPattern rangeOfString:@"://"].location != NSNotFound) {
            NSURL *url = [NSURL URLWithString:urlPattern];
            _scheme = url.scheme;
            _pattern = [urlPattern substringFromIndex:(self.scheme.length + 2)];
        } else {
            _pattern = urlPattern;
        }
        _handler = [handler copy];
    }
    return self;
}


@end
