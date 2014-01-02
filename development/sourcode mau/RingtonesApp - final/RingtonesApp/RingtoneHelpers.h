//
//  RingtoneHelpers.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RingtoneHelpers : NSObject {
    NSMutableArray *_arrDownloadedRingtones;
}


+ (RingtoneHelpers *) defaultHelper;
- (NSInteger)durationOfSoundNamed:(NSString *)name;

- (void)getListDownloadedRingtonesFromDB;
- (NSMutableArray *)getListRingtoneFromDocument;

- (void)addRingtoneToList:(NSDictionary *)dict;
- (void)removeRingtoneByID:(NSInteger)ringtoneId;
- (BOOL)deleteRingtoneFromDocument:(NSString *)name;
- (BOOL)deleteTempConvert:(NSString *)name;

- (void)downloadRingtoneFromUrl:(NSString *)url;

- (void)downloadRingtoneFromDict:(NSDictionary *)dict;

- (NSMutableArray *)convertDataToList:(NSData *)data;

@end
