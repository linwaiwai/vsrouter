//
//  RegexViewController.m
//  VSRouter
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "RegexViewController.h"

@interface RegexViewController ()

@end

@implementation RegexViewController

+ (void)load{
    __block VSRegexRoute *route = [[VSRegexRoute alloc] initWithPattern:@"/archive/(\\d+)/page/(\\d+)" map:@{[NSNumber numberWithInteger:0]:@"package", [NSNumber numberWithInteger:1]: @"page"}  handler:^BOOL(NSDictionary *parameters) {
        
        NSLog(@"%@", parameters);
        RegexViewController *testViewController = [[RegexViewController alloc] init];
        UINavigationController *navigation = (UINavigationController*)[[AppDelegate sharedInstance].window rootViewController];
        [navigation pushViewController:testViewController animated:YES];
        return YES;
    }];
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
