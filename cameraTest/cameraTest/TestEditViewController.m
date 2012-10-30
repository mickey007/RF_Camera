//
//  TestEditViewController.m
//  cameraTest
//
//  Created by Hang Chen on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImgViewWithLabel.h"
#import "ExpandableNavigation.h"
#import "AboutViewController.h"
#import "ISIrisView.h"
#import "Toast+UIView.h"
#import "TestEditAppDelegate.h"
#define IMH_SIZE 44
#define PADDING 10

#define FLASH_AUTO_HINT NSLocalizedString(@"Auto mode",@"")
#define FLASH_NO_HINT   NSLocalizedString(@"No flash",@"")
#define FLASH_ALWAYS_HINT NSLocalizedString(@"Forced Flash",@"")
#define GRID_MODE_HINT NSLocalizedString(@"Grid mode",@"")
#define GRID_MODE_OFF_HINT NSLocalizedString(@"Plain mode",@"")
NSString *filterName[] = {@"Original",@"LA",@"New York",@"Paris",@"Tokyo",@"London",@"Honolulu",@"CA",@"Dubai",@"Madrid",@"Beijing",@"Sydney"};

@interface CameraViewController ()
{
    NSArray *paths;
    int filterIndex;
    BOOL firstLoad_;
}
@property(nonatomic,retain)UIView *mastView;
- (void)setHightLight:(NSUInteger)index;
- (void)imgLabelClicked:(UIGestureRecognizer*)recognizer;
- (void)updateLibraryButton: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo; 
- (void)setupMenus;
- (void)collapseAllItems;
- (void)showAviary:(UIImage*)image;
- (void)openShutterAndPresentAviary:(UIImage*)image;
- (void)gotoReview;
@end









@implementation CameraViewController
@synthesize cameraView;// = _cameraView;
@synthesize cameraTargetView;// = _cameraTargetView;
@synthesize camChangeBtn;
@synthesize cameraRollBtn;
@synthesize cameraRollImg;
@synthesize filterBtn;
@synthesize gridView;
@synthesize scrollView;
@synthesize contentView;
@synthesize imgArray;
@synthesize currentHightIndex;
@synthesize mastView;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize mainBtn;
@synthesize navigation;
@synthesize irisView;
@synthesize cameraTakeBtn;
@synthesize camImageDelegate;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstLoad_ = YES;
    filterBtn.showsTouchWhenHighlighted = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTapAction:)];
    tgr.delegate = self;
    [self.cameraView addGestureRecognizer:tgr];
    [tgr release];
    [self.cameraTargetView hideAnimated:NO];
    
    [self loadFilters];
    filterIndex = 1;
    NSArray *files =  [paths objectAtIndex:0];
    
    NSError *error = nil;
    if (![self.cameraView setFilterFragmentShadersFromFiles:files error:&error]) {
        NSLog(@"Error setting shader: %@", [error localizedDescription]);
    }
    
    //self.cameraView.flashMode = XBFlashModeOn;
    
    
    self.cameraRollImg.layer.cornerRadius = 4.0f;
    self.cameraRollImg.clipsToBounds = YES;
    self.cameraRollImg.layer.borderWidth = 1.0f;
    [self updateLibraryButton:nil didFinishSavingWithError:nil contextInfo:nil];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (IMH_SIZE + PADDING * 2) * 12, 64)];
    self.contentView = tempView;
    [tempView release];
    [self.scrollView setContentSize:self.contentView.frame.size];
    [self.scrollView addSubview:self.contentView];
    NSUInteger xpos = 0;
    NSMutableArray *viewArray = [NSMutableArray array];
    self.imgArray = viewArray;
    for (NSUInteger i = 0; i < 12; i++) {
        
        NSString *fileName = [NSString stringWithFormat:@"IMG_0%02d@2x.JPG",i];
        CGRect frameRect = CGRectMake(xpos, 0, IMH_SIZE + PADDING * 2, 64);
        UITapGestureRecognizer *recg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLabelClicked:)];
        recg.numberOfTapsRequired = 1;
        recg.numberOfTouchesRequired = 1;
        
        ImgViewWithLabel *tempImgLabel = [[ImgViewWithLabel alloc] initWithFrame:frameRect andImage:[UIImage imageNamed:fileName] andLabel:filterName[i]];
        tempImgLabel.userInteractionEnabled = YES;
        
        [tempImgLabel addGestureRecognizer:recg];
        [recg release];
        [[self contentView] addSubview:tempImgLabel];
        [viewArray addObject:tempImgLabel];
        [tempImgLabel release];
        xpos += (IMH_SIZE + PADDING * 2);
        NSLog(@"%u",xpos);
    }
    self.currentHightIndex = 0;
    UIView *tempMaskView = [[UIView alloc] initWithFrame:CGRectMake(22, 60, 20, 3)];
    self.mastView = tempMaskView;
    [tempMaskView release];
    self.mastView.backgroundColor = [UIColor blueColor];
    self.mastView.alpha = 0.6;
    [[self contentView] addSubview:self.mastView];
    [self setupMenus];
    
    ISIrisView *irisTempView = [[ISIrisView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.irisView = irisTempView;
    [self.view addSubview:irisTempView];
    [irisTempView release];
    
}

- (void)viewDidUnload
{
    [self stopRecordingPicture];
    
    self.cameraView = nil;
    self.cameraTargetView = nil;
    self.camChangeBtn = nil;
    self.cameraRollBtn = nil;
    self.cameraRollImg = nil;
    self.filterBtn = nil;
    self.gridView = nil;
    self.scrollView = nil;
    self.contentView = nil;
    self.imgArray = nil;
    self.mastView = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.mainBtn = nil;
    self.navigation = nil;
    self.irisView = nil;
    self.cameraTakeBtn = nil;
    
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstLoad_) {
        firstLoad_ = NO;
        [self.irisView openIrisWithCompleteBlock:^(ISIrisViewAnimation type){
            [self startRecordingPicture];
        } andDuration:0.5];
    }
    else {
        [self startRecordingPicture];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRecordingPicture];
}

- (void)dealloc {
    [self stopRecordingPicture];
    self.cameraView = nil;
    self.cameraTargetView = nil;
    self.camChangeBtn = nil;
    self.cameraRollBtn = nil;
    self.cameraRollImg = nil;
    self.filterBtn = nil;
    self.gridView = nil;
    self.scrollView = nil;
    self.contentView = nil;
    self.imgArray = nil;
    self.mastView = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.mainBtn = nil;
    self.navigation = nil;
    self.irisView = nil;
    self.cameraTakeBtn = nil;
    [paths release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Methods

- (void)loadFilters
{
    NSString *luminancePath = [[NSBundle mainBundle] pathForResource:@"LuminanceFragmentShader" ofType:@"glsl"];
    NSString *hBlurPath = [[NSBundle mainBundle] pathForResource:@"HGaussianBlur" ofType:@"glsl"];
    NSString *vBlurPath = [[NSBundle mainBundle] pathForResource:@"VGaussianBlur" ofType:@"glsl"];
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"DefaultFragmentShader" ofType:@"glsl"];
    NSString *discretizePath = [[NSBundle mainBundle] pathForResource:@"DiscretizeShader" ofType:@"glsl"];
    NSString *pixelatePath = [[NSBundle mainBundle] pathForResource:@"PixelateShader" ofType:@"glsl"];
    NSString *suckPath = [[NSBundle mainBundle] pathForResource:@"SuckShader" ofType:@"glsl"];
    
    // Setup a combination of these filters
    paths = [[NSArray alloc] initWithObjects:
             [NSArray arrayWithObjects:defaultPath, nil],
             [NSArray arrayWithObjects:suckPath, nil],
             [NSArray arrayWithObjects:pixelatePath, nil],
             [NSArray arrayWithObjects:discretizePath, nil],
             [NSArray arrayWithObjects:discretizePath,pixelatePath, nil],
             [NSArray arrayWithObjects:luminancePath, nil], 
             [NSArray arrayWithObjects:luminancePath, pixelatePath,nil], 
             [NSArray arrayWithObjects:hBlurPath, nil],
             [NSArray arrayWithObjects:hBlurPath, discretizePath, nil],
             [NSArray arrayWithObjects:vBlurPath, nil],
             [NSArray arrayWithObjects:hBlurPath, vBlurPath, nil],
             [NSArray arrayWithObjects:luminancePath, hBlurPath, vBlurPath, nil], nil];
}

#pragma mark - Button Actions

- (IBAction)takeAPictureButtonTouchUpInside:(id)sender 
{
    
    self.cameraTakeBtn.enabled = NO;
    self.cameraRollBtn.enabled = NO;
    [self.irisView closeIrisWithCompleteBlock:^(ISIrisViewAnimation type) {
        [self.cameraView takeAPhotoWithCompletion:^(UIImage *image) {
            
            [self performSelectorOnMainThread:@selector(openShutterAndPresentAviary:) withObject:image waitUntilDone:NO];
            
            
        }];
    } andDuration:0.1];
    
    
    
    
    
    
    

    
}

- (void)openShutterAndPresentAviary:(UIImage*)image {
    [self.irisView openIrisWithCompleteBlock:^(ISIrisViewAnimation type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cameraRollBtn.enabled = YES;
            self.cameraTakeBtn.enabled = YES;
            if (image) {
                [self showAviary:image];
            }
        });
        
        
    } andDuration:0.1];
}


- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(updateLibraryButton:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    
    
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    
    
    
}



- (void)showAviary:(UIImage*)image {
    
    if (self.camImageDelegate && [self.camImageDelegate respondsToSelector:@selector(needPresentAviary:)]) {
        [self.camImageDelegate needPresentAviary:image];
    }
}


- (IBAction)changeFilterButtonTouchUpInside:(id)sender
{
    NSArray *files = [paths objectAtIndex:filterIndex];
    
    NSError *error = nil;
    if (![self.cameraView setFilterFragmentShadersFromFiles:files error:&error]) {
        NSLog(@"Error setting shader: %@", [error localizedDescription]);
    }
    
    filterIndex++;
    if (filterIndex > paths.count - 1) {
        filterIndex = 0;
    }
}

- (IBAction)cameraButtonTouchUpInside:(id)sender 
{
    self.cameraView.cameraPosition = self.cameraView.cameraPosition == XBCameraPositionBack? XBCameraPositionFront: XBCameraPositionBack;
    [self collapseAllItems];
}

#pragma mark - Gesture recognition

- (void)cameraViewTapAction:(UITapGestureRecognizer *)tgr
{
    if (tgr.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [tgr locationInView:self.cameraView];
        if ([self.cameraView.device isFocusModeSupported:AVCaptureFocusModeAutoFocus] &&
            [self.cameraView.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            self.cameraView.focusPoint = location;
        }
        
        self.cameraView.exposurePoint = location;
        self.cameraTargetView.center = self.cameraView.exposurePoint;
        [self.cameraTargetView showAnimated:YES];
        [self collapseAllItems];
    }
}

#pragma mark - XBFilteredCameraViewDelegate

- (void)filteredCameraViewDidBeginAdjustingFocus:(XBFilteredCameraView *)filteredCameraView
{
    // NSLog(@"Focus point: %f, %f", self.cameraView.focusPoint.x, self.cameraView.focusPoint.y);
}

- (void)filteredCameraViewDidFinishAdjustingFocus:(XBFilteredCameraView *)filteredCameraView
{
    // NSLog(@"Focus point: %f, %f", self.cameraView.focusPoint.x, self.cameraView.focusPoint.y);
    [self.cameraTargetView hideAnimated:YES];
}

- (void)filteredCameraViewDidFinishAdjustingExposure:(XBFilteredCameraView *)filteredCameraView
{
    [self.cameraTargetView hideAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
    if ([touch.view isDescendantOfView:camChangeBtn] || 
        [touch.view isDescendantOfView:self.scrollView] ||
        [touch.view isDescendantOfView:self.mainBtn] ||
        [touch.view isDescendantOfView:self.button1] ||
        [touch.view isDescendantOfView:self.button2] ||
        [touch.view isDescendantOfView:self.button3] ||
        [touch.view isDescendantOfView:self.button4] ||
        [touch.view isDescendantOfView:self.button5]) {
        // we touched our control surface
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}
- (void)updateLibraryButton:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (image) {
        cameraRollImg.image = image;
        return;
    }
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
    {
        if (group == nil) 
        {
            return;
        }
        *stop = YES;
        
        __block int num = 0;
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
         {         
             if(result == nil) 
             {
                 return;
             }
             num++;
             if(num==[group numberOfAssets]){
                 UIImage* img = [UIImage imageWithCGImage:[result thumbnail]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[_cameraRollButton setImage:img forState:UIControlStateNormal];
                     cameraRollImg.image = img;
                 });
             }
             
         }];
    };
    
    // Group Enumerator Failure Block
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        UIImage* img = [UIImage imageNamed:@"photo_Library.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[_cameraRollButton setImage:img forState:UIControlStateNormal];
            cameraRollImg.image = img;
        });
        
        	                                 
    };	
    // Enumerate Albums
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:assetGroupEnumerator 
                         failureBlock:assetGroupEnumberatorFailure];
    [library release];
}
- (IBAction)filterSelectBtn:(id)sender {
    CGRect frame = self.scrollView.frame;
    CGFloat baseY = self.view.frame.size.height - 54 - 64 + 2;
    
    
    if (frame.origin.y > baseY) {//Show
        frame.origin.y = baseY;
    }
    else {
        frame.origin.y = baseY + 64;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.frame = frame;
    }];
}

- (void)setHightLight:(NSUInteger)index {
    if (self.currentHightIndex != index) {
        self.currentHightIndex = index;
        ImgViewWithLabel *tempImgLabel = [self.imgArray objectAtIndex:index];
        [UIView animateWithDuration:0.5 animations:^{
            self.mastView.frame = CGRectMake(tempImgLabel.frame.origin.x + 22, 60, 20, 3);
        }];
        
    }
}

- (void)imgLabelClicked:(UIGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        ImgViewWithLabel *tempImgLabel = (ImgViewWithLabel*)[recognizer view];
        NSUInteger index = [self.imgArray indexOfObject:tempImgLabel];
        [self setHightLight:index];
        
        NSArray *files = [paths objectAtIndex:index];
        
        NSError *error = nil;
        if (![self.cameraView setFilterFragmentShadersFromFiles:files error:&error]) {
            NSLog(@"Error setting shader: %@", [error localizedDescription]);
        }
        
        
    }
    
}

- (IBAction)pickPhotoInCameraRoll:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:NO];
    if (image) {
        [self showAviary:image];
 
    }
    else {
    }
    
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction) touchMenuItem:(id)sender {
    
    if (sender == button1) {
        if (self.cameraView.device.hasFlash && 
            self.cameraView.flashMode != XBFlashModeAuto) {
            self.cameraView.flashMode = XBFlashModeAuto;
        }
        [self.view makeToast:FLASH_AUTO_HINT 
                    duration:2.0
                    position:@"center"
                       image:[UIImage imageNamed:@"tip.png"]];
    }
    else if(sender == button2) {
        if (self.cameraView.device.hasFlash && 
            self.cameraView.flashMode != XBFlashModeOn) {
            self.cameraView.flashMode = XBFlashModeOn;
        }
        [self.view makeToast:FLASH_ALWAYS_HINT 
                    duration:2.0
                    position:@"center"
                       image:[UIImage imageNamed:@"tip.png"]];
    }
    else if(sender == button3) {
        if (self.cameraView.device.hasFlash &&
            self.cameraView.flashMode != XBFlashModeOff) {
            self.cameraView.flashMode = XBFlashModeOff;
        }
        [self.view makeToast:FLASH_NO_HINT 
                    duration:2.0
                    position:@"center"
                       image:[UIImage imageNamed:@"tip.png"]];
    
    }
    else if(sender == button4) {
        self.gridView.hidden = !self.gridView.hidden;
        
        [self.view makeToast:self.gridView.hidden? GRID_MODE_OFF_HINT:GRID_MODE_HINT 
                    duration:2.0
                    position:@"center"
                       image:[UIImage imageNamed:@"tip.png"]];
    }
    else if(sender == button5) {
        AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        controller.aboutDelegate = self;
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }
    
    
    
    
    
    if( self.navigation.expanded ) {
        [self.navigation collapse];
    }
    CGRect frame = self.scrollView.frame;
    if (frame.origin.y <= 364) {//Show
        frame.origin.y = 364 + 64;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.frame = frame;
    }];
}


- (void)startRecordingPicture {
    [self.cameraView startCapturing];
}

- (void)stopRecordingPicture {
    [self.cameraView stopCapturing];
}

- (void)setupMenus {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    if (self.cameraView.device.hasFlash) {
        [buttons addObject:button1];
        [buttons addObject:button2];
    }
    else {
        button1.hidden = YES;
        button2.hidden = YES;
    }
    [buttons addObject:button3];
    [buttons addObject:button4];
    [buttons addObject:button5];
    
    ExpandableNavigation *tempNavigation = [[ExpandableNavigation alloc] initWithMenuItems:buttons mainButton:self.mainBtn radius:120.0];
    self.navigation = tempNavigation;
    [tempNavigation release];
    [buttons release];
}


- (void)collapseAllItems {
    CGRect frame = self.scrollView.frame;
    if (frame.origin.y <= 364) {//Show
        frame.origin.y = 364 + 64;
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.frame = frame;
    }];
    
    if (self.navigation.expanded) {
        [self.navigation collapse];
    }
}

- (void)closeAboutView:(AboutViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}
- (void)gotoReview {
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@541608970", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
