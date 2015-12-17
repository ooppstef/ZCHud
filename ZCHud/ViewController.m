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
    ZCHud *hud = [[ZCHud alloc] initWithFrame:CGRectMake(0, 64, 300, 300)];
    hud.text = @"谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱谢谢你的爱1111";
    hud.backgroundColor = [UIColor grayColor];
    [self.view addSubview:hud];

}


@end
