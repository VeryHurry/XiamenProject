//
//  ColorMacro.h
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h


#endif /* ColorMacro_h */

#define NavigationTitleDic [NSDictionary dictionaryWithObjects:@[Font(17.0f),kBlack] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]]

#define HomeColorStr "282C37"
#define HomeColor ColorWithHex(0x282C37)
#define Home_Text_Color ColorWithHex(0x0068B7)

#define Navigation_Title_Color kWhite
#define Navigation_Title_Font Font(18.0f);

//随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]
// RGB颜色（不透明）
#define Color(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
// RGB颜色（带透明）
#define AlphaColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
// rgb颜色转换（16进制->10进制）
#define ColorWithHex(rgb) [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f green:((rgb & 0xFF00) >> 8) / 255.0f blue:((rgb & 0xFF)) / 255.0f alpha:1.0f]
//白色
#define kWhite [UIColor whiteColor]
//黑色
#define kBlack [UIColor blackColor]
//蓝色
#define kDarkBlue ColorWithHex(0x0EA6FF)
//字体灰色
#define kGray ColorWithHex(0x707070)

//字体浅灰色
#define kLightGray ColorWithHex(0xc9c9c9)
//背景灰色
#define kBgGray ColorWithHex(0xEEEEEE)
//按钮灰色
#define kBtnGray ColorWithHex(0xA0A0A0)
//线条颜色
#define kLineColor ColorWithHex(0xD2D2D2)
//红色
#define kRed ColorWithHex(0xFF0000)
//蓝色
#define kBlue ColorWithHex(0x00A0E9)

//绿色
#define kGreen ColorWithHex(0x009944)

//卡片颜色
#define kCard_Color @[ColorWithHex(0xD6B17A),ColorWithHex(0xE2C498),ColorWithHex(0xEDD6B2)]

//金色
#define kGolden ColorWithHex(0xD9B682)
