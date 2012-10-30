//
//  CameraBackViewController.h
//  cameraTest
//
//  Created by Hang Chen on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestEditViewController.h"

@interface CameraBackViewController : UIViewController
@property(nonatomic,retain)CameraViewController *camController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCameraController:(CameraViewController*)controller;


@end
