//
//  ZCTextLayer.m
//  ZCHud
//
//  Created by charles on 15/12/15.
//  Copyright © 2015年 charles. All rights reserved.
//

#import "ZCTextLayer.h"
#import <CoreText/CoreText.h>

static double const ZCLineSpace = 4;

@implementation ZCTextLayer

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:17];
    }
    return _font;
}

- (UIColor *)fontColor {
    if (!_fontColor) {
        _fontColor = [UIColor colorWithRed:70 / 255.f green:70 / 255.f blue:70 / 255.f alpha:1];
    }
    return _fontColor;
}

- (NSAttributedString *)attributedString {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableDictionary *attributes = [@{} mutableCopy];
    attributes[NSForegroundColorAttributeName] = self.fontColor;
    attributes[NSFontAttributeName] = self.font;
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = ZCLineSpace;
    attributes[NSParagraphStyleAttributeName] = style;
    [text addAttributes:attributes range:NSMakeRange(0, text.length)];
    
    return text;
}

- (CGFloat)heightForSelf {
    if (self.text.length == 0) {
        return 0;
    }
    else {
        NSAttributedString *text = [self attributedString];
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, self.bounds.size.width, CGFLOAT_MAX));
        CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
        CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, text.length), pathRef, NULL);
    
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CFIndex lineCount = CFArrayGetCount(lines);
        
        CGFloat totalHeight = 0;
        
        CGFloat ascent,descent;
        for (CFIndex i = 0;i < lineCount;i++) {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            totalHeight += (ascent + descent + ZCLineSpace);
        }
        
        CFRelease(frameRef);
        CFRelease(setterRef);
        CFRelease(pathRef);
        
        return ceil(totalHeight) ;
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    if (self.text.length == 0) {
        return;
    }
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, self.bounds);
    
    NSAttributedString *text = [self attributedString];
    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, text.length), pathRef, NULL);

    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOriPoints[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOriPoints);

    CGFloat y = 0;
    for (CFIndex i = 0;i < lineCount;i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat ascent,descent,leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGPoint oriPoint = lineOriPoints[i];
        if (i == 0) {
            y = oriPoint.y;
        }
        else {
            y = y - ZCLineSpace - ascent;
            oriPoint.y = y;
        }
        
        CGContextSetTextPosition(ctx, oriPoint.x, oriPoint.y);
        CTLineDraw(line, ctx);
        
        y -= descent;
    }
    
    CFRelease(frameRef);
    CFRelease(setterRef);
    CFRelease(pathRef);
}

@end
