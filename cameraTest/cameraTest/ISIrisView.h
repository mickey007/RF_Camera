//
//  ISIrisView.h
//  IrisViewDemo
//
//  Created by yoyokko on 11-2-27.
//  Copyright 2011 yoyokko@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {ISIrisViewOpen = 1,ISIrisViewClose,ISIrisViewShutter}ISIrisViewAnimation;
typedef void (^ISIrisAnimationBlock)(ISIrisViewAnimation);


@interface ISIrisView : UIView
{
@private
    ISIrisViewAnimation   currentAction_;
    UIImageView *statisIrisView_;
    ISIrisAnimationBlock completedBlock_;
}


- (void) openIris;
- (void) openIrisAnimationDuration:(CGFloat)duration;
- (void) openIrisWithCompleteBlock:(ISIrisAnimationBlock)block andDuration:(CGFloat)duration;
- (void) closeIris;
- (void) closeIrisAnimationDuration:(CGFloat)duration;
- (void) closeIrisWithCompleteBlock:(ISIrisAnimationBlock)block andDuration:(CGFloat)duration;
- (void) shutterIris;
- (void) shutterIrisAnimationDuration:(CGFloat)duration;
- (void) shutterIrisWithCompleteBlock:(ISIrisAnimationBlock)block andDuration:(CGFloat)duration;

@end
