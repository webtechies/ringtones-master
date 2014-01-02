//
//  ViewController.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/5/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "IAdViewController.h"
#import "RageIAPHelper.h"


@interface IAdViewController ()
@property (nonatomic, retain) NSArray *products;
@end



@implementation IAdViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark -  Title


-(void) addTitle
{
    //--title label
    CGRect frameTitle = CGRectMake(60, 0, 200, 40);
    frameTitle.origin.x = ceil((self.view.frame.size.width - 200)/2);
    
    CGFloat sizeFontTitle  = 17.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        sizeFontTitle = 24.0f;
        frameTitle.origin.y = 15;
    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:frameTitle];
    [lblTitle setText:@"Remove Ads"];
    
    
    lblTitle.textColor =  [UIColor colorWithRed:71.0f/256.0f green:71.0f/256.0f blue:71.0f/256.0f alpha:1.0];
    lblTitle.backgroundColor =  [UIColor clearColor];
    lblTitle.textAlignment =  NSTextAlignmentCenter;
    lblTitle.font =  [UIFont boldSystemFontOfSize:sizeFontTitle];
    
    [self.view addSubview:lblTitle];
    
    [lblTitle release];
    
    
    //--button black
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [buttonBlack setImage:[UIImage imageNamed:@"03_arrow_left.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 86, 46);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, -44, 0, 0);
    }else{
        
        [buttonBlack setImage:[UIImage imageNamed:@"03_arrow_left~iPad.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(10, 12, 86, 46);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, -44, 0, 0);
    }
    
    [buttonBlack addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBlack];
    
    
    
}


-(void) buttonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  - Add view background

-(void) initBackgroundImage
{
    CGRect rectFrame = self.view.frame;
    rectFrame.origin.y = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectFrame];
    if (self.imageBg)
    {
        imageView.image =  self.imageBg;
    }
    
    [self.view addSubview:imageView];
    
    [imageView release];
}


-(void) initBackgroundWhyDoINeedBuy
{
    CGRect rectFrame = self.view.frame;
    rectFrame.origin.y = 64;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectFrame];
    if (self.imageAds)
    {
        imageView.image =  self.imageAds;
        rectFrame.size =  self.imageAds.size;
        imageView.frame =  rectFrame;
    }
    
    
    [self.view addSubview:imageView];
    
    [imageView release];
    
}



#pragma mark  - Add button cancel, Upgrade


-(void) addButtonAction
{
    if (! _buttonUpgrade){
        
        self.buttonUpgrade = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.buttonUpgrade setImage:[UIImage imageNamed:@"imgButtonDownload.png"] forState:UIControlStateNormal];
        self.buttonUpgrade.frame =  CGRectMake(59, 366, 216, 66);
        [self.buttonUpgrade addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.buttonUpgrade.enabled = NO;
        
        [self.view addSubview:self.buttonUpgrade];
        
    }
}


#pragma mark - IAP



- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    if(self.products.count > 0){
        
        SKProduct *product = self.products[buyButton.tag];
    
        [[RageIAPHelper sharedInstance] buyProduct:product];
    }
    
}

- (void)restoreTapped:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"removeads"];
            [defaults synchronize];
            
            
            self.buttonUpgrade.enabled = NO;
            *stop = YES;
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Remove Ads" message:@"Removing ads has been successed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertview.tag = 1;
            [alertview show];
            [alertview release];
        }
    }];
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    if (tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)reload {
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
           
            NSLog(@"products sucess: %@", products);
            
           self.products = products;
           self.buttonUpgrade.enabled = YES;
        }
    }];
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
    
    
    [self initBackgroundImage];
    [self initBackgroundWhyDoINeedBuy];
    [self addButtonAction];
    
    [self addTitle];
    [self reload];
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
    [_products release];
    [_buttonUpgrade release];
    
    
    [super dealloc];
}
@end
