//
//  GeaModel.h
//  GeaBookDesigner
//
//  Created by Johnny Cubehead on 12-9-6.
//  Modified by linwaiwai on 13-11-04
//

#import <Foundation/Foundation.h>

@protocol GeaModel

@optional
- (NSSet *)propertiesForJson;
- (NSDictionary *)propertiesMap;
- (NSDictionary *)propertyClassMap;
// 满足服务器BT的需求。
-(void)loadJson:(NSDictionary*)json;


@end


@interface NSObject  (GeaModel)

+ (id)modelWithJson:(NSDictionary *)json;

- (NSSet *)propertiesForJson;

- (NSDictionary *)propertiesMap;

- (NSDictionary *)propertyClassMap;

- (void)loadFromJson:(NSDictionary *)json;

- (void)writeToJson:(NSMutableDictionary *)json;

- (void)writeProperty:(NSString *)prop toJson:(NSMutableDictionary *)json;

- (void)beforeWrite:(NSDictionary*)json;

- (void)afterLoaded:(NSDictionary*)json;

- (void)setup;

- (NSDictionary *)toDictionary;

@end
