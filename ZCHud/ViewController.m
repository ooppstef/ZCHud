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
    self.view.backgroundColor = [UIColor lightGrayColor];
    ZCHud *hud = [ZCHud new];
    [hud showInView:self.view];
    [self.view addSubview:hud];
}



@end
