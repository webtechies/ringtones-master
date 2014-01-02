//
//  Common.h
//  


//
//  Created by Duc Nguyen on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



typedef enum {
    kPlatformIpad = 0,
    kPlatformNormallyiPhone = 1,
    kPlatformNormallyiPhone5 = 2,
    kPlatformN_A = -1,
} kTypePlatform;




@interface Common : NSObject


+(void) setOrientation:(NSString *) orientation;
+(NSString *) getOrientation;


+ (NSString*) documentsPath;

+(NSString *)savePathForDownloadedRingtonesWithRingtoneName: (NSString *)ringtoneName;
+(NSString *)savePathForCreatedRingtonesWithRingtoneName: (NSString *)ringtoneName;

+ (NSString *) getImageName:(NSString *) name;

//--get uuid
-(NSString *) makeUUID;

//--Get info device and apps
-(NSString *) infoAppName;


//--Validate Email
+(BOOL) validateEmail:(NSString *)originalString;

//--Check network wifi and wlan
+(BOOL) checkNetWork;

+ (BOOL) validatePhone: (NSString *) aMobile;

+(NSString *)urlEncodeUsingEncoding:(NSString *) keyword;
//-- init nsmanagedobject
+(NSManagedObjectContext *) initManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;


//-- init nsmanagedobject
+(NSPersistentStoreCoordinator *) initPersistenStoreCoordinator:(NSPersistentStoreCoordinator *) prersistentStoreCoordinator;


-(BOOL) allowGoogleAdmob;

//--format date from date to string
-(NSDate *) formatDateFromString:(NSString *) stringDate;

//--formatdate from string to date
+(NSString *) formatStringFromDate:(NSDate *) date;

-(NSDate *) formatDateFromString2:(NSString *) stringDate;


- (NSString *)dateUS:(NSString *) dateStr;

//--+(void) reduceNumberBadgeApp;
//--+(void) reduceNumber:(int) numberBadge;


//////////////////////////////////////////////////////////////////
- (int)hourBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2;


//////////////////////////////////////////////////////////////////
- (int)daysBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2;
    
//////////////////////////////////////////////////////////////////
- (int)secondsBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dtt2;


//////////////////////////////////////////////////////////////////
- (int)minitueBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2 ;


//////////////////////////////////////////////////////////////////
+(NSString *) returnFileNameWithoutTheExtension:(NSString *)fileName;


//////////////////////////////////////////////////////////////////
+(NSString *) returnMusicTimeFormatWithValue: (float)value;




+(kTypePlatform) checkPlatform;
+(NSString *) checkDevice:(NSString *)viewFirstName;

+ (AppDelegate *) getCurrentDelegate;






@end
