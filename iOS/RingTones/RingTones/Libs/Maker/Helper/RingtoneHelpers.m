//
//  RingtoneHelpers.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtoneHelpers.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CommonUtils.h"
//#import "DatabaseManager.h"
//#import "DownloaderManager.h"
//#import "DownloadTask.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
//#import "SMXMLDocument.h"

static RingtoneHelpers *_defaultHelper;
@implementation RingtoneHelpers

+ (RingtoneHelpers *) defaultHelper;
{
    if (_defaultHelper == nil) {
        _defaultHelper = [[RingtoneHelpers alloc]init];
    }
    
    return _defaultHelper;
}

- (NSInteger)durationOfSoundNamed:(NSString *)name;
{
    NSInteger durationOutput = 0;
    
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:name]];
//    if (item != nil) {
//        CMTime durationTime = item.duration;
//        durationOutput = durationTime.value/durationTime.timescale;
//        
//        [item release]; 
//    }
    
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:name] error:&error];
    NSLog(@"error: %@", [error localizedDescription]);

    durationOutput = player.duration;
    
    [player release];
    
    /*
	AVURLAsset *songAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:name]];
    
    NSError *assetError = nil;
	AVAssetReader *assetReader = [[AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError]
								  retain];
	if (assetError) {
		NSLog (@"error: %@", assetError);
	}

    
    if (assetReader != nil) {
        CMTime durationTime = [assetReader timeRange].duration;
        NSLog(@"meta: %@", [songAsset commonMetadata]);

        durationOutput = durationTime.value/durationTime.timescale;
        
    }
     */
    
    
/*
    
    AudioFileID fileID  = nil;
    OSStatus err        = noErr;
    
    CFDictionaryRef piDict = nil;
    UInt32 piDataSize   = sizeof( piDict );
    
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary" );
    } else {
    
        // CF
        // it sure would've been nice if they had DOCUMENTED that CFSTR needed to be used
        NSNumber * duration = (NSNumber *)CFDictionaryGetValue( piDict, CFSTR( kAFInfoDictionary_ApproximateDurationInSeconds ));

        durationOutput = [duration intValue];
        
        CFRelease( piDict );
    //    free( rawID3Tag );

    }*/
    
    return durationOutput;
}

- (NSMutableArray *)listDownloadedRingtones;
{
    if (_arrDownloadedRingtones == nil) {
        [_defaultHelper getListRingtoneFromDocument];
    }
    return _arrDownloadedRingtones;
}

- (NSMutableArray *)getListRingtoneFromDocument;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *arDocumentContent = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];    
    
//    F_RELEASE(_arrDownloadedRingtones);
    if (arDocumentContent != nil) {
        _arrDownloadedRingtones = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [arDocumentContent count]; i++) {
            NSString *file = [arDocumentContent objectAtIndex:i];
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            //check if is ringtone type
            if ([file hasSuffix:@"mp3"] || [file hasSuffix:@"m4r"] 
                || [file hasSuffix:@"aac"] || [file hasSuffix:@"caf"] ) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                NSError *errorReadFile = nil;
                
                NSDictionary *dictAttribute = [fileMgr attributesOfItemAtPath:fullPath error:&errorReadFile];
                
                NSDate *createdDate = [dictAttribute fileCreationDate];
                NSString *createdString = [NSString stringWithFormat:@"%f", [createdDate timeIntervalSince1970]];
                
                NSString *sizeString = [NSString stringWithFormat:@"%llu", [dictAttribute fileSize]];
                
                NSString *durationString = [NSString stringWithFormat:@"%d", [self durationOfSoundNamed:fullPath]];
                
                
                [dict setObject:file forKey:@"title"];
                [dict setObject:@"5" forKey:@"rate"];
                [dict setObject:createdString forKey:@"createdDate"];
                [dict setObject:sizeString forKey:@"size"];
                [dict setObject:durationString forKey:@"duration"];
                
//                NSLog(@"dict: %@", dict);
                
                
                //add to list
                [_arrDownloadedRingtones addObject:dict];
                
                [dict release];

            }
        }
    }
    
    return _arrDownloadedRingtones ;
}



- (void)addRingtoneToList:(NSDictionary *)dict;
{
    if (_arrDownloadedRingtones == nil) {
        _arrDownloadedRingtones = [[NSMutableArray alloc]init];
    }
    
    [_arrDownloadedRingtones addObject:dict];
}

- (void)removeRingtoneByID:(NSInteger)ringtoneId;
{
    for (int i = 0; i < [_arrDownloadedRingtones count]; i++) {
        NSDictionary *dict = [_arrDownloadedRingtones objectAtIndex:i];
        
        if ([[dict objectForKey:@"id"] intValue] == ringtoneId) {
            [_arrDownloadedRingtones removeObjectAtIndex:i];
            
            break;
        }
    }
}

- (BOOL)deleteRingtoneFromDocument:(NSString *)name;
{	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSString *path = [CommonUtils pathForSourceFile:name inDirectory:nil];
    
    BOOL deleteResult = [fileMgr removeItemAtURL:[NSURL fileURLWithPath:path] error:&error];  
    
    if (error) {
        NSLog(@"cannot delete file: %@", [error localizedDescription]);
    }
    return deleteResult;
}

- (BOOL)deleteTempConvert:(NSString *)name;
{	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSString *path = [CommonUtils pathForSourceFile:name inDirectory:kTempFolderConvert];
    
    BOOL deleteResult = [fileMgr removeItemAtURL:[NSURL fileURLWithPath:path] error:&error];  
    
    if (error) {
        NSLog(@"cannot delete file: %@", [error localizedDescription]);
    }
    return deleteResult;
}


- (void)getListDownloadedRingtonesFromDB;
{
    F_RELEASE(_arrDownloadedRingtones);
    
    NSError *error = nil;
//    _arrDownloadedRingtones = [[[DatabaseManager defaultManager]selectRingtoneFromDBError:&error] retain]; vinh
    
}

- (void)callDownloadRingtoneUrl:(NSString *)url;
{

}

- (void)callDownloadRingtoneDict:(NSDictionary *)dict;
{
    NSString *url = [dict objectForKey:@"link"];
    NSString *key = [dict objectForKey:@"id"];
    NSString *fileName = [dict objectForKey:@"title"];
    
    
    ASIHTTPRequest *requestRegister = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    
    
    [requestRegister setDownloadDestinationPath:[CommonUtils pathForSourceFile:fileName inDirectory:nil]];

    
    [requestRegister setTimeOutSeconds:50.0f];
    [requestRegister setFailedBlock:^{
        //Fail handle here
        NSLog(@"download fail for url: %@\nError: %@", url, [[requestRegister error] localizedDescription]);
    }];
    
//    [requestRegister];
    [requestRegister setCompletionBlock:^{
        //Compete handle here
        //send notification
        NSLog(@"Done");
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoneDownloadRingtone object:key];
    }];
    
    
	[requestRegister startAsynchronous];
}

- (void)downloadRingtoneFromDict:(NSDictionary *)dict;
{
    
//    [[DownloaderManager defaultManager] startNewTaskWithTarget:self
//                                   selector:@selector(callDownloadRingtoneDict:)
//								 object:dict];


//    [[DownloaderManager defaultManager]addRequestToQueueFromDict:dict];  vinh

}

- (NSMutableArray *)convertDataToList:(NSData *)data;
{
    /*
    NSMutableArray *arrReturn = nil;
    //Parse data here
    
    //handle special character
    NSString *stringXML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&" withString:@"{{symbol_and}}"];
    
    NSData *newData = [stringXML dataUsingEncoding:NSUTF8StringEncoding];
    
    SMXMLDocument* xmlDoc = [SMXMLDocument documentWithData:newData error:NULL];
    SMXMLElement* root = [xmlDoc root];
    for(SMXMLElement* item in [root children]){
//        NSLog(@"--->%@",[item name]);
        NSMutableDictionary* ditem = [[NSMutableDictionary alloc] init];
        for(SMXMLElement* key in [item children]){
            //NSLog(@"------->%@ = %@",[key name],[key value]);
            NSString* iva = @"";
            if([key value])iva = [key value];
            
            iva = [iva stringByReplacingOccurrencesOfString:@"{{symbol_and}}" withString:@"&"];
            
            [ditem setObject:iva forKey:[key name]];
        }
        if (arrReturn == nil) {
            arrReturn = [[NSMutableArray alloc]init];
        }
        //add dictionary to array
        [arrReturn addObject:ditem];
        //release
        [ditem release];
    }
    
     
    return [arrReturn autorelease]; vinh */
    return nil;
}


@end
