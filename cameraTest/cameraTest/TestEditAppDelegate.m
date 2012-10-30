//
//  TestEditAppDelegate.m
//  cameraTest
//
//  Created by Hang Chen on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestEditAppDelegate.h"

#import "TestEditViewController.h"
#import "CameraBackViewController.h"
#import <BugSense-iOS/BugSenseCrashController.h>

@implementation TestEditAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize camNavController;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    self.camNavController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *myStuff = [NSDictionary dictionaryWithObjectsAndKeys:@"myObject", @"myKey", nil];
    [BugSenseCrashController sharedInstanceWithBugSenseAPIKey:@"5fb256c1" 
                                               userDictionary:myStuff 
                                              sendImmediately:NO];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    
    CameraBackViewController *cameraBackController;
    
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CamNavController" owner:self options:nil];
    self.camNavController = [topLevelObjects objectAtIndex:0];
    
    cameraBackController = (CameraBackViewController*)self.camNavController.topViewController;
    
    CameraViewController *camController = [[CameraViewController alloc] initWithNibName:@"TestCameraViewController" bundle:nil];
    camController.camImageDelegate = self;
    self.viewController = camController;
    [camController release];
    
    
    
    cameraBackController.camController = self.viewController;
    
    self.window.rootViewController = self.camNavController;
   
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    /*if (!self.viewController.modalViewisShowing) {
        //[self.viewController.irisView closeIris];
    }*/
    [self.viewController stopRecordingPicture];
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.viewController startRecordingPicture];
    /*if (!self.viewController.modalViewisShowing) {
        //[self.viewController.irisView openIris];

    }*/
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    [self.camNavController dismissModalViewControllerAnimated:YES];

}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    
    
        
    [self.camNavController dismissModalViewControllerAnimated:YES];
    

    

}

- (void)needPresentAviary:(UIImage*)image {
    
    
    
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:image];
    [editorController setDelegate:self.viewController];
    
    

    
    editorController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.camNavController presentModalViewController:editorController animated:YES];
    
    [editorController release];
    

    
}


@end
