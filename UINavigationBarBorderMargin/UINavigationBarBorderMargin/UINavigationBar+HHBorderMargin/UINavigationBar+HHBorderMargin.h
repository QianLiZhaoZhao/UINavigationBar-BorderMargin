//
//  UINavigationBar+HHBorderMargin.h
//  BBTeacher
//
//  Created by EDZ on 2018/8/1.
//  Copyright © 2018年 HH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, HHBarItemDirection) {
    HHBarItemDirectionRight = 1 << 0,              ///< 右方按钮，默认
    HHBarItemDirectionLeft = 1 << 1,               ///< 左方按钮
};

typedef NS_ENUM(NSInteger, HHBarItemImagePostion) {
    HHBarItemImagePostionRight = 0,              ///< 图片在右边，默认
    HHBarItemImagePostionLeft = 1,               ///< 图片在左边
};

@interface UINavigationBar (HHBorderMargin)
/// 自定义视图定制导航栏按钮（符合项目需求的margin）
+ (nullable NSArray <UIBarButtonItem *>*)barItemCustomView:(nullable id)customView
                                                    target:(nullable id)target
                                                 direction:(HHBarItemDirection)direction;

/***
 导航栏按钮（符合项目风格）￼
 title            标题
 image            图片
 imagePostion     图片位置（左 | 右）
 target           按钮响应对象
 action           按钮回调
 direction        在导航栏的位置（左上角 | 右上角）
 **/
+ (nullable NSArray <UIBarButtonItem *>*)barItemTitle:(nullable NSString *)title
                                                image:(nullable UIImage *)image
                                         imagePostion:(HHBarItemImagePostion)imagePostion
                                               target:(nullable id)target
                                               action:(nullable SEL)action
                                            direction:(HHBarItemDirection)direction;
/***
 导航按钮隐藏
 hidden           是否隐藏
 target           隐藏响应对象
 direction        在导航栏的位置（左上角 | 右上角）
 **/
+ (void)barItemHidden:(BOOL)hidden target:(nullable id)target direction:(HHBarItemDirection)direction;

@end
