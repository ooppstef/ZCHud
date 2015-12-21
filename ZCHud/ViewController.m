//
//  ViewController.m
//  ZCHud
//
//  Created by charles on 15/12/8.
//  Copyright © 2015年 charles. All rights reserved.
//

#import "ViewController.h"
#import "ZCHud.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZCHud *hud = [[ZCHud alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
//    ZCHud *hud = [ZCHud new];
//    hud.frame = CGRectMake(0, 64, 100, 100);
    hud.borderWidth = 5;
    hud.text = @"您的费用已经结清,请稍后再试!您的费用已经结清,请稍后再试!您的费用已经结清,请稍后再试!您的费用已经结清,请稍后再试!您的费用已经结清,请稍后再试!您的费用已经结清,请稍后再试!123";
    hud.backgroundColor = [UIColor grayColor];
    [self.view addSubview:hud];

}


@end
