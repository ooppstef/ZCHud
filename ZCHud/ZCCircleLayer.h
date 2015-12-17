//
//  ZCCircleLayer.h
//  ZCHud
//
//  Created by charles on 15/12/11.
//  Copyright © 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCCircleLayer : CALayer

@property (nonatomic, assign) CGFloat circleBorderWidth;
@property (nonatomic, strong) UIColor *circleBorderColor;
@property (nonatomic, assign) CGFloat progress;

- (void)startRotation;
- (void)endRotation;
- (void)fillFullCircle;

@end
