//
//  ZCHud.m
//  ZCHud
//
//  Created by charles on 15/12/8.
//  Copyright © 2015年 charles. All rights reserved.
//

#import "ZCHud.h"
#import "ZCCircleLayer.h"
#import "ZCTextLayer.h"

static double const kZCSpaceBetweenCircleAndText = 5;

@interface ZCHud ()

@property (nonatomic, strong) ZCCircleLayer *circleLayer;
@property (nonatomic, strong) ZCTextLayer   *textLayer;

@property (nonatomic, assign) CGFloat       textLayerHeight;

@end

@implementation ZCHud

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        [self setupCricle];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCricle];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCricle];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupCricle {
    _circleLayer = [ZCCircleLayer layer];
    
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
    radius = radius / 2;
    
    _circleLayer.bounds = CGRectMake(0, 0, radius, radius);
    _circleLayer.position = CGPointMake(self.bounds.size.width / 2, radius / 2);
    _circleLayer.shouldRasterize = YES;
    [_circleLayer setNeedsDisplay];
    [self.layer addSublayer:_circleLayer];
    [self.circleLayer startRotation];
    
    _textLayer = [ZCTextLayer layer];
    [self.layer addSublayer:_textLayer];
}

- (CGRect)realFrame:(CGRect)frame {
    CGFloat radius = MIN(frame.size.width, frame.size.height);
    CGFloat totalHeight = radius + kZCSpaceBetweenCircleAndText + self.textLayerHeight;
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, totalHeight);
}

- (void)redisplay {
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
    _circleLayer.bounds = CGRectMake(0, 0, radius, radius);
    _circleLayer.position = CGPointMake(self.bounds.size.width / 2, radius / 2);
    _textLayer.frame = CGRectMake(0, _circleLayer.frame.origin.y + _circleLayer.frame.size.height + kZCSpaceBetweenCircleAndText, self.bounds.size.width, self.textLayerHeight);
    [_textLayer setNeedsDisplay];
}

#pragma mark - animations

- (void)successAnimation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGFloat width = self.circleLayer.bounds.size.width;
    CGFloat height = self.circleLayer.bounds.size.height;
    shapeLayer.position = CGPointMake((self.bounds.size.width - width) / 2, (self.bounds.size.height - height) / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width / 4, height / 2)];
    [path addLineToPoint:CGPointMake(width / 10 * 4.5, height / 8 * 6.5)];
    [path addLineToPoint:CGPointMake(width / 10 * 7.5, height / 8 * 2.2)];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = MAX(3, self.borderWidth);
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0f);
    endAnimation.toValue = @(1.0f);
    endAnimation.removedOnCompletion = YES;
    [shapeLayer addAnimation:endAnimation forKey:@"ZCHudSuccessKey"];
    
    [self.circleLayer fillFullCircle];
}

- (void)failtureAnimation {
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    CAShapeLayer *rightLayer = [CAShapeLayer layer];
    
    CGFloat width = self.circleLayer.bounds.size.width;
    CGFloat height = self.circleLayer.bounds.size.height;
    CGFloat offset = MAX(3, self.borderWidth) / 2;
    
    leftLayer.position = CGPointMake((self.bounds.size.width - width) / 2, (self.bounds.size.height - height) / 2);
    rightLayer.position = leftLayer.position;
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(width / 4 + offset, height / 4 + offset)];
    [rightPath addLineToPoint:CGPointMake(width / 4 * 3 - offset, height / 4 * 3 - offset)];
    
    rightLayer.path = rightPath.CGPath;
    rightLayer.lineWidth = MAX(3, self.borderWidth);
    rightLayer.strokeColor = [UIColor redColor].CGColor;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:rightLayer];
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(width / 4 * 3 - offset, height / 4 + offset)];
    [leftPath addLineToPoint:CGPointMake(width / 4 + offset, height / 4 * 3 - offset)];
    
    leftLayer.path = leftPath.CGPath;
    leftLayer.lineWidth = MAX(3, self.borderWidth);
    leftLayer.strokeColor = [UIColor redColor].CGColor;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:leftLayer];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0f);
    endAnimation.toValue = @(1.0f);
    endAnimation.removedOnCompletion = YES;
    [leftLayer addAnimation:endAnimation forKey:@"ZCHudFailureKey"];
    [rightLayer addAnimation:endAnimation forKey:@"ZCHudFailureKey"];
    
    [self.circleLayer fillFullCircle];
}

#pragma mark - setter and getter methods

- (void)setBorderColor:(UIColor *)circleBorderColor {
    _borderColor = circleBorderColor;
    _circleLayer.circleBorderColor = circleBorderColor;
}

- (void)setBorderWidth:(CGFloat)circleBorderWidth {
    _borderWidth = circleBorderWidth;
    _circleLayer.circleBorderWidth = circleBorderWidth;
}

- (void)setText:(NSString *)text {
    if ([text isEqualToString:_text]) {
        return;
    }
    _text = text;
    _textLayer.text = text;
    [self setFrame:self.frame];
}

- (void)setFrame:(CGRect)frame {
    self.textLayerHeight = [self.textLayer heightWithWidth:frame.size.width];
    [super setFrame:[self realFrame:frame]];
    [self redisplay];
}

@end
