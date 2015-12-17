//
//  ZCHud.h
//  ZCHud
//
//  Created by charles on 15/12/8.
//  Copyright © 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCHud : UIView

@property (nonatomic, assign) CGFloat  borderWidth;
@property (nonatomic, strong) UIColor  *borderColor;
@property (nonatomic, copy)   NSString *text;
- (void)successAnimation;
- (void)failtureAnimation;

@end
