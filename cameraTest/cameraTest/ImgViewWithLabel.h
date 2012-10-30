//
//  ImgViewWithLabel.h
//  scrollTest
//
//  Created by Hang Chen on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgViewWithLabel : UIView
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSString *imgText;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image andLabel:(NSString*)text;
@end
