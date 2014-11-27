VSRouter 
========
使用方法
--------
VSRouter ( gitlab.tools.vipshop.com/waiwai.lin/vsrouter) 是一个iOS路由器，参考了web设计中Router的设计，其提供了iOS中组件解耦一种方式。模块可以自己设计自己资源链接形式，注入Router中。如TestViewController中有：

+ (void)load {
    VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"/:controler/:action" handler:^BOOL(VSRoute *route) {
        TestViewController *testViewController = [[TestViewController alloc] init];
        UINavigationController *navigation = (UINavigationController*)[[AppDelegate sharedInstance].window rootViewController];
        // route.params
        [navigation pushViewController:testViewController animated:YES];
        return YES;
    }];
    [[VSRouter sharedInstance] addRoute:route];
}

在该文件被引入项目文件中时候，工程文件具备处理如http://:controller/:action (:controller 和 :action 为变量) 或者 vipshop://:controller/:action 这样链接的能力。如果提供给VSComponentRoute的链接有scheme，如：

VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"vipshop://:controler/:action" handler:^BOOL(VSRoute *route) {
}

则指定该Route仅仅接受有vipshop作为shceme的请求信息。为了方便的处理更加复杂的请求URL，VSRoute提供了正则支持：

+ (void)load{
    __block VSRegexRoute *route = [[VSRegexRoute alloc] initWithPattern:@"/archive/(\\d+)/page/(\\d+)" map:@{[NSNumber numberWithInteger:0]:@"package", [NSNumber numberWithInteger:1]: @"page"}  handler:^BOOL(VSRoute *route) {
        RegexViewController *testViewController = [[RegexViewController alloc] init];
        UINavigationController *navigation = (UINavigationController*)[[AppDelegate sharedInstance].window rootViewController];
        [navigation pushViewController:testViewController animated:YES];
        return YES;
    }];
    [[VSRouter sharedInstance] addRoute:route];
}

map指定了变量被映射到参数的时候使用的key。
Web请求的处理
为了方便的处理各种浏览器的请求。VSRoute提供了拦截http的方法（拦截App内部请求，请参考App请求拦截），如有类WebViewController ，写入：

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

表示该controller将处理所有的所有http的请求。
对老代码改造
如特卖会中，有代码：

- (void)openURLWithURLString:(NSString *)urlString {
    if (urlString != nil && ![urlString isEqualToString:@""]) {
        self.urlString = urlString;
    }
    
    if (self.urlString != nil && ![self.urlString isEqualToString:@""]) {
       if ([self.urlString rangeOfString:BRANDPRODUCTS].length) {
            [[VSOpenURLManager sharedInstance] openURLWithURLString:self.urlString rangeString:BRANDPRODUCTS block:^(NSDictionary *paramDic) {
                NSString *brandId = [paramDic objectForKey:@"brandId"];
                NSString *brandName = [paramDic objectForKey:@"brandName"];
                
                VSGoodsListViewControllerEx *goodListVC = [[[VSGoodsListViewControllerEx alloc] initWithBrandID:brandId brandIndex:-1] autorelease];
                goodListVC.isRoot = YES;
                goodListVC.title = [brandName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                goodListVC.pageEvent.parentPage=@"12";
                goodListVC.parentPageSource=@"12";
                [[VSRouteManager defaultManager] routeTo:[VSRouteTarget targetWithViewController:goodListVC
                                                                                           class:_TabPage_PrimaryClass]];//在第一个tab里push
            }];
        } else if ([self.urlString rangeOfString:GOODSDETAIL].length) {
            [[VSOpenURLManager sharedInstance] openURLWithURLString:self.urlString rangeString:GOODSDETAIL block:^(NSDictionary *paramDic) {
                NSString *brandId = [paramDic objectForKey:@"brandId"];
                NSString *goodsId = [paramDic objectForKey:@"goodsId"];
                NSString *goodsType = [paramDic objectForKey:@"goodsType"];
                NSString *goodsTitle = [paramDic objectForKey:@"goodsTitle"];
                AccessPath accessPath = apFromOpenURL;
                if ([goodsType isEqualToString:@"1"]){
                    accessPath = apFromCosmeticList;
                } else {
                    accessPath = apFromOpenURL;
                }
                //进入商品详情
                VSMerchandiseDetailViewController *merchandiseDetailViewController = [[[VSMerchandiseDetailViewController alloc] initWithMerchandiseId:goodsId brandId:brandId accessPath:accessPath] autorelease];
                merchandiseDetailViewController.title = [goodsTitle stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                VSPullController *pull=[[[VSPullController alloc] initWithRootViewController:merchandiseDetailViewController] autorelease];
                [[VSRouteManager defaultManager] routeTo:[VSRouteTarget targetWithViewController:pull
                                                                                           class:_TabPage_PrimaryClass]];
                
            }];
        }
    }
}

可在VSGoodsListViewControllerEx 中写入：

+ (void)load{
    __block VSComponentRoute *route = [[VSComponentRoute alloc] initWithPattern:@"http://*" handler:^BOOL(VSRoute *route) { 
         NSDictionary *parameters = route.params;
         NSString *brandId = [parameters objectForKey:@"brandId"];
         NSString *brandName = [parameters objectForKey:@"brandName"];
         VSGoodsListViewControllerEx *goodListVC = [[[VSGoodsListViewControllerEx alloc] initWithBrandID:brandId brandIndex:-1] autorelease];
         goodListVC.isRoot = YES;
         goodListVC.title = [brandName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         goodListVC.pageEvent.parentPage=@"12";
         goodListVC.parentPageSource=@"12";
         [[VSRouteManager defaultManager] routeTo:[VSRouteTarget targetWithViewController:goodListVC 
                                                                                           class:_TabPage_PrimaryClass]];//在第一个tab里push
 
        return YES;
    }];
    [[VSRouter sharedInstance] addRoute:route];
}

除了做消息路由之外，VSRoute提供了自动转换机制，同时提供，修改方法。如：

[VSRouter sharedInstance].mapper = (id)^(VSRoute *route, NSDictionary *params){
     id expected = [route.expectedClass modelWithJson:params];
     return expected;
};

VSRoute提供了简单自带可拆卸的自动转换机制。转换之后可以使用route.object 读取。