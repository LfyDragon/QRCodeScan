//
//  QRCodeView.m
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/9/18.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import "QRCodeView.h"

@implementation QRCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] set];
    
    CGRect topRect = CGRectMake(0, 0, UIScreen_Width, self.iFocusFrame.origin.y);
    CGContextFillRect(ref, topRect);
    
    CGRect leftRect = CGRectMake(0, self.iFocusFrame.origin.y, self.iFocusFrame.origin.x, self.iFocusFrame.size.height);
    CGContextFillRect(ref, leftRect);
    
    CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(self.iFocusFrame), UIScreen_Width, UIScreen_Height-CGRectGetMaxY(self.iFocusFrame));
    CGContextFillRect(ref, bottomRect);
    
    CGRect rightRect = CGRectMake(CGRectGetMaxX(self.iFocusFrame), self.iFocusFrame.origin.y, UIScreen_Width-CGRectGetMaxX(self.iFocusFrame), self.iFocusFrame.size.height);
    CGContextFillRect(ref, rightRect);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
