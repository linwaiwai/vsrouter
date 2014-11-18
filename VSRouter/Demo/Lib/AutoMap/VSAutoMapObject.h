
#import <Foundation/Foundation.h>

@interface NSString (charValue)
-(const char *)charValue;

@end

@protocol VSAutoMapDelegate

@optional

- (NSSet *)propertiesForJson;
- (NSDictionary *)propertiesMap;
- (NSDictionary *)propertyClassMap;

@end


@interface NSObject  (VSAutoMapObject)

+ (id)modelWithJson:(NSDictionary *)json;

- (NSSet *)propertiesForJson;

- (NSDictionary *)propertiesMap;

- (NSDictionary *)propertyClassMap;

- (void)loadFromJson:(NSDictionary *)json;

- (void)writeToJson:(NSMutableDictionary *)json;

- (void)writeProperty:(NSString *)prop toJson:(NSMutableDictionary *)json;

- (void)beforeWrite:(NSDictionary*)json;

- (void)afterLoaded:(NSDictionary*)json;

- (NSDictionary *)toDictionary;

@end
