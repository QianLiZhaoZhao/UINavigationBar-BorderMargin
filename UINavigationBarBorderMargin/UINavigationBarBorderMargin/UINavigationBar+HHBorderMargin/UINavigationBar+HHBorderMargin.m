//
//  UINavigationBar+HHBorderMargin.m
//  BBTeacher
//
//  Created by EDZ on 2018/8/1.
//  Copyright © 2018年 HH. All rights reserved.
//

#import "UINavigationBar+HHBorderMargin.h"
#import "UIButton+XQAdd.h"
/// 根据2x/3x 屏幕来返回边距
#define kNavigatonBarMargin [UIScreen mainScreen].scale == 2 ? 16 : 20
static NSInteger kHHNavigatonBarMargin = 12;                       ///< 项目UI风格 左右边距12

void swizzleInstanceMethod(Class _Nullable cls, SEL originSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    if (class_addMethod(cls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UINavigationBar (HHBorderMargin)

+ (NSArray <UIBarButtonItem *>*)barItemCustomView:(id)customView target:(nullable id)target direction:(HHBarItemDirection)direction {
    if ([customView isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)customView;
        if (view.bounds.size.width == 0 && view.bounds.size.height == 0) {
            [view sizeToFit];
        }
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView: customView];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger kUINavigatonBarMargin = kNavigatonBarMargin;
    itemSpace.width = -(kUINavigatonBarMargin - kHHNavigatonBarMargin);
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = target;
        if (direction == HHBarItemDirectionRight) {
            vc.navigationItem.rightBarButtonItems = @[itemSpace,item];
        } else {
            vc.navigationItem.leftBarButtonItems = @[itemSpace,item];
        }
        [vc.navigationController.navigationBar setNeedsLayout];
        [vc.navigationController.navigationBar layoutIfNeeded];
    }
    return @[itemSpace,item];
}

+ (NSArray <UIBarButtonItem *>*)barItemTitle:(NSString *)title image:(UIImage *)image imagePostion:(HHBarItemImagePostion)imagePostion target:(nullable id)target action:(nullable SEL)action direction:(HHBarItemDirection)direction {
    UIControlContentHorizontalAlignment alignment = direction == HHBarItemDirectionLeft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = alignment;
    CGFloat height = 0.f;
    CGFloat width = 0.f;
    height = image ? image.size.height * 2 : 44;
    if (title) {
        [btn setTitle:title forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        width += [self sizeWithString:title UIHeight:height font:[UIFont systemFontOfSize:14]].width;
    }
    if (image) {
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:0];
        width += title ? image.size.width + 6 : image.size.width *2;
    }
    btn.frame = CGRectMake(0, 0, width, height);
    objc_setAssociatedObject(btn, @"target", target,OBJC_ASSOCIATION_ASSIGN);
    if (action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL selector = @selector(back);
#pragma clang diagnostic pop
        if ([target respondsToSelector:selector]) {  /// 如果控制器里有back方法，则执行back方法
            [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn addTarget:self action:@selector(navBack:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    if (title && image) {
        LXMImagePosition position = imagePostion == HHBarItemImagePostionLeft ? LXMImagePositionLeft : LXMImagePositionRight;
        [btn setImagePosition:position spacing:6.f];
    }
    return [self barItemCustomView:btn target:target direction:direction];
}

+ (void)barItemHidden:(BOOL)hidden target:(nullable id)target direction:(HHBarItemDirection)direction {
    UIViewController *vc = (UIViewController *)target;
    switch (direction) {
        case HHBarItemDirectionLeft:
            vc.navigationItem.leftBarButtonItems.lastObject.customView.hidden = hidden;
            break;
        case HHBarItemDirectionRight:
            vc.navigationItem.rightBarButtonItems.lastObject.customView.hidden = hidden;
            break;
        case HHBarItemDirectionLeft | HHBarItemDirectionRight:
            vc.navigationItem.leftBarButtonItems.lastObject.customView.hidden = hidden;
            vc.navigationItem.rightBarButtonItems.lastObject.customView.hidden = hidden;
            break;
        default:
            break;
    }
}

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            swizzleInstanceMethod(self, @selector(layoutSubviews), @selector(hh_layoutSubviews));
        });
        
    }
}

- (void)hh_layoutSubviews {
    [self hh_layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
            subview.layoutMargins = UIEdgeInsetsMake(0, kHHNavigatonBarMargin, 0, kHHNavigatonBarMargin);  //可修正iOS11之后的偏移
            break;
        }
    }
}

#pragma mark - Action
+ (void)navBack:(id)sender {
    id target = objc_getAssociatedObject(sender, @"target");
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)target;
        [controller.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Pravite
+ (CGSize)sizeWithString:(NSString *)string UIHeight:(CGFloat)height font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

@end
