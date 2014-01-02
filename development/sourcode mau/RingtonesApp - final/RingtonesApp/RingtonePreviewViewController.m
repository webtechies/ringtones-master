//
//  RingtonePreviewViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtonePreviewViewController.h"

#import "Constants.h"
#import "CommonUtils.h"
#import "AppDelegate.h"



@interface RingtonePreviewViewController(methods)

- (void)updateGUI;
- (void)donePreviewing;
- (void)failPreviewing;

- (void)callLoadingPreviewOnViewController:(UIViewController *)viewController;

- (void)startTimer;
- (void)stopTimer;
- (void)timerTick;

@end

@implementation RingtonePreviewViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ringtone:(NSDictionary *)dict
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        F_RELEASE(dictRingtone);
        dictRingtone = [dict retain];
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

- (void)updateGUI;
{

}

- (void)updateFrame;
{
    
    CGRect frame = self.view.frame;
    frame.size.width = hostVC.view.frame.size.width;
    frame.origin.y = hostVC.view.frame.size.height - self.view.frame.size.height;
    self.view.frame = frame;

}

- (void)callLoadingPreviewOnViewController:(UIViewController *)viewController;
{
    //remove old loading preview
    if ([self.view superview] != nil) {
        [self.view removeFromSuperview];
    }
    
    hostVC = viewController;
    
    [self startTimer];
    
    //close ringtone player
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.ringtonePlayer stopPlayingRingtoneAndRemoveFromSuperView];
    
    //begin loading ringtone from server
    NSString *urlServer = [[dictRingtone objectForKey:@"link"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlServer: %@", urlServer);

    F_RELEASE(request);
    
    request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlServer]];
    [request setDelegate:self];
    [request setTimeOutSeconds:kTimeoutGetRingtone];
    
    NSString *filePath = [CommonUtils pathForSourceFile:[dictRingtone objectForKey:@"title"] inDirectory:kTempFolderPreview];
    NSLog(@"filePath: %@", filePath);
    
    [request setDownloadDestinationPath:filePath];
    [request setDownloadProgressDelegate:nil];
    [request setShowAccurateProgress:YES];
    [request setDidFinishSelector:@selector(donePreviewing)];
    [request setDidFailSelector:@selector(failPreviewing:)];
    

    [indicator startAnimating];
    
    [request startAsynchronous];
    
    
    //add loading preview to host controller
    [hostVC.view addSubview:self.view];
    [self updateFrame];
    
}

- (void)loadPreviewOnViewController:(UIViewController *)viewController;
{
    if (dictRingtone == nil) {
        return;
    }
    
    [self callLoadingPreviewOnViewController:viewController];

}

- (void)loadPreviewWithDict:(NSDictionary *)dict onViewController:(UIViewController *)viewController;
{
    F_RELEASE(dictRingtone);
    dictRingtone = [dict retain];
    
    
    [self callLoadingPreviewOnViewController:viewController];    
}

- (void)stopPreviewingAndRemoveFromSuperView;
{
    if (request) {
        request.delegate = nil;
        [request cancel];
    }
    
    F_RELEASE(request);
    
    if ([self.view superview] != nil) {
        [self.view removeFromSuperview];
    }
}

- (void)donePreviewing;
{
    NSLog(@"<<donePreviewing >>");
    
    

    NSString *filePath = [CommonUtils pathForSourceFile:[dictRingtone objectForKey:@"title"] inDirectory:kTempFolderPreview];
    NSLog(@"filePath: %@", filePath);
    
    //play ringtone
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate playRingtone:filePath onViewController:hostVC];
    
    //remove old loading preview
    if ([self.view superview] != nil) {
        [self.view removeFromSuperview];
    }
    
    
    //send viewed request to increase view count
    NSString *url = [NSString stringWithFormat:SERVER_API_INCREASE_VIEW, [[dictRingtone objectForKey:@"id"]intValue]];
    ASIHTTPRequest *requestView = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [requestView startAsynchronous];
    
    [requestView release];
    
    [indicator stopAnimating];  
    
}

- (void)failPreviewing:(ASIHTTPRequest *)req;
{
    NSLog(@"<<failPreviewing >>: %@", [[req error]localizedDescription]);
    [indicator stopAnimating];
    F_RELEASE(dictRingtone);
    
    //remove old loading preview
    if ([self.view superview] != nil) {
        [self.view removeFromSuperview];
    }
    
}

- (void)startTimer;
{
    if (![timerUpdatePercent isValid]) {
        timerUpdatePercent = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer;
{
    if ([timerUpdatePercent isValid]) {
        [timerUpdatePercent invalidate];
        timerUpdatePercent = nil;
    }
}

- (void)timerTick;
{

    //update percent
    NSInteger totalData = [[dictRingtone objectForKey:@"file_size"] intValue];
    NSInteger countCurrent = [request totalBytesRead];
    NSLog(@"timerTick:countCurrent : %d, total: %d ", countCurrent, totalData);
    CGFloat percent = 100 * (float)countCurrent/(float)totalData;
    if (totalData == 0) {
        percent = 0;
    }
//    NSLog(@"countCurrent: %d, total: %d, percent: %.2lf", countCurrent, totalData, percent);
    
    NSString *title = [dictRingtone objectForKey:@"title"];
    labelDownloading.text = [NSString stringWithFormat:@"Loading ringtone: %@ - %.2lf%%", title, percent];
    
    if (![indicator isAnimating]) {
        [self stopTimer];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    [self updateFrame];
    return YES;
}

@end
