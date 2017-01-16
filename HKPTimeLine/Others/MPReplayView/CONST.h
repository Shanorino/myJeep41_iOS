//
//  CONST.h
//  WeiHePan
//
//  Created by manpao on 14-5-8.
//  Copyright (c) 2014年 manpao. All rights reserved.
//

#ifndef WeiHePan_CONST_h
#define WeiHePan_CONST_h

#import "UIViewExt.h"
//屏幕大小边界
#define ScreenBounds [[UIScreen mainScreen] bounds]
//屏幕高度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define BackColor  [UIColor colorWithRed:237.0/255.0 green:76.0/255.0 blue:42.0/255.0 alpha:1]

#define COlOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]

#define BLUECOLOR COlOR(39, 136, 176, 1)

#define  GrayBlackCOLOR COlOR(80, 80, 80, 1)

#define  MPNotificationCenter  [NSNotificationCenter defaultCenter]
#define  MPApplication [UIApplication sharedApplication]
#define  MPUserDefaults [NSUserDefaults standardUserDefaults]


#define  MPFONTNAME  @"Helvetica"
#define  MPBoldFONTNAME  @"Helvetica-bold"

#define SystemFont(fontSize)  [UIFont systemFontOfSize:fontSize];
#define SystemBoldFont(fontSize)  [UIFont boldSystemFontOfSize:fontSize];

#define  CONTENTFont SystemFont(16)
#define  CONTENTCOLOR [UIColor colorWithWhite:102/255.0 alpha:1]

#define  NAMECOLOR [UIColor grayColor]
#define  NAMEFont SystemFont(13)

#define  PROJECTDetailFont SystemFont(15)

#define  TopicFont SystemFont(12)


#define  TITLEFont SystemBoldFont(18)
#define  TITLECOLOR [UIColor colorWithWhite:73/255.0 alpha:1]
#define  MessageFont SystemFont(16)
#define  MessageCOLOR [UIColor colorWithWhite:155/255.0 alpha:1]
#define  Reply0Like_img_COLOR [UIColor colorWithWhite:210/255.0 alpha:1]
#define  Reply0Like_num_COLOR [UIColor colorWithWhite:210/255.0 alpha:1]
#define  Line_COLOR [UIColor colorWithWhite:226/255.0 alpha:1]


#define SCREEN_MAX_LENGTH (MAX(ScreenWidth, ScreenHeight))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define  BUNDLEID  (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define  VERSION  (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define  MPSystemVersion [[UIDevice currentDevice] systemVersion]


#endif
