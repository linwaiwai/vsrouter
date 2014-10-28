//
//  VSComponentRoute.m
//  Spec
//
//  Created by linwaiwai on 10/27/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "VSComponentRoute.h"

static BOOL shouldDecodePlusSymbols = YES;

@interface NSString (JLRoutes)

- (NSString *)JLRoutes_URLDecodedString;
- (NSDictionary *)JLRoutes_URLParameterDictionary;

@end


@implementation NSString (JLRoutes)

- (NSString *)JLRoutes_URLDecodedString {
    NSString *input = shouldDecodePlusSymbols ? [self stringByReplacingOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, self.length)] : self;
    return [input stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)JLRoutes_URLParameterDictionary {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.length && [self rangeOfString:@"="].location != NSNotFound) {
        NSArray *keyValuePairs = [self componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in keyValuePairs) {
            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
            // don't assume we actually got a real key=value pair. start by assuming we only got @[key] before checking count
            NSString *paramValue = pair.count == 2 ? pair[1] : @"";
            // CFURLCreateStringByReplacingPercentEscapesUsingEncoding may return NULL
            parameters[pair[0]] = [paramValue JLRoutes_URLDecodedString] ?: @"";
        }
    }
    
    return parameters;
}

@end

@interface VSComponentRoute ()

@property (nonatomic, strong) NSArray *patternPathComponents;

@end

@implementation VSComponentRoute


- (NSDictionary*)match:(NSString *)url {
    NSDictionary *routeParameters = nil;
    NSURL *URL =  [NSURL URLWithString:url];
    
    NSArray *URLComponents = [(URL.pathComponents ?: @[]) filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF like '/'"]];
    
    if ([URL.host rangeOfString:@"."].location == NSNotFound && ![URL.host isEqualToString:@"localhost"]) {
        // For backward compatibility, handle scheme://path/to/ressource as if path was part of the
        // path if it doesn't look like a domain name (no dot in it)
        URLComponents = [@[URL.host] arrayByAddingObjectsFromArray:URLComponents];
    }
    
    if (!self.patternPathComponents) {
        self.patternPathComponents = [[self.pattern pathComponents] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF like '/'"]];
    }
   
    
    // do a quick component count check to quickly eliminate incorrect patterns
    BOOL componentCountEqual = self.patternPathComponents.count == URLComponents.count;
    BOOL routeContainsWildcard = !NSEqualRanges([self.pattern rangeOfString:@"*"], NSMakeRange(NSNotFound, 0));
    if (componentCountEqual || routeContainsWildcard) {
        // now that we've identified a possible match, move component by component to check if it's a match
        NSUInteger componentIndex = 0;
        NSMutableDictionary *variables = [NSMutableDictionary dictionary];
        BOOL isMatch = YES;
        
        for (NSString *patternComponent in self.patternPathComponents) {
            NSString *URLComponent = nil;
            if (componentIndex < [URLComponents count]) {
                URLComponent = URLComponents[componentIndex];
            } else if ([patternComponent isEqualToString:@"*"]) { // match /foo by /foo/*
                URLComponent = [URLComponents lastObject];
            }
            
            if ([patternComponent hasPrefix:@":"]) {
                // this component is a variable
                NSString *variableName = [patternComponent substringFromIndex:1];
                NSString *variableValue = URLComponent;
                if ([variableName length] > 0 && [variableValue length] > 0) {
                    variables[variableName] = [variableValue JLRoutes_URLDecodedString];
                }
            } else if ([patternComponent isEqualToString:@"*"]) {
                // match wildcards
                variables[kJLRouteWildcardComponentsKey] = [URLComponents subarrayWithRange:NSMakeRange(componentIndex, URLComponents.count-componentIndex)];
                isMatch = YES;
                break;
            } else if (![patternComponent isEqualToString:URLComponent]) {
                // a non-variable component did not match, so this route doesn't match up - on to the next one
                isMatch = NO;
                break;
            }
            componentIndex++;
        }
        
        if (isMatch) {
            routeParameters = variables;
        }
    }
    
    return routeParameters;
 
}

@end
