//
//  TestEditAppDelegate.h
//  cameraTest
//
//  Created by Hang Chen on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPhotoEditorController.h"
#import "TestEditViewController.h"
@class CameraViewController;

@interface TestEditAppDelegate : UIResponder <UIApplicationDelegate,AFPhotoEditorControllerDelegate,CameraViewControllerDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *camNavController;
@property (retain, nonatomic) CameraViewController *viewController;

@end
