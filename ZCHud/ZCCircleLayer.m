//
//  ZCCircleLayer.m
//  ZCHud
//
//  Created by charles on 15/12/11.
//  Copyright © 2015年 charles. All rights reserved.
//

#import "ZCCircleLayer.h"

static UIColor *zcHudBorderColor;

@implementation ZCCircleLayer

#pragma mark - public methods

- (void)startRotation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.duration = 1;
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = NSIntegerMax;
    animation.removedOnCompletion = YES;
    [self addAnimation:animation forKey:@"ZCRotateAnimation"];
}

- (void)endRotation {
    [self removeAnimationForKey:@"ZCRotateAnimation"];
    [self removeAnimationForKey:@"ZCFillFullCircleAnimation"];
    self.progress = 1;
}

- (void)fillFullCircle {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 0.25;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self addAnimation:animation forKey:@"ZCFillFullCircleAnimation"];
}

#pragma mark - animation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self endRotation];
}

#pragma mark - drawing methods

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat borderWidth = MAX(3, self.circleBorderWidth);
    CGFloat radius = MIN(width, height);
    if (radius - borderWidth > 0) {
        radius = radius - borderWidth;
    }
    
    CGFloat targetStartAngle = M_PI * 2;
    CGFloat targetEndAngle = 0;
    
    CGFloat oriStartAngle = M_PI * 7 / 2;
    CGFloat oriEndAngle = M_PI * 2;
    
    CGFloat currentStartAngle = oriStartAngle + (targetStartAngle - oriStartAngle) * self.progress;
    CGFloat currentEndAngle = oriEndAngle + (targetEndAngle - oriEndAngle) * self.progress;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(width / 2, height / 2) radius:radius / 2 startAngle:currentStartAngle endAngle:currentEndAngle clockwise:NO];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, borderWidth);
    UIColor *targetColor;
    if (self.circleBorderColor) {
        targetColor = self.circleBorderColor;
    }
    else if (zcHudBorderColor) {
        targetColor = zcHudBorderColor;
    }
    else {
        targetColor = [UIColor colorWithRed:37 / 255.f green:146 / 255.f blue:227 / 255. alpha:1];
    }
    CGContextSetStrokeColorWithColor(ctx, targetColor.CGColor);
    CGContextStrokePath(ctx);
}

#pragma mark - setter and getter methods

- (void)setCircleBorderColor:(UIColor *)circleBorderColor {
    _circleBorderColor = circleBorderColor;
    zcHudBorderColor = circleBorderColor;
}

@end
