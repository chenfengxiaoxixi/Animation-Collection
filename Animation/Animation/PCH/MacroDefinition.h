//
//  MacroDefinition.h
//  Animation
//
//  Created by cf on 2018/12/22.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

//弱引用
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

//空字符串检测

#define CHECK_STRING(a) ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"(null)"]  ? @"" : ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"<null>"] ? @"" : [NSString stringWithFormat:@"%@",a]))


//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif

//color

#define KBackgroundColor    [UIColor colorOfHex:0xf6f6f6]

#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]

#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]
#define SCREENW(X) [[UIScreen mainScreen] bounds].size.width / 375 *(X)

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件适配
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define IS_iPhoneX (kStatusBarHeight > 20.0f)

#define TopHeight     (IS_iPhoneX?88:64)
#define TabbarHeight  (IS_iPhoneX?83:(49 + 6))
#define NavBarHeight   44
#define StatusBarHeight (IS_iPhoneX?44:20)
#define BottomSafeHeight (IS_iPhoneX?34:20)
#define NOTabBarHeight ((IS_iPhoneX?24:0))

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#endif /* MacroDefinition_h */
