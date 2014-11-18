//
//  VSRouterTests.m
//  VSRouterTests
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VSRouter.h"

@interface VSRouterTests : XCTestCase

@end

@implementation VSRouterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCompontRoute {
    VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"/:controller/:id" handler:^BOOL(VSRoute *route) {
//        XCTAssert(YES, @"Pass");
        return YES;
    }];
    NSDictionary *params =  [route match:@"/ssdd/23232"];
    
    XCTAssert(params, @"Pass");
    XCTAssert([params count]==2, @"Pass");
    XCTAssert([params[@"controller"] isEqualToString:@"ssdd"], @"Pass");
    
    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
}
//- (void)testRoute {
//    [[VSRouter sharedInstance] route:@"/dddd/fffff"];
//}

- (void)testRegexRoute {
    VSRegexRoute *route = [[VSRegexRoute alloc] initWithPattern:@"/archive/(\\d+)/page/(\\d+)" map:@{[NSNumber numberWithInteger:0]:@"package", [NSNumber numberWithInteger:1]: @"page"} handler:^BOOL(VSRoute *route) {
        return YES;
    }];
    NSDictionary *params =  [route match:@"/archive/23232/page/12121"];
    
    XCTAssert(params, @"Pass");
    XCTAssert([params count]==2, @"Pass");
    XCTAssert(params[@"package"], @"Pass");
    XCTAssert([params[@"package"] integerValue] == 23232, @"Pass");
    
    // This is an example of a functional test case.
    //    XCTAssert(YES, @"Pass");
}



- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
