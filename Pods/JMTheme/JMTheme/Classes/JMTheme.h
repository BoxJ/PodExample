//
//  JMTheme.h
//  JMTheme
//
//  Created by ZhengXianda on 10/20/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - utils

#define JMThemeString(STR) __STRING(STR)
#define JMThemeConcat(PRE, SUF) __CONCAT(PRE, SUF)

#define _JMThemeVarName(ITEM_CLASS, NAME) ITEM_CLASS##_##T##_##NAME
#define JMThemeVarName(ITEM_CLASS, NAME) _JMThemeVarName(ITEM_CLASS, NAME)

#define _JMThemeArgCount(\
_00, _01, _02, _03, _04, _05, _06, _07, _08, _09, \
_10, _11, _12, _13, _14, _15, _16, _17, _18, _19, \
_20, _21, _22, _23, _24, _25, _26, _27, _28, _29, \
_30, _31, _32, _33, _34, _35, _36, _37, _38, _39, \
_40, _41, _42, _43, _44, _45, _46, _47, _48, _49, \
_50, _51, _52, _53, _54, _55, _56, _57, _58, _59, \
_60, _61, _62, _63, _64, _65, _66, _67, _68, _69, \
_70, _71, _72, _73, _74, _75, _76, _77, _78, _79, \
_80, _81, _82, _83, _84, _85, _86, _87, _88, _89, \
_90, _91, _92, _93, _94, _95, _96, _97, _98, _99, \
TARGET, ...) TARGET
#define JMThemeArgCount(...) _JMThemeArgCount(__VA_ARGS__, \
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, N,\
N, N, N, N, N, N, N, N, N, O)

#define _JMThemeExpand4(...) __VA_ARGS__
#define _JMThemeExpand3(...) _JMThemeExpand4(_JMThemeExpand4(_JMThemeExpand4(__VA_ARGS__)))
#define _JMThemeExpand2(...) _JMThemeExpand3(_JMThemeExpand3(_JMThemeExpand3(__VA_ARGS__)))
#define _JMThemeExpand1(...) _JMThemeExpand2(_JMThemeExpand2(_JMThemeExpand2(__VA_ARGS__)))
#define JMThemeExpand(...)   _JMThemeExpand1(_JMThemeExpand1(_JMThemeExpand1(__VA_ARGS__)))

#define JMThemeEmpty()
#define JMThemeDefer(ID) ID JMThemeEmpty()

#define _JMThemeForeach() JMThemeForeach
#define _JMThemeForeachO(MACRO, ITEM_CLASS, VAR_NAME) MACRO(ITEM_CLASS, VAR_NAME)
#define _JMThemeForeachN(MACRO, ITEM_CLASS, VAR_NAME, ...) MACRO(ITEM_CLASS, VAR_NAME)JMThemeDefer(_JMThemeForeach)() (MACRO, ITEM_CLASS, __VA_ARGS__)
#define JMThemeForeach(MACRO, ITEM_CLASS,...) JMThemeConcat(_JMThemeForeach, JMThemeArgCount(__VA_ARGS__)) (MACRO, ITEM_CLASS,  __VA_ARGS__)

#pragma mark - declare

#define _JMThemeVar(ITEM_CLASS, VAR_NAME) static const NSString *JMThemeVarName(ITEM_CLASS, VAR_NAME) = @JMThemeString(JMThemeVarName(ITEM_CLASS, VAR_NAME));
/// 声明控件对应的主题样式条目，一次最多一百条
#define JMThemeDeclare(ITEM_CLASS, ...) JMThemeExpand(JMThemeForeach(_JMThemeVar, ITEM_CLASS, __VA_ARGS__))

#pragma mark - regist

#define JMThemeVal(ITEM_CLASS, VALUATION) JMThemeVarName(ITEM_CLASS, VALUATION),
/// 注册控件对应的主题样式条目，一次最多一百条
#define JMThemeRegistT(ITEM_CLASS, ...) \
[JMTheme regist:[ITEM_CLASS class] theme:@{ \
JMThemeExpand(JMThemeForeach(JMThemeVal, ITEM_CLASS, __VA_ARGS__)) \
}];

/// 注册控件对应的主题样式条目，一次最多一百条
#define JMThemeRegist(ITEM_CLASS, ...) \
[JMTheme regist:[ITEM_CLASS class] theme:@{ \
__VA_ARGS__ \
}];

#pragma mark - fetch

/// 读取控件对应的主题样式条目
#define JMThemeFetchT(ITEM_CLASS, VAR_NAME) [JMTheme fetch:[ITEM_CLASS class]][JMThemeVarName(ITEM_CLASS, VAR_NAME)]

/// 读取控件对应的主题样式条目
#define JMThemeFetch(ITEM_CLASS, VAR_NAME) [JMTheme fetch:[ITEM_CLASS class]][VAR_NAME]

NS_ASSUME_NONNULL_BEGIN

@interface JMTheme : NSObject

#pragma mark - theme

+ (void)regist:(Class)itemClass theme:(id)theme;
+ (id)fetch:(Class)itemClass;

@end

NS_ASSUME_NONNULL_END
