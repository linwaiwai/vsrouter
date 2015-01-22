//
//  TestViewController.m
//  VSRouter
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "TestViewController.h"
#import "AppDelegate.h"



@implementation TestViewController



+ (void)load{
    VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"/:controler/:action" handler:^BOOL(VSRoute *route) {
        
        TestViewController *testViewController = [[TestViewController alloc] init];
        UINavigationController *navigation = (UINavigationController*)[[AppDelegate sharedInstance].window rootViewController];
        [navigation pushViewController:testViewController animated:YES];
        return YES;
    }];
//    route.excepted = [expectedClass]
    [[VSRouter sharedInstance] addRoute:route];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
