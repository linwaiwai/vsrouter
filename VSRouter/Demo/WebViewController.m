//
//  WebViewController.m
//  VSRouter
//
//  Created by linwaiwai on 10/28/14.
//  Copyright (c) 2014 Vipshop Holdings Limited. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"
@interface WebViewController ()

@property (nonatomic, retain) UIWebView *webview;

@end

@implementation WebViewController

+ (void)load{
    __block VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"http://*" handler:^BOOL(VSRoute *route) {
        
        WebViewController *testViewController = [[WebViewController alloc] init];
        UINavigationController *navigation = (UINavigationController*)[[AppDelegate sharedInstance].window rootViewController];
        [navigation pushViewController:testViewController animated:YES];
        [testViewController loadURL:route.matched];
        return YES;
    }];
    [[VSRouter sharedInstance] addRoute:route];
}


-(void)loadURL:(NSString *)url {
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(UIWebView*)webview{
    if (!_webview) {
        _webview =  [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    return _webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.view addSubview:self.webview];
    
    
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
