//
//  ZCTextLayer.h
//  ZCHud
//
//  Created by charles on 15/12/15.
//  Copyright © 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCTextLayer : CALayer

@property (nonatomic, strong) UIFont   *font;
@property (nonatomic, strong) UIColor  *fontColor;
@property (nonatomic, copy)   NSString *text;

- (CGFloat)heightWithWidth:(CGFloat)width;

@end
