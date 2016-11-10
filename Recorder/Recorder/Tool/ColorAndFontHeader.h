//
//  ColorAndFontHeader.h
//  toolstest
//
//  Created by SheldonLee on 15/8/26.
//  Copyright (c) 2015年 U-Works. All rights reserved.
//

#ifndef toolstest_ColorAndFontHeader_h
#define toolstest_ColorAndFontHeader_h

// 颜色定义
#define HEXCOLOR(rgbValue)                                               \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:1.0]

#define RGBCOLOR(r, g, b) \
[UIColor colorWithRed:r % 256 / 255.0 green:g % 256 / 255.0 blue:b % 256 / 255.0 alpha:1]
#define RGBACOLOR(r, g, b, a) \
[UIColor colorWithRed:r % 256 / 255.0 green:g % 256 / 255.0 blue:b % 256 / 255.0 alpha:a]
#define UIColorFromRGB_16(rgbValue) \
([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
// 主蓝色
#define COLOR_BASE_BLUE HEXCOLOR(0x0078FF)
// 主背景灰
#define COLOR_BASE_GRAY HEXCOLOR(0xE5E5E5)
// 字体黑
#define COLOR_BASE_TEXT_BLACK HEXCOLOR(0x333333)
// 字体灰
#define COLOR_BASE_TEXT_GRAY HEXCOLOR(0x999999)
// 字体黄
#define COLOR_BASE_TEXT_YELLOW HEXCOLOR(0xFCC55A)
// 导航栏上未选中时
#define COLOR_BASE_NAV HEXCOLOR(0xBBFBC3)
// 登录页高亮边框
#define COLOR_BASE_TEXTFIELD_BORDER HEXCOLOR(0x71B4FE)
//已关注按钮颜色
#define COLOR_BASE_DARK_BLUE HEXCOLOR(0x04269A)
//提示字体颜色
#define COLOR_BASE_LIGHT_GRAY HEXCOLOR(0x898989)
//文本框边框颜色
#define COLOR_BORDER HEXCOLOR(0x71b4fe)
// placeholder字体颜色
#define COLOR_PLACEHOLDER HEXCOLOR(0xc5c5c5)

#define SYSTEM_FONT(fontSize) [UIFont systemFontOfSize:fontSize]
#define SYSTEM_BOLD_FONT(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define AvenirLightFont(fontSize) [UIFont fontWithName:@"Avenir-Light" size:fontSize]
#define AvenirMedium(fontSize) [UIFont fontWithName:@"Avenir-Medium" size:fontSize]
#define NavFont(fontSize) [UIFont fontWithName:@"Helvetica-Bold" size:fontSize]
#define SingleFont(fontSize) [UIFont fontWithName:@"PMingLiU" size:fontSize]
#define DailyFont(fontSize) [UIFont fontWithName:@"TpldKhangXiDictTrial" size:fontSize]
// 快速的titleAttribute字典的创建
#define DICT_ATTRIBUTE_TITLE(_font, _hexcolor)                \
@{                                                        \
NSFontAttributeName : [UIFont systemFontOfSize:_font], \
NSForegroundColorAttributeName : HEXCOLOR(_hexcolor),  \
}

#define DICT_ATTRIBUTE_TITLE_BOLD(_font, _hexcolor)               \
@{                                                            \
NSFontAttributeName : [UIFont boldSystemFontOfSize:_font], \
NSForegroundColorAttributeName : HEXCOLOR(_hexcolor),      \
}

// 间距定义
#define PADDING_CELL 10
#define SPadding 5

#define PADDING_TEXTFIELD 30

#define NavHeight 64

#define TabbarHeight 49

#define MAIN_WINDOW [[[UIApplication sharedApplication] delegate] window]

#pragma mark - OnlyBox UI

#define BPBaseColor HEXCOLOR(0xfee801)

#define BPBackGroundColor HEXCOLOR(0xf5f5f5)

#define BPSupportColor HEXCOLOR(0x655106)

#define BPCurrentPageColor HEXCOLOR(0xeae41f)

#define BPBoarderColor HEXCOLOR(0xdedede)

#define BPDetailColor HEXCOLOR(0xafafaf)

#define BPSecTitleColor HEXCOLOR(0x5b5b5b)

#define BPTitleColor HEXCOLOR(0x333333)

#define BPFindingColor HEXCOLOR(0xe1e1e1)

#define BPAlertColor HEXCOLOR(0xf00414)

#define BPLeftSideColor RGBACOLOR(34, 34, 34, 0.9)

#define BPChatUserColor RGBACOLOR(51, 51, 51, 0.9)
#endif
