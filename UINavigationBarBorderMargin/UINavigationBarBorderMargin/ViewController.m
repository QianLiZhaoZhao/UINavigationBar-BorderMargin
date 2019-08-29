//
//  ViewController.m
//  UINavigationBarBorderMargin
//
//  Created by XIYUN on 2019/8/29.
//  Copyright © 2019 XIYUN. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+HHBorderMargin.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"按钮边距";
    [UINavigationBar barItemTitle:@"左边" image:nil imagePostion:HHBarItemImagePostionLeft target:self action:@selector(leftAction) direction:HHBarItemDirectionLeft];
    
}

#pragma mark - Action
- (void)leftAction {
    
}

@end
