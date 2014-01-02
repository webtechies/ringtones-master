//
//  InfoViewController.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/6/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "InfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InfoViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@end



@implementation InfoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wihPostID:(NSString *) postID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.posid = postID;
        
    }
    return self;
}


#pragma mark - Add title


-(void) addTitle
{
    //--uiimage background
    UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"SettingBar_no.png"]: [UIImage imageNamed:@"SettingBar-iPad_no.png"];
    
    UIImageView *backgroundviewNavigation = [[UIImageView alloc] initWithImage:image];
    CGRect frameNavigation = CGRectZero;
    frameNavigation.origin = CGPointZero;
    frameNavigation.size =  image.size;
    
    
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70 , 12.0f, 140, 21.0f)];

    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    titleLabel.layer.shadowRadius = 1.0;
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.masksToBounds = NO;
    
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText: @"Info"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backgroundviewNavigation addSubview:titleLabel];
    [titleLabel release];
    [self.view addSubview:backgroundviewNavigation];

    
    
    //--button black
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [buttonBlack addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBlack];
    
    
    
    //--add indicator
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped =  YES;
    [self.view addSubview:self.activityIndicatorView];
    
    self.activityIndicatorView.frame = CGRectMake(self.view.frame.size.width - self.activityIndicatorView.frame.size.width - 10, (44 - self.activityIndicatorView.frame.size.height)/2, self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.height);
    
    [self.activityIndicatorView startAnimating];

    
    
}


-(void)buttonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark  - UIWebview


-(void) addWebview
{
    NSString *urlStr = [NSString stringWithFormat:@"http://192.241.128.84/about?width=%.0f&pid=%@", self.view.frame.size.width, self.posid];
    NSLog(@"url: %@", urlStr);

    CGRect rect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    UIWebView *webview = [[UIWebView alloc] initWithFrame:rect];
    webview.autoresizesSubviews = YES;
    webview.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [webview setDelegate:self];
    [self.view addSubview:webview];
    [webview release];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    
}



#pragma mark -
#pragma mark Orientation


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotate
{
    return YES;
    //return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark  - CycleView



-(void) loadView
{
    if (self.nibBundle != nil){
        [super loadView];
    }else{
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        CGRect screenBoundsHasNavigatationBar = CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height - 44);
        
        CGRect frame = self.wantsFullScreenLayout? screenBounds:screenBoundsHasNavigatationBar;
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.autoresizesSubviews =  YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    
    
    
    
    [self addWebview];
    [self addTitle];
    
}



/** Register notification center for view controller */
-(void) registerNotification
{
   
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{

    
}


/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [_activityIndicatorView release];

    [_posid release];
    
    [super dealloc];
}


@end
