//
//  AboutViewController.m
//  cameraTest
//
//  Created by Hang Chen on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
- (void)closeAbout;
@end

@implementation AboutViewController
@synthesize webview;
@synthesize aboutDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.webview = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(280, 5, 32, 32);
    [closeBtn setImage:[UIImage imageNamed:@"1341240796_Gnome-Window-Close-32.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"about" 
                                                     ofType:@"html" 
                                                inDirectory:[NSString stringWithFormat:@"%@.lproj",language]];
    
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // Fallback to english
        filePath = [[NSBundle mainBundle] pathForResource:@"about" 
                                               ofType:@"html" 
                                          inDirectory:@"en.lproj"];
    }
    
    
    
    
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath]; 
    
    [self.webview loadHTMLString:[[[NSString alloc] initWithData:htmlData encoding:4] autorelease] baseURL:baseURL];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeAbout {
    if (self.aboutDelegate && [self.aboutDelegate respondsToSelector:@selector(closeAboutView:)]) {
        [self.aboutDelegate closeAboutView:self];
    }
    
}

@end
