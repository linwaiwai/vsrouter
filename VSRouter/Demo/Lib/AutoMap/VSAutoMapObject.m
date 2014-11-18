
#import "VSAutoMapObject.h"
@implementation NSString (charValue)

-(const char *)charValue{
    const char *value = [self cStringUsingEncoding:NSUTF8StringEncoding];
    return value;
}
@end


static NSString const *CLASS_KEY = @"__class";

@implementation NSObject(VSAutoMapObject)

+ (id)modelWithJson:(NSDictionary *)json {
    NSObject<VSAutoMapDelegate>  *model = [[self alloc] init];
    [model loadFromJson:json];
    
#if !__has_feature(objc_arc)
    return [model autorelease];
#else
    return model;
#endif
}



- (NSSet *)propertiesForJson {
    return [NSSet set];
}

-(NSDictionary *) propertiesMap{
    return nil;
}

-(NSDictionary *) propertyClassMap{
    return nil;
}

-(NSDictionary *)internalSupportFormat{
    return @{
             @"NSDate":@"timeStamp:"
             };
}

-(NSDate *)timeStamp:(id)value{
    if (value) {
        if ([value isKindOfClass:[NSString class]]) {
            return [NSDate dateWithTimeIntervalSince1970:[(NSString *)value intValue] ];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)value intValue] ];
        }
        return  nil;
    }
    return nil;
}


- (void)loadProperty:(NSString *)prop with:(NSString *)p fromJson:(NSDictionary *)json {
    if (![json.allKeys containsObject:p]) {
        return;
    }
    id value = [json objectForKey:p];
    if ([value isKindOfClass:[NSArray class]]) {
        BOOL flag = NO;
        NSMutableArray *list = [NSMutableArray array];
        for (id v in value) {
            if ([v isKindOfClass:[NSDictionary class]]) {
                NSString *c = [v objectForKey:CLASS_KEY];
                if (!c){
                    c = [[self propertyClassMap] objectForKey:prop];
                }
                Class clazz = NSClassFromString(c);
                if (clazz) {
                    NSObject *obj = [[clazz alloc] init];
                    [obj loadFromJson:v];
                    [list addObject:obj];
#if !__has_feature(objc_arc)
                    [obj release];
#endif
                }
            } else {
                flag = YES;
                break;
            }
        }
        if (flag) {
            [self setValue:value forKey:prop];
        } else {
            [self setValue:list forKey:prop];
        }
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSString *c = [value objectForKey:CLASS_KEY];
        if (!c){
            c = [[self propertyClassMap] objectForKey:prop];
        }
        Class clazz = NSClassFromString(c);
        if (clazz) {
//            if (clazz == [NSDictionary class] || clazz == [NSArray class]) {
//                [self setValue:value forKey:prop];
//                return;
//            }
            
            NSObject *obj = [[clazz alloc] init];
            [obj loadFromJson:value];
            [self setValue:obj forKey:prop];
#if !__has_feature(objc_arc)
            [obj release];
#endif
        }
    } else {
        
        if (![value isKindOfClass:[NSNull class]]) {
            @try {
                id class = [[self propertyClassMap] objectForKey:prop];
                if (class && [[[self internalSupportFormat] allKeys] containsObject:class] ) {
                    // 使用内部函数
                    NSString *func =  [[self internalSupportFormat] objectForKey:class];
                    
                    id result = [self performSelector:NSSelectorFromString(func) withObject:value];
                    if (result) {
                        [self setValue:result forKey:prop];
                    }
                } else {
                    [self setValue:value forKey:prop];
                }
                
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }

        }
    }
}

- (void)writeProperty:(NSString *)prop toJson:(NSMutableDictionary *)json {
    id value = [self valueForKey:prop];
    if (!value)
        return;
    NSString *key = prop;
    NSDictionary *map = self.propertiesMap;
    if ([map.allKeys containsObject:prop]){
        NSString *s = [map objectForKey:prop];
        if (s.length){
            key = s;
        }
    }
    if ([value isKindOfClass:[NSArray class]]) {
        BOOL flag = NO;
        NSMutableArray *list = [NSMutableArray array];
        for (id v in value) {

            if (![v conformsToProtocol:@protocol(VSAutoMapDelegate)]) {
                flag = YES;
                break;
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSObject<VSAutoMapDelegate> *model = v;
            [model writeToJson:dict];
            [list addObject:dict];
        }
        if (flag) {
            [json setObject:value forKey:key];
        } else {
            [json setObject:list forKey:key];
        }
    } else if ([value conformsToProtocol:@protocol(VSAutoMapDelegate)]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSObject<VSAutoMapDelegate>  *model = value;
        [model writeToJson:dict];
        [json setObject:dict forKey:key];
    } else {
        [json setObject:value forKey:key];
    }
}

- (void)loadFromJson:(NSDictionary *)json {
    NSSet *set = [self propertiesForJson];
    NSDictionary *map = [self propertiesMap];
    NSString *prop = nil;
    for (prop in set) {
        NSString *p = [map objectForKey:prop];
        if (!p){
            p = prop;
        }
        [self loadProperty:prop with:p fromJson:json];
    }
    [self afterLoaded:json];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *result =  [NSMutableDictionary dictionary];
    [self writeToJson:result];
    return result;
}

- (void)writeToJson:(NSMutableDictionary *)json {
    [self beforeWrite:json];
    NSSet *set = [self propertiesForJson];
    NSString *prop = nil;
    for (prop in set) {
        [self writeProperty:prop toJson:json];
    }
    //    [json setObject:NSStringFromClass([self class]) forKey:CLASS_KEY];
}

- (void)beforeWrite:(NSDictionary*)json {
    
}

- (void)afterLoaded:(NSDictionary*)json {
    
}

@end
