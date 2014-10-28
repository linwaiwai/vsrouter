/*!
 *  转换16进制颜色为UIColor对象
 *
 *  @param rgbValue RGB色值，如(0xff0000)
 *
 *  @return UIColor对象
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

///判断是否运行在模拟器中
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

///判断iOS系统版本
#define isIOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define isIOS4 ([[[UIDevice currentDevice]systemVersion] floatValue] < 5.0)
#define IOSVersion ([[[UIDevice currentDevice]systemVersion] floatValue])
#define underIOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] < 7.0)
#define isIOSVersionMatch(ver) (IOSVersion >= ver)
#define isIOSVersionLower(ver) (IOSVersion < ver)

#define isiPadClient UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

///获取居中的CGRect
#define CGRectCenter(superRect,subRect) \
CGRectMake((superRect.size.width-subRect.size.width)/2, (superRect.size.height-subRect.size.height)/2,  subRect.size.width, subRect.size.height)

///设置视图frame的x
#define CGRectSetX(viewRect,x) \
CGRectMake(x, view.origin.y, view.size.width, view.size.height)

///设置视图frame的y
#define CGRectSetY(viewRect,y) \
CGRectMake(viewRect.origin.x, y, viewRect.size.width, viewRect.size.height)

#define PropertyObjectRetain(property,variable) {\
           if(property!=variable){\
                [variable retain];\
                [property release];\
                property = nil; \
                property = variable;\
    }\
}\


#define PropertyObjectCopy(property,variable) {\
        if(property!=variable){\
            [property release];\
            property = nil; \
            property = [variable copy];\
        }\
}\

#define PropertyObjectRelease(property) {\
        [property release];\
        property = nil; \
}\

#define SafeRelease(property) {\
        [property release];\
        property = nil; \
}\


#define  SessionIsTemporaryLogin    (([[VSSession sharedInstance] passport] != nil) && ([[[VSSession sharedInstance] passport] lifeType]==0))
#define  SessionIsPermanentLogin    (([[VSSession sharedInstance] passport] != nil) && ([[[VSSession sharedInstance] passport] lifeType]>0))
#define  SessionIsNotLogin          [[VSSession sharedInstance] passport] == nil


#define GETHEIGHT(view) CGRectGetHeight(view.frame)
#define GETWIDTH(view) CGRectGetWidth(view.frame)
#define GETORIGIN_X(view) view.frame.origin.x
#define GETORIGIN_Y(view) view.frame.origin.y
#define GETRIGHTORIGIN_X(view) view.frame.origin.x + CGRectGetWidth(view.frame)
#define GETBOTTOMORIGIN_Y(view) view.frame.origin.y + CGRectGetHeight(view.frame)

///声明为单例类
///需要在@interface中声明以下函数原型
///+ (className *)sharedInstance
#define DECLARE_SINGLETON_B(className) \
static className *singletonInstance = nil; \
\
+ (className *)sharedInstance { \
@synchronized (self) { \
if (!singletonInstance) { \
[[self alloc] init]; \
} \
} \
return singletonInstance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
@synchronized (self) { \
if (!singletonInstance) { \
singletonInstance = [super allocWithZone:zone]; \
return singletonInstance; \
} \
} \
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone; { \
return self; \
} \
\
- (id)retain { \
return self; \
} \
\
- (unsigned)retainCount { \
return UINT_MAX; \
} \
\
- (id)autorelease { \
return self; \
} \
\
- (oneway void)release { \
} \

#define DECLARE_SINGLETON_A(className) \
static className *singletonInstance = nil; \
+ (className *)sharedInstance { \
    @synchronized (self) { \
        if (!singletonInstance) { \
            singletonInstance = [[self alloc] init]; \
        } \
        return singletonInstance; \
    } \
} \

#ifdef DEBUG
#define DECLARE_SINGLETON DECLARE_SINGLETON_A
#else
#define DECLARE_SINGLETON DECLARE_SINGLETON_B
#endif

#define _ResizeImage(image)  (isIOSVersionLower(6.0) ? [image stretchableImageWithLeftCapWidth:10 topCapHeight:5] : [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2 - 1, image.size.width / 2 - 1) resizingMode:UIImageResizingModeStretch])

#define LINE_HEIGHT 1.0f / [UIScreen mainScreen].scale

// 处理编译警告
// warning:performSelector may cause a leak because its selector is unknown
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
