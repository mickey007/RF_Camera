//
//  ChanCameraGridView.m
//  
//
//  Created by Yong Li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChanCameraGridView.h"

@implementation ChanCameraGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    [super drawRect:rect];
    
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x+rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y+rect.size.height;
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, left, top+height/3);
    CGContextAddLineToPoint(context, right, top+height/3);
    CGContextMoveToPoint(context, left, top+height*2.f/3);
    CGContextAddLineToPoint(context, right, top+height*2.f/3);
    
    CGContextMoveToPoint(context, left+width/3, top);
    CGContextAddLineToPoint(context, left+width/3, bottom);
    CGContextMoveToPoint(context, left+width*2/3, top);
    CGContextAddLineToPoint(context, left+width*2/3, bottom);
    
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathStroke);

}

@end
