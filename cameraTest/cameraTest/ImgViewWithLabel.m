//
//  ImgViewWithLabel.m
//  scrollTest
//
//  Created by Hang Chen on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImgViewWithLabel.h"
#import <QuartzCore/QuartzCore.h>

#define IMG_SIZE 44
@implementation ImgViewWithLabel
@synthesize image;
@synthesize imgText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)aImage andLabel:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        NSUInteger xPadding = (frame.size.width - IMG_SIZE) / 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPadding, 5, IMG_SIZE, IMG_SIZE)];
        
        imageView.image = aImage;
        imageView.layer.cornerRadius = 4.0f;
        imageView.clipsToBounds = YES;
        UILabel *imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IMG_SIZE, frame.size.width, 15)];
        imgLabel.backgroundColor = [UIColor clearColor];
        imgLabel.font = [UIFont boldSystemFontOfSize:11];
        imgLabel.text = text;
        imgLabel.textColor = [UIColor whiteColor];
        imgLabel.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:imageView];
        [self addSubview:imgLabel];
        [imgLabel release];
        [imageView release];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    self.image = nil;
    self.imgText = nil;
    [super dealloc];
}
@end
