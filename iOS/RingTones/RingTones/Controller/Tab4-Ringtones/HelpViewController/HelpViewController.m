//
//  HelpViewController.m
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/26/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize isHelp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self setViewWhenViewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)setViewWhenViewDidLoad
{
    if (isHelp) {
        self.navigationItem.title = @"Help";
    }
    else{
        self.navigationItem.title = @"Info";  
    }

        //set up view for custom back button
        UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc]initWithCustomView:view_Btn_NavBack];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftNavButton, nil];
    
        label_PushView_Nam.text = [self returnPushClassName];
        //self.title = className;
        
        //load for webview
        NSString *urlString;
        if (isHelp)
        {
            urlString = @"https://www.google.com/";
        }
        else
        {
            urlString = @"http://vnexpress.net/";
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView_Help loadRequest:request];
        

    
    
    
}

//-------------------------------------------------------
//
-(NSString *)returnPushClassName
{
    //get push class name
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    
    NSString *className;
    if (numberOfViewControllersOnStack > 1)
    {
        UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
        Class parentVCClass = [parentViewController class];
        className = NSStringFromClass(parentVCClass);
        
        NSRange range = [className rangeOfString:@"ViewController"];
        if (range.location != NSNotFound)
        {
            className = [className substringToIndex:range.location];
        }
        
    }
    return className;
}

//-------------------------------------------------------
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_PopToView_Tapped:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
