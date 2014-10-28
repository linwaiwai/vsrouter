//
//  ViewController.m
//  VSRouter
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[VSRouter sharedInstance] route:@"http://baidu.com"];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

@end
