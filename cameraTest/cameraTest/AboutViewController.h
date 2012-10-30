//
//  AboutViewController.h
//  cameraTest
//
//  Created by Hang Chen on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AboutViewController;
@protocol AboutViewControllerDelegate<NSObject>
- (void)closeAboutView:(AboutViewController*)viewController;
@end
@interface AboutViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIWebView *webview;
@property(nonatomic,assign)id<AboutViewControllerDelegate>aboutDelegate;
@end
