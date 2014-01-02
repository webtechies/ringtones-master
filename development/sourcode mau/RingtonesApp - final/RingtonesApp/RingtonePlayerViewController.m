//
//  RingtonePlayerView.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtonePlayerViewController.h"
#import "CommonUtils.h"
#import "Constants.h"
#import "AppDelegate.h"

#define kTimerPlaytimeInterval 1.0f

@interface RingtonePlayerViewController(privateMethods)

- (void)updateGUI;
- (void)startTimer;
- (void)stopTimer;
- (void)timerTick;
- (void)startPlay;
- (void)stopPlay;


@end

@implementation RingtonePlayerViewController
@synthesize player;


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

- (void)updateFrame;
{
    
    CGRect frame = self.view.frame;
    frame.size.width = hostVC.view.frame.size.width;
    frame.origin.y = hostVC.view.frame.size.height - self.view.frame.size.height;
    self.view.frame = frame;

    /*
    CGRect frame = self.view.frame;
    CGFloat hostWidth, hostHeight, selfWidth, selfHeight;
//    frame.size.width = hostVC.view.frame.size.width;
    
//    frame.origin.y = hostVC.view.frame.size.height - self.view.frame.size.height;
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice]orientation])) {
        hostWidth = 1024.0f;
        hostHeight = hostVC.view.frame.size.height;  
        
        selfWidth = frame.size.width;
        selfHeight =frame.size.height; 
        
    } else {
        hostWidth = 768.0f;
        hostHeight = hostVC.view.frame.size.width;

        selfWidth = frame.size.height;
        selfHeight = frame.size.width;  
    }
    
    frame.origin.y = hostHeight - selfHeight;

    frame.size.width = hostWidth;
//    frame.size.height = selfHeight;
    
    self.view.frame = frame;
    
    NSLog(@"updateFrameSelf: width: %f, h: %f, y: %f, host w: %f, h: %f", frame.size.width, frame.size.height, frame.origin.y, hostWidth, hostHeight);
     */
}

- (void)updateGUI;
{

    if (player != nil) {
        int duration = player.duration;
        int currentTime = player.currentTime;
        if (currentTime < 0) {
            currentTime = 0;
        }
        
        labelCurrentTime.text = [CommonUtils convertToDateTimeFrom:currentTime];

        NSString *remainingText = [CommonUtils convertToDateTimeFrom:(duration - currentTime)];
        labelRemainingTime.text = [NSString stringWithFormat:@"-%@",remainingText];
        
        if ([player isPlaying]) {
            //set IMage here
            [buttonPlayPause setImage:[UIImage imageNamed:@"button_player_pause.png"] forState:UIControlStateNormal];
        } else {
            [buttonPlayPause setImage:[UIImage imageNamed:@"button_player_play.png"] forState:UIControlStateNormal];
        }
        
        sliderTimeline.value = player.currentTime / player.duration;
    }
}

#pragma Timer playtim
- (void)startTimer;
{
    if (![timerPlaytime isValid]) {
        timerPlaytime = [NSTimer scheduledTimerWithTimeInterval:kTimerPlaytimeInterval 
                                                         target:self 
                                                       selector:@selector(timerTick) 
                                                       userInfo:nil 
                                                        repeats:YES];
    }
    
}

- (void)stopTimer;
{
    if ([timerPlaytime isValid]) {
        [timerPlaytime invalidate];
        timerPlaytime = nil;
    }
}

- (void)timerTick;
{
    [self updateGUI];
}

- (void)startPlay;
{
    if (player != nil) {
        [player play];
        [self updateGUI];
    }
    
    //start timer
    [self startTimer];
    
}

- (void)stopPlay;
{
    if (player != nil) {
        [player stop];
    }
    
    //stop timer
    [self stopTimer];
}


- (void)playRingtone:(NSString *)name;
{
    [self stopPlay];
    
    F_RELEASE(player);

    NSURL *url;
    
    if ([name hasPrefix:@"http"]) {//internet
        url = [NSURL URLWithString:name];
    } else { //local
        url = [NSURL fileURLWithPath:name];    
//        url = [NSURL fileURLWithPath:[CommonUtils fullPathFromFile:name]];    
    }
    
    NSError *error = nil;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    NSLog(@"error: %@", [error localizedDescription]);
    
    [self startPlay];
    


}

- (void)playRingtone:(NSString *)name onViewController:(UIViewController *)viewController
{
    hostVC = viewController;

    sliderTimeline.value = 0;
    
    if ([self.view superview] == viewController.view) {
        [self.view removeFromSuperview];
    }

    
    //remove preview ringtone
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.ringtonePreview stopPreviewingAndRemoveFromSuperView];
    
    [self playRingtone:name];    
        
    [viewController.view addSubview:self.view];
    
    [self updateFrame];
    
}

- (void)stopPlayingRingtoneAndRemoveFromSuperView;
{
    [self stopPlay];
    
    F_RELEASE(player);
    
    if ([self.view superview] != nil) {
        [self.view removeFromSuperview];
    }
}

#pragma Button events
- (IBAction)buttonCloseClicked:(id)sender;
{
    [self stopPlayingRingtoneAndRemoveFromSuperView];
}

- (IBAction)buttonPlayPauseClicked:(id)sender;
{
    if (player.isPlaying) {
        [player pause];
    } else {
        [player play];
    }
}

- (IBAction)sliderTimelineValueChanged:(id)sender;
{
//    CMTime time = sliderTimeline.value;
    if (player != nil) {
        [self stopPlay];
        
        CGFloat currentPlayerValue = sliderTimeline.value * player.duration;
        [player setCurrentTime:currentPlayerValue];
        
        [self startPlay];
    }    

    
    [self updateGUI];
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
//    [self updateFrame];
    return YES;
}

@end
