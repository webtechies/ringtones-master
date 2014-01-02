//
//  MainMakerViewController.m
//  RingTones
//
//  Created by VinhTran on 12/17/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "MainMakerViewController.h"
#import "CommonUtils.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


#import "RingtoneHelpers.h"
#import "AppDelegate.h"


@interface MainMakerViewController ()

@end

#define checkResult(result,operation) (_checkResult((result),(operation),__FILE__,__LINE__))
static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&result);
        return NO;
    }
    return YES;
}


@implementation MainMakerViewController
@synthesize songid, songModel;
@synthesize path,slider;

// Callback to be notified of audio session interruptions (which have an impact on the conversion process)
static void interruptionListener(void *inClientData, UInt32 inInterruption)
{
    //    id object = (id) inClientData;
    //
    ////    if ([object class] != [RingtoneCreatorViewController class]) {
    ////        return;
    ////    }
    //
    //	RingtoneCreatorViewController *THIS = (RingtoneCreatorViewController *)inClientData;
    //
    //	if (inInterruption == kAudioSessionEndInterruption) {
    //		// make sure we are again the active session
    //		checkResult(AudioSessionSetActive(true), "resume audio session");
    //        if ( THIS->audioConverter ) [THIS->audioConverter resume];
    //	}
    //
    //	if (inInterruption == kAudioSessionBeginInterruption) {
    //        if ( THIS->audioConverter ) [THIS->audioConverter interrupt];
    //    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        songid = @"0";
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedItem:(MPMediaItem *)item
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedItem = item;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) updateSliderLabels
{
    //	FloatRange r = slider.value;
    //    slider.leftmostThumb.textLabel.text = [CommonUtils convertToDateTimeFrom:r.min]; //[NSString stringWithFormat:@"%.2f", r.min];
    //	slider.rightmostThumb.textLabel.text = [CommonUtils convertToDateTimeFrom:r.max]; //[NSString stringWithFormat:@"%.2f", r.max];
    //
    //
    //    [player setCurrentPlaybackTime:r.min];
    
}

- (void)updateTimeLabels;
{
    FloatRange r = slider.value;
    CGFloat duration =  (int)(r.max - r.min);
    //    NSLog(@"update duration: %f", duration);
    
    labelDuration.text = [CommonUtils convertToDateTimeFrom:duration];
    
    
    labelStart.text = [CommonUtils convertToDateTimeFrom:startRange];
    labelEnd.text = [CommonUtils convertToDateTimeFrom:endRange];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //update start/end time
    
    //calculate start/end range
    CGPoint newOffset = scrollView.contentOffset;
    
    startRange = newOffset.x * durationPerScroll / scrollRange.frame.size.width;
    endRange =  (newOffset.x + scrollRange.frame.size.width) * durationPerScroll / scrollRange.frame.size.width;
    
    //    NSLog(@"newOffset x: %f, y: %f\nstart: %f, end: %f", newOffset.x, newOffset.y, startRange, endRange);
    
    [self updateTimeLabels];
}


-(IBAction) sliderValueChanged : (id) sender
{
    /*
    //    FloatRange r = slider.value;
    
    //    //detect min/max change
    //    if (r.max != rangeCurrent.max) {
    //        // change max
    //        if (r.max - r.min <= kDefaultRingtoneCutMinDuration) {
    //            r.min = r.max - kDefaultRingtoneCutMinDuration;
    //        }
    //    } else {
    //        //change min
    //        if (r.max - r.min <= kDefaultRingtoneCutMinDuration) {
    //            r.max = r.min + kDefaultRingtoneCutMinDuration;
    //        }
    //    }
    //
    //
    //    [slider setValue:r];
    //
    //    rangeCurrent = r;
    
    
    //	[self updateSliderLabels];
    //    CGFloat duration = r.max - r.min;
    
    //    //new max,min value
    //    if (r.max != rangeCurrent.max) { //change max
    //        slider.maximumValue = r.min + kRingtoneCutMaxDuration;
    //    } else {
    //        slider.maximumValue = r.min + kRingtoneCutMaxDuration;
    //    }
    //
    //    if (duration >= kRingtoneCutMaxDuration || duration <= kRingtoneCutMinDuration) {
    //        return;
    //    }
    
    //    rangeCurrent = r;
    //    NSLog(@"pass change range");
    
    //    kRingtoneCutMinDuration
    //
    */
    CGRect frame = viewSelection.frame;
    
    FloatRange r = slider.value;
//    NSLog(@"slider.value.min: %f", slider.value.min);
    r.min = slider.value.min;
    r.max = slider.value.max;
    NSNumber *duration = 0;
    if ([songid intValue]>=1) {
        
        duration = [NSNumber numberWithFloat: sound.duration];
        
    }
    else if([songid intValue]==-1){
        duration = [NSNumber numberWithFloat: sound.duration];
    }else{
        duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    }
    
    frame.origin.x = 4 + scrollRange.contentSize.width * (startRange + r.min) / [duration floatValue]; //--vimnh sua so 4

    frame.origin.y = 0.0f;
    frame.size.width = 5.0f +  scrollRange.contentSize.width * (r.max - r.min) / [duration floatValue];
    frame.size.height = scrollRange.frame.size.height;
    NSLog(@"frame.size.height: %f", scrollRange.frame.size.height);
    NSLog(@"width: %f", frame.size.width);
    //frame.size.height = 300;
    frame = [scrollRange convertRect:frame toView:self.view];
    viewSelection.frame = frame;

    [self updateTimeLabels];
    //    NSLog(@"sliderValueChanged");
}



- (IBAction)buttonPlayClicked:(id)sender; {
    FloatRange r = slider.value;
    
    if ([songid intValue]>=1) {
        [self abc];
    }
    else if([songid intValue]==-1){
        [self abc];
    }else{
        [player setCurrentPlaybackTime:r.min + startRange];
        
        if ([player playbackState] == MPMusicPlaybackStatePlaying) {
            [player pause];
            buttonPlay.tag = 0;
        } else {
            [player play];
            buttonPlay.tag = 1;
        }

    }
    

}

-(void) abc{
    FloatRange r = slider.value;
    [sound setCurrentTime:(r.min + startRange)];
    if (buttonPlay.tag==0) {
        [self startTimer];
        [sound play];
        buttonPlay.tag = 1;
        scrollRange.userInteractionEnabled = NO;
        imgviewPlayingIndi.hidden = NO;
        [buttonPlay setImage:[UIImage imageNamed:@"Btn_stop.png"] forState:UIControlStateNormal];
    }else{
        [self stopTimer];
        [sound stop];
        buttonPlay.tag = 0;
        scrollRange.userInteractionEnabled = NO;
        imgviewPlayingIndi.hidden = YES;
        [buttonPlay setImage:[UIImage imageNamed:@"Btn_play.png"] forState:UIControlStateNormal];
    }

}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [buttonPlay setImage:[UIImage imageNamed:@"Btn_play.png"] forState:UIControlStateNormal];
    scrollRange.userInteractionEnabled = YES;
}

- (void)didChangePlaybackState:(NSNotification *)notif;
{
    //    if (notif && [notif object] != nil) {
    
    if ([player playbackState] == MPMusicPlaybackStatePlaying) {
        [buttonPlay setImage:[UIImage imageNamed:@"Btn_stop.png"] forState:UIControlStateNormal];
        
        [self startTimer];
        
        //            imgviewPlayingIndi.hidden = NO;
        //enable slider
        slider.userInteractionEnabled = NO;
        scrollRange.userInteractionEnabled = NO;
        
    } else {
        [buttonPlay setImage:[UIImage imageNamed:@"Btn_play.png"] forState:UIControlStateNormal];
        [self stopTimer];
        
        //disable slider
        imgviewPlayingIndi.hidden = YES;
        slider.userInteractionEnabled = YES;
        scrollRange.userInteractionEnabled = YES;
        
    }
    //    }
}

/*
- (void)startConvertCafToM4r;
{
    BOOL willContinue = YES;
    if ( ![TPAACAudioConverter AACConverterAvailable] ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                     message:NSLocalizedString(@"Couldn't convert audio: Not supported on this device", @"")
                                    delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        willContinue = FALSE;
//        goto handleFailToContinue; vinh
        //        return;
    }
  

    // Initialise audio session, and register an interruption listener, important for AAC conversion
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.isAudioSessionInitiated) {
        if (!checkResult(AudioSessionInitialize(NULL, NULL, interruptionListener, self), "initialise audio session") ) {
            [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                         message:NSLocalizedString(@"Couldn't initialise audio session!", @"")
                                        delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease] show];
            willContinue = FALSE;
            goto handleFailToContinue;
            //        return;
        } else {
            delegate.isAudioSessionInitiated = YES;
        }
    }
    
   
    // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
    UInt32 audioCategory = kAudioSessionCategory_MediaPlayback;
    if ( !checkResult(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory), "setup session category") ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                     message:NSLocalizedString(@"Couldn't setup audio category!", @"")
                                    delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        willContinue = FALSE;
//        goto handleFailToContinue; vinh
        //        return;
    }
    
    NSArray *array = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *newM4rConvertedPath = lastConvertedCafName;
    
    if (array && [array count] > 0) {
        newM4rConvertedPath = [[array lastObject] stringByDeletingPathExtension];
    }
    
    newM4rConvertedPath = [newM4rConvertedPath stringByAppendingPathExtension:@"m4r"];
    newM4rConvertedPath = [CommonUtils pathForSourceFile:newM4rConvertedPath inDirectory:nil];
    NSLog(@"newM4rConvertedPath: %@", newM4rConvertedPath);
    
    NSLog(@"sourcefile: %@", lastConvertedCafName);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL fileExist = [fileMgr fileExistsAtPath:lastConvertedCafName];
    NSLog(@"fileExist: %d", fileExist);
    
    
    //    if (audioConverter) {
    //        audioConverter.delegate = nil;
    //        [audioConverter release];
    //        audioConverter = nil;
    //
    //    }
    
    if (audioConverter == nil) {
        audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                                source:lastConvertedCafName
                                                           destination:newM4rConvertedPath];
        
    }
    
    [audioConverter start];
    
handleFailToContinue:
    if (!willContinue) {
        [DSBezelActivityView removeViewAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //delegate.isConverting = FALSE; vinh
    }
    
    
}
*/

- (void)trimAudio
{
    FloatRange r = self.slider.value;
    if (r.min<0) {
        r.min=0;
    }
    float vocalStartMarker = r.min;
    float vocalEndMarker = r.max;
    SongField *songField = [[SongField alloc] init];
    songField =  [songModel getRowByRowsInSongTableByRowId:songid];
    
    NSString *pathToFile = @"";

    if ([songid intValue]>=1){
        pathToFile = [Common savePathForDownloadedRingtonesWithRingtoneName:songField.name];
    }
    else if([songid intValue]==-1){
        pathToFile = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER,recordFileTemp];
    }
    else{
        return;
    }
    
    //savePathForDownloadedRingtonesWithRingtoneName
    NSURL *audioFileInput = [NSURL fileURLWithPath:pathToFile];
    NSDate *today = [NSDate date];
    
    NSString *nameRingtone = [NSString stringWithFormat:@"%@_ringtone_%f.m4r", songField.name, [today timeIntervalSince1970]];
    
    
    NSString *exportFile = [Common savePathForCreatedRingtonesWithRingtoneName:nameRingtone];//[Common getRingToneInFolderDocument:nameRingtone];
    NSURL *audioFileOutput = [NSURL fileURLWithPath:exportFile];
    
    if (!audioFileInput || !audioFileOutput)
    {
        // return NO;
        NSLog(@"fail cmnr9");
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset  presetName:AVAssetExportPresetAppleM4A];
    //    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset: asset presetName: AVAssetExportPresetPassthrough];
    
    if (exportSession == nil)
    {
        //return NO;
        NSLog(@"fail cmnr0");
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    /*--fade
    if (isFade) {
        
        AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
        AVMutableAudioMixInputParameters *exportAudioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:assetTrack];
        
        
        //fade in
        [exportAudioMixInputParameters setVolume:0.0 atTime:CMTimeMakeWithSeconds(self.slider.leftValue-2, 1)];
        [exportAudioMixInputParameters setVolume:0.1 atTime:CMTimeMakeWithSeconds(self.slider.leftValue-1, 1)];
        [exportAudioMixInputParameters setVolume:0.4 atTime:CMTimeMakeWithSeconds(self.slider.leftValue, 1)];
        [exportAudioMixInputParameters setVolume:0.7 atTime:CMTimeMakeWithSeconds(self.slider.leftValue+1, 1)];
        [exportAudioMixInputParameters setVolume:1.0 atTime:CMTimeMakeWithSeconds(self.slider.leftValue+2, 1)];
        
        //fade out
        [exportAudioMixInputParameters setVolume:1.0 atTime:CMTimeMakeWithSeconds((self.slider.rightValue-2), 1)];
        [exportAudioMixInputParameters setVolume:0.5 atTime:CMTimeMakeWithSeconds((self.slider.rightValue-1), 1)];
        [exportAudioMixInputParameters setVolume:0.1 atTime:CMTimeMakeWithSeconds((self.slider.rightValue), 1)];
        
        exportAudioMix.inputParameters = [NSArray arrayWithObject:exportAudioMixInputParameters];
        exportSession.audioMix = exportAudioMix;
        

    }
    
    */
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //[self dismissLoading];
             
             
             if (AVAssetExportSessionStatusCompleted == exportSession.status)
             {
                 // It worked!
                 NSLog(@"ok con de");
                 
                 SongField *songField = [[SongField alloc] init];
                 songField.name = nameRingtone;
                 songField.type = @"1";
                 [songModel createRowInSongTable:songField];
                 
//                 RingToneModel *ringToneModel = [[RingToneModel alloc] init];
//                 RingToneField *ringTonesField = [[RingToneField alloc] init];
//                 SongModel *songModel = [[SongModel alloc] init];
//                 SongField *songField = [songModel getSongByRowId:songId];
//                 ringTonesField.name_song = songField.name;
//                 ringTonesField.name_singer = songField.singer;
//                 ringTonesField.path_song = nameRingtone;
//                 [ringToneModel createRowInTableRingTone:ringTonesField];
//                 [ringTonesField release];
//                 [ringToneModel release];
//                 [songModel release];
                 
//                 [self stop_timePlaying];
//                 
//                 [[self delegate] closeCropMusic:YES];
             }
             else if (AVAssetExportSessionStatusFailed == exportSession.status)
             {
                 // It failed...
                 NSLog(@"fail cmnr=");
//                 btnCrop.enabled = YES;
                 
             }
             
         });
         
         
     }];
    
    //return YES;
}


-(NSString*) myDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];;
}


- (IBAction)buttonConvertClicked:(id)sender;
{
    //[self startRecordingConvert];
    [self trimAudio];
}



- (void)startTimer;
{
    if (![timerLimit isValid]) {
        timerLimit = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer;
{
    if ([timerLimit isValid]) {
        [timerLimit invalidate];
        timerLimit = nil;
    }
    
    if ([songid intValue]>=1) {
        [sound stop];
    }
    else if([songid intValue]==-1){
        [sound stop];
    }else{
        [player stop];
    }
    
    
}

- (void)timerTick;
{
    CGFloat currentTime = 0;
    
    if ([songid intValue]>=1) {
        currentTime = sound.currentTime;
    }
    else if([songid intValue]==-1){
        currentTime = sound.currentTime;
    }else{
        currentTime = player.currentPlaybackTime;
    }
    
    
    FloatRange r = self.slider.value;
    
    NSNumber *duration = 0;
    if ([songid intValue]>=1) {

        duration = [NSNumber numberWithFloat: sound.duration];
        
    }
    else if([songid intValue]==-1){
        duration = [NSNumber numberWithFloat: sound.duration];
    }else{
        duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    }

    
    CGRect playingFrame = imgviewPlayingIndi.frame;
    
    playingFrame.origin.x = scrollRange.contentSize.width * currentTime / [duration floatValue];
    imgviewPlayingIndi.frame = playingFrame;
    
    if (imgviewPlayingIndi.hidden) {
        imgviewPlayingIndi.hidden = FALSE;
    }
    if (currentTime >= startRange + r.max - 1.0f) {
        [self stopTimer];
    }
    
    
}


// record current playing item
- (void) startRecordingConvert;
{
    BOOL convertResult = TRUE;
    [player pause];
    [buttonPlay setImage:[UIImage imageNamed:@"Btn_play.png"] forState:UIControlStateNormal];
    
    
    //start animation
    [DSBezelActivityView newActivityViewForView:self.navigationController.navigationBar.superview withLabel:@"Converting ..." width:160];
    
    //    [CommonUtils startIndicatorDisableViewController:self];
    
    // set up an AVAssetReader to read from the iPod Library
	NSURL *assetURL = [selectedItem valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
	NSError *assetError = nil;
	AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError];
	if (assetError) {
		NSLog (@"error: %@", assetError);
        convertResult = FALSE;
//        goto endHandler; vinh
		return;
	}
	
    
	AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                               assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                               audioSettings: nil];
    
    
	if (! [assetReader canAddOutput: assetReaderOutput]) {
		NSLog (@"can't add reader output... die!");
        convertResult = FALSE;
//        goto endHandler; vinh
		return;
	}
	[assetReader addOutput: assetReaderOutput];
	
    NSString *exportPath = [self urlPathForRecord];
    NSLog(@"exportPath: %@",exportPath);
    NSURL *exportURL = [NSURL fileURLWithPath: exportPath];
    NSLog(@"exportURL: %@",exportURL);
	AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                              error:&assetError];
	if (assetError) {
		NSLog (@"error: %@", assetError);
        convertResult = FALSE;
//        goto endHandler; vinh
		return;
	}
    
    
	AudioChannelLayout channelLayout;
	memset(&channelLayout, 0, sizeof(AudioChannelLayout));
	channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
	NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
									[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
									[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
									[NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
									[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
									[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
									nil];
	AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                               outputSettings:outputSettings];
    
	if ([assetWriter canAddInput:assetWriterInput]) {
		[assetWriter addInput:assetWriterInput];
	} else {
		NSLog (@"can't add asset writer input... die!");
        convertResult = FALSE;
        goto endHandler;
		return;
	}
	
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate; vinh
    
endHandler:
    if (!convertResult) {
        [DSBezelActivityView removeViewAnimated:YES];
//        delegate.isConverting = NO; vinh
        
        return;
    }
    
    
//    delegate.isConverting = YES; vinh
    
	assetWriterInput.expectsMediaDataInRealTime = NO;
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    NSLog(@"soundTrack.naturalTimeScale: %d",soundTrack.naturalTimeScale);
    
    FloatRange r = self.slider.value;
    assetReader.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(r.min, soundTrack.naturalTimeScale),
                                            CMTimeMakeWithSeconds(r.max - r.min, soundTrack.naturalTimeScale)); // 2 params: start time, duration
    
    
	[assetWriter startWriting];
	[assetReader startReading];
    
	
    
	CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
	[assetWriter startSessionAtSourceTime: startTime];
	
	dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
	[assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
											usingBlock: ^
	 {
		 // NSLog (@"top of block");
		 while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
             } else {
                 // done!
                 [assetWriterInput markAsFinished];
                 
                 
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
                 
                 NSLog(@"done converting caf, now convert to m4r");
                 [self startConvertCafToM4r];
             }
         }
         
	 }];
    
    //    [CommonUtils stopIndicatorDisableViewController:self];
    
}

// Return unique path for record file to be stored in Documents Folder
- (NSString *) urlPathForRecord;
{
    NSString *fileName = [selectedItem valueForProperty:MPMediaItemPropertyTitle];
    
    int i = 0;
    
    NSString *uniquePath = [CommonUtils pathForSourceFile:[NSString stringWithFormat:@"%@.caf", fileName] inDirectory:kTempFolderConvert];
    //[NSString stringWithFormat:@"%@/%@.caf",DOCUMENTS_PATH,fileName];
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
    {
        uniquePath = [CommonUtils pathForSourceFile:[NSString stringWithFormat:@"%@-%d.caf", fileName, ++i] inDirectory:kTempFolderConvert];
        
        //[NSString stringWithFormat:@"%@/%@-%d.caf", DOCUMENTS_PATH, fileName, ];
    }
    
    NSLog(@"uniquePath: %@", uniquePath);
    
    lastConvertedCafName = [uniquePath copy];
	return uniquePath;
}




#pragma mark - Audio converter delegate

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
    //    NSLog(@"progress: %f", progress);
}

-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {
    
    audioConverter = nil;
    
    //delete temp file
    NSArray *arr = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *fileToDelete = lastConvertedCafName;
    if (arr && [arr count] > 0) {
        fileToDelete = [arr lastObject];
    }
    [[RingtoneHelpers defaultHelper]deleteTempConvert:fileToDelete];
    
    //    [CommonUtils stopIndicatorDisableViewController:self];
    
    [DSBezelActivityView removeViewAnimated:YES];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate; vinh
//    delegate.isConverting = FALSE; vinh
    
    //back
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                 message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't convert audio: %@", @""), [error localizedDescription]]
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
    
    audioConverter = nil;
    
    //delete temp file
    NSArray *arr = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *fileToDelete = lastConvertedCafName;
    if (arr && [arr count] > 0) {
        fileToDelete = [arr lastObject];
    }
    [[RingtoneHelpers defaultHelper]deleteTempConvert:fileToDelete];
    
    
    [DSBezelActivityView removeViewAnimated:YES];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate; vinh
//    delegate.isConverting = FALSE; vinh
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"songid: %@", songid);

    
    [super viewDidLoad];
    songModel = [[SongModel alloc] init];
    
    SongField *songField = [[SongField alloc] init];
    songField =  [songModel getRowByRowsInSongTableByRowId:songid];
   

    
//    if (![songid isEqualToString:@"0"]) {
//        return;
//    }
    
    NSString *title = @"";
    NSNumber *duration = 0;
    if ([songid intValue]>=1) {
        
        title = songField.name;
        
        sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:songField.path] error:nil];
        duration = [NSNumber numberWithFloat: sound.duration];;
        
    }
    else if([songid intValue]==-1){
        title = recordFileTemp;
        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER,recordFileTemp]];
        
        sound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        duration = [NSNumber numberWithFloat: sound.duration];
    }else{
        title = [selectedItem valueForProperty:MPMediaItemPropertyTitle];
        duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    }

    self.title = title;
    
    
    
    //create slider
    CGRect frame;
    //	frame.origin = CGPointZero;
    frame.origin = CGPointMake(5.0f, 0.0f);
    
    slider = [[ASRangeSlider alloc] initWithSpectrum:FloatRangeMake(0.0f, durationPerScroll)];

	[slider setThumbBackgroundImage:[UIImage imageNamed:@"Slider.png"]];
    [slider setTrackBackgroundImage:[UIImage imageNamed:@"SliderBk_dummy.png"]];

    //[slider setTrackBackgroundImage:[UIImage imageNamed:@"SliderBk_dummy.png"]];
	frame.size =  CGSizeMake(sliderPlaceHolder.frame.size.width - 10.0f, sliderPlaceHolder.frame.size.height);  //sliderPlaceHolder.frame.size;
	slider.frame = frame;
    
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	slider.activeAreaView.backgroundColor =  [UIColor clearColor] ; //[UIColor colorWithRed:(180.0/256.0) green:(24.0/256.0) blue:(34.0/256.0) alpha:0.5];
    [sliderPlaceHolder addSubview:slider];
	[slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //    CGFloat minValue = (kDefaultRingtoneCutStartPoint > [duration floatValue]) ? 0 : kDefaultRingtoneCutLength;
    //    CGFloat maxValue = (kDefaultRingtoneCutLength > [duration floatValue]) ? [duration floatValue] : kDefaultRingtoneCutLength;
    self.slider.value = FloatRangeMake(5.0, 0 + kRingtoneCutMinDuration);
    NSLog(@"slider.value.min: %f", slider.value.min);
    NSLog(@"slider.value.max: %f", slider.value.max);
    //    [self updateSliderLabels];
    
    if ([songid intValue]>=1) {
        NSLog(@"sfds");
    }
    else if([songid intValue]==-1){
        
    }else{
        NSLog(@"songid: %@", songid);
        //init player
        player = [MPMusicPlayerController applicationMusicPlayer];
        [player beginGeneratingPlaybackNotifications];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangePlaybackState:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
        
        MPMediaItemCollection *collection = [[MPMediaItemCollection alloc]initWithItems:[NSArray arrayWithObject:selectedItem]];
        [player setQueueWithItemCollection:collection];

    }
    
    
    //update duration
    labelEnd.text = [CommonUtils convertToDateTimeFrom:[duration floatValue]];
    
    //ratio: slideWidth px: 60s
    // ? px: duration -> duration * slideWidth / 60;
    scrollRange.clipsToBounds = NO;
    UIImage *imgWave = [UIImage imageNamed:@"Sound_wave.png"]; //vinh
   CGSize sizeWave = imgWave.size;//vinh
    //CGSize sizeWave = CGSizeMake(295, 158);
    
    //calculate needed content width
    CGFloat neededContentWidth = [duration floatValue] * scrollRange.frame.size.width / durationPerScroll;
    //NSLog(@"neededContentWidth: %f", neededContentWidth);
    scrollRange.contentSize = CGSizeMake(neededContentWidth, scrollRange.frame.size.height);
    
    //add image to scrollview
    
    CGFloat scrollContentWidth = 5.0f;
    while (scrollContentWidth < neededContentWidth) {
        UIImageView *imgViewWave = [[UIImageView alloc]initWithImage:imgWave];
        imgViewWave.contentMode = UIViewContentModeLeft;
        imgViewWave.clipsToBounds = YES;
        CGFloat imgviewWidth = sizeWave.width;
        
        if (scrollContentWidth + sizeWave.width > neededContentWidth) {
            imgviewWidth = neededContentWidth - scrollContentWidth;
            
            //            scrollContentWidth = neededContentWidth;
        }
        
        imgViewWave.frame = CGRectMake(scrollContentWidth, 0.0f, imgviewWidth, scrollRange.frame.size.height);
        
        //        [scrollRange insertSubview:imgViewWave belowSubview:viewSelection];
        [scrollRange addSubview:imgViewWave];
        
        
        scrollContentWidth += imgviewWidth;
    }
    //    [scrollRange bringSubviewToFront:viewSelection];
    
    [self.view addSubview:viewSelection];
    viewSelection.frame = CGRectMake(0, 0, 57, 300);
    startRange = 0;
    endRange = durationPerScroll;
    
    //    [self updateTimeLabels];
    [self sliderValueChanged:self.slider];
   // [self sliderValueChanged:self];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (player) {
        [player stop];
    }
    if (sound) {
        [sound stop];
    }
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
    
    return YES;
}


@end