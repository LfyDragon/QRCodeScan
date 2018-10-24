//
//  QRCodeAnimationView.m
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/9/19.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import "QRCodeAnimationView.h"

@interface QRCodeAnimationView()

@property (nonatomic, assign) CGFloat lineY;
@property (nonatomic, strong) NSTimer *lineTimer;
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation QRCodeAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    UIImageView *boardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    boardImageView.image = [UIImage imageNamed:@"board"];
    [self addSubview:boardImageView];
    
    self.lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    self.lineImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:self.lineImageView];
    
    self.lineY = 0;
    self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.lineTimer forMode:NSRunLoopCommonModes];
}

-(void)lineAnimation{
    
    self.lineY +=1;
    if (self.lineY>=self.frame.size.height-self.lineImageView.frame.size.height) {
        self.lineY = 0;
    }
    
    
    [UIView animateWithDuration:0.01 animations:^{
        CGRect rect = self.lineImageView.frame;
        rect.origin.y = self.lineY;
        self.lineImageView.frame = rect;
    }];
    
    
    
}

-(void)startAnimation{
    [self.lineTimer setFireDate:[NSDate date]];
}

-(void)stopAnimation{
    [self.lineTimer setFireDate:[NSDate distantFuture]];
}

-(void)dealloc{
    [self.lineTimer invalidate];
    self.lineTimer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
