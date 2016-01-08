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

@property (nonatomic, strong) ZCHud *hud;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 64, 100, 30);
    [btn setTitle:@"Show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showHud) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showHud {
    _hud = nil;
    
    _hud = [ZCHud new];
    [_hud showInView:self.view];
    
    
    
    [_hud hudTouched:^(ZCHud *hud) {
        [hud hide];
    }];
}


@end
