//
//  VSRegexRoute.m
//  Spec
//
//  Created by linwaiwai on 10/27/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "VSRegexRoute.h"

@interface VSRegexRoute ()

@property (nonatomic, retain) NSDictionary *map;
//-(NSDictionary *)mappedValue ;

@end


@implementation VSRegexRoute


- (id)initWithPattern:(NSString *)urlPattern map:(NSDictionary *)aMap handler:(BOOL (^)(VSRoute *route))handler{
    if (self = [super initWithPattern:urlPattern handler:handler]) {
        self.map = aMap;
    }
    return self;
}

- (NSDictionary*)match:(NSString *)url {
    NSString *pattern = [self.pattern stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* regex = [NSString stringWithFormat:@"^%@$", pattern];
    
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches =  [regexExpression matchesInString:url options:NSMatchingReportProgress range:NSMakeRange(0, [url length])];
    if (matches.count == 0) {
        return nil;
    }
    
    NSMutableArray * res = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSUInteger count =  [match numberOfRanges];
        // 跳过全局匹配
        for (NSUInteger i = 1 ; i < count; i++) {
            NSRange matchRange =  [match rangeAtIndex:i];
            [res  addObject:[url substringWithRange:matchRange]];
        }
    }
    
    
    return  [self mappedValue:res];
}


-(NSDictionary *)mappedValue:(NSArray *)values{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSUInteger i = 0;
    for (NSString *value in values  ) {
        NSNumber *key = [NSNumber numberWithInteger:i];
        if (self.map[key]) {
            NSString *index = self.map[key];
            [result setObject:value forKey:index];
        } else {
            [result setObject:value forKey:key];
            
        }
        i++;
        
    }
    
    return result;
}


@end
