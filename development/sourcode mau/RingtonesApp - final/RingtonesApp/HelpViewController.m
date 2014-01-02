//
//  HelpViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "CommonUtils.h"
#import "Constants.h"

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = TITLE_VIEW_HELP;
    
    //test
//    [[NSNotificationCenter defaultCenter]postNotificationName:kPurchaseKey object:nil];
//    [[NSUserDefaults standardUserDefaults]setObject:@"TRUE" forKey:kPurchaseKey];
    
    //load help file
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpLink]];
    [mainWebview loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    mainWebview.delegate = self;
    [mainWebview stopLoading];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
