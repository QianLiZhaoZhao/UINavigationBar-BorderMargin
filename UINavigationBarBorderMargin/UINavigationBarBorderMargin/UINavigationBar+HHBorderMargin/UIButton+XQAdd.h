//
//  UIButton+XQAdd.h
//  Tea
//
//  Created by Ticsmatic on 2016/12/21.
//  Copyright © 2016年 Ticsmatic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (XQAdd)

#pragma mark - Adjust Image Position
// https://github.com/Phelthas/Demo_ButtonImageTitleEdgeInsets
typedef NS_ENUM(NSInteger, LXMImagePosition) {
    LXMImagePositionLeft = 0,              ///< 图片在左，文字在右，默认
    LXMImagePositionRight = 1,             ///< 图片在右，文字在左
    LXMImagePositionTop = 2,               ///< 图片在上，文字在下
    LXMImagePositionBottom = 3,            ///< 图片在下，文字在上
};

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(enum LXMImagePosition)postion spacing:(CGFloat)spacing;

@end
