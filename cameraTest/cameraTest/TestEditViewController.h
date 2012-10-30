//
//  TestEditViewController.h
//  cameraTest
//
//  Created by Hang Chen on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>
#import "XBFilteredCameraView.h"
#import "CameraTargetView.h"
#import "ChanCameraGridView.h"
#import "ISIrisView.h"
#import "AboutViewController.h"
#import "AFPhotoEditorController.h"


@protocol CameraViewControllerDelegate <NSObject>

- (void)needPresentAviary:(UIImage*)image;

@end

@class ExpandableNavigation;

@class ISIrisView;
@interface CameraViewController : UIViewController <XBFilteredCameraViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AboutViewControllerDelegate,AFPhotoEditorControllerDelegate>
{
    //AFPhotoEditorController *_editorController;
}

@property (retain, nonatomic) IBOutlet XBFilteredCameraView *cameraView;
@property (retain, nonatomic) IBOutlet CameraTargetView *cameraTargetView;
@property (retain, nonatomic) IBOutlet UIButton *camChangeBtn;
@property (retain, nonatomic) IBOutlet UIImageView *cameraRollImg;
@property (retain, nonatomic) IBOutlet UIButton *cameraRollBtn;
@property (retain, nonatomic) IBOutlet UIButton *filterBtn;
@property (retain, nonatomic) IBOutlet ChanCameraGridView *gridView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic,retain)NSMutableArray *imgArray;
@property(nonatomic,assign)NSUInteger currentHightIndex;

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;
@property (nonatomic, retain) IBOutlet UIButton *mainBtn;
@property (nonatomic, retain) ISIrisView *irisView;

@property (retain) ExpandableNavigation* navigation;
@property (nonatomic, retain) IBOutlet UIButton *cameraTakeBtn;
@property (nonatomic, assign)id<CameraViewControllerDelegate>camImageDelegate;
- (IBAction) touchMenuItem:(id)sender;


- (IBAction)takeAPictureButtonTouchUpInside:(id)sender;
- (IBAction)changeFilterButtonTouchUpInside:(id)sender;
- (IBAction)cameraButtonTouchUpInside:(id)sender;
- (IBAction)filterSelectBtn:(id)sender;
- (IBAction)pickPhotoInCameraRoll:(id)sender;

- (void)startRecordingPicture;
- (void)stopRecordingPicture;
@end

