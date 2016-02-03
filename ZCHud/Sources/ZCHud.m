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

static double const kZCSpaceBetweenCircleAndText = 10;

typedef void (^zcTouchHandler) (ZCHud *hud);

@interface ZCHud ()

@property (nonatomic, strong) ZCCircleLayer          *circleLayer;
@property (nonatomic, strong) ZCTextLayer            *textLayer;

@property (nonatomic, assign) CGFloat                textLayerHeight;
@property (nonatomic, assign) CGRect                 oriRect;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy  ) zcTouchHandler         touchHandler;

@end

@implementation ZCHud

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

#pragma mark - public methods

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    bgView.tag = 'ZCBG';
    [window addSubview:bgView];
    [window addSubview:self];
    
    if (CGRectEqualToRect(_oriRect, CGRectZero)) {
        self.frame = CGRectMake(0, 0, 100, 100);
    }
    self.center = window.center;
    _oriRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, _oriRect.size.width, _oriRect.size.height);
}

- (void)showInView:(UIView *)view {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    bgView.tag = 'ZCBG';
    [view addSubview:bgView];
    [view addSubview:self];
    
    if (CGRectEqualToRect(_oriRect, CGRectZero)) {
        self.frame = CGRectMake(0, 0, 100, 100);
    }
    self.center = view.center;
    _oriRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, _oriRect.size.width, _oriRect.size.height);
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[self.superview viewWithTag:'ZCBG'] removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)hideInSuccessAnimationWithText:(NSString *)text duration:(NSTimeInterval)time {
    [self hideWithAnimation:YES text:text duration:time];
}

- (void)hideInFailureAnimationWithText:(NSString *)text duration:(NSTimeInterval)time {
    [self hideWithAnimation:NO text:text duration:time];
}

- (void)hudTouched:(void (^) (ZCHud *hud))handler {
    _touchHandler = handler;
    for (UITapGestureRecognizer *tapGesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:tapGesture];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTouchAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - private methods

- (void)hideWithAnimation:(BOOL)isSuc text:(NSString *)text duration:(NSTimeInterval)time {
    NSTimeInterval animationDuration = 0.25;
    if (time >= 0.25 && time <= 0.5) {
        animationDuration = time;
    }
    else if (time > 0.5) {
        animationDuration = 0.5;
    }
    if (isSuc) {
        [self successAnimationInDuration:animationDuration];
    }
    else {
        [self failtureAnimationInDuration:animationDuration];
    }
    
    [self setText:text];
    
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(t, dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)doTouchAction {
    !self.touchHandler ? : self.touchHandler(self);
}

#pragma mark - setup UI

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor colorWithRed:70 / 255.f green:70 / 255.f blue:70 / 255.f alpha:1].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeZero;
    
    _circleLayer = [ZCCircleLayer layer];
    _circleLayer.shouldRasterize = YES;
    [self.layer addSublayer:_circleLayer];
    [self.circleLayer startRotation];

    _textLayer = [ZCTextLayer layer];
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_textLayer];
    
    if (!CGRectEqualToRect(self.oriRect, CGRectZero)) {
        [self setFrame:self.oriRect];
    }
}

- (CGRect)realFrame:(CGRect)frame {
    CGFloat radius = MIN(frame.size.width, frame.size.height);
    NSInteger count = _text.length > 0 ? 3 : 2;
    CGFloat totalHeight = radius / 2 + kZCSpaceBetweenCircleAndText * count + _textLayerHeight;
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, totalHeight);
}

- (void)redisplay {
    CGFloat radius = MIN(_oriRect.size.width, _oriRect.size.height);
    _circleLayer.bounds = CGRectMake(0, 0, radius / 2, radius / 2);
    _circleLayer.position = CGPointMake(self.bounds.size.width / 2, radius / 4 + kZCSpaceBetweenCircleAndText);
    [_circleLayer setNeedsDisplay];
    _textLayer.frame = CGRectMake(0, _circleLayer.frame.origin.y + _circleLayer.frame.size.height + kZCSpaceBetweenCircleAndText, self.bounds.size.width, _textLayerHeight);
    [_textLayer setNeedsDisplay];
}

#pragma mark - animations

- (void)successAnimationInDuration:(NSTimeInterval)duration {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGFloat width = _circleLayer.bounds.size.width;
    CGFloat height = _circleLayer.bounds.size.height;
    shapeLayer.position = CGPointMake((self.bounds.size.width - width) / 2, (self.bounds.size.height - height) / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width / 4, height / 2)];
    [path addLineToPoint:CGPointMake(width / 10 * 4.5, height / 8 * 6.5)];
    [path addLineToPoint:CGPointMake(width / 10 * 7.5, height / 8 * 2.2)];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = MAX(3, _borderWidth);
    shapeLayer.strokeColor = [UIColor colorWithRed:37 / 255.f green:146 / 255.f blue:227 / 255. alpha:1].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0f);
    endAnimation.toValue = @(1.0f);
    endAnimation.removedOnCompletion = YES;
    endAnimation.duration = duration;
    [shapeLayer addAnimation:endAnimation forKey:@"ZCHudSuccessKey"];
    
    [_circleLayer fillFullCircleWithDuration:duration];
}

- (void)failtureAnimationInDuration:(NSTimeInterval)duration {
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    CAShapeLayer *rightLayer = [CAShapeLayer layer];
    
    CGFloat width = _circleLayer.bounds.size.width;
    CGFloat height = _circleLayer.bounds.size.height;
    CGFloat offset = MAX(3, _borderWidth) / 2;
    
    leftLayer.position = CGPointMake((self.bounds.size.width - width) / 2, (self.bounds.size.height - height) / 2);
    rightLayer.position = leftLayer.position;
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(width / 4 + offset, height / 4 + offset)];
    [rightPath addLineToPoint:CGPointMake(width / 4 * 3 - offset, height / 4 * 3 - offset)];
    
    rightLayer.path = rightPath.CGPath;
    rightLayer.lineWidth = MAX(3, _borderWidth);
    rightLayer.strokeColor = [UIColor redColor].CGColor;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:rightLayer];
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(width / 4 * 3 - offset, height / 4 + offset)];
    [leftPath addLineToPoint:CGPointMake(width / 4 + offset, height / 4 * 3 - offset)];
    
    leftLayer.path = leftPath.CGPath;
    leftLayer.lineWidth = MAX(3, _borderWidth);
    leftLayer.strokeColor = [UIColor redColor].CGColor;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:leftLayer];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0f);
    endAnimation.toValue = @(1.0f);
    endAnimation.removedOnCompletion = YES;
    endAnimation.duration = duration;
    [leftLayer addAnimation:endAnimation forKey:@"ZCHudFailureKey"];
    [rightLayer addAnimation:endAnimation forKey:@"ZCHudFailureKey"];
    
    [_circleLayer fillFullCircleWithDuration:duration];
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
    [self setFrame:_oriRect];
}

- (void)setFrame:(CGRect)frame {
    _oriRect = frame;
    if (!_circleLayer) {
        return;
    }
    self.textLayerHeight = [_textLayer heightWithWidth:frame.size.width];
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        [super setFrame:[self realFrame:frame]];
    }
    else {
        _textLayer.opacity = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [super setFrame:[self realFrame:frame]];
        } completion:^(BOOL finished) {
            _textLayer.opacity = 1;
        }];
    }
    [self redisplay];
}

@end
