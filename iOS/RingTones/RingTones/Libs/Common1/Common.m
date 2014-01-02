//
//  Common.m
//  AttackByTurniPhoneGame
//
//  Created by Duc Nguyen on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"


@implementation Common




#pragma mark - Check Platform

+(kTypePlatform) checkPlatform
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return kPlatformIpad;
    else{
        
        CGSize sizeScreen  = [UIScreen mainScreen].bounds.size;
        //        NSLog(@"size screen: %@", NSStringFromCGSize(sizeScreen));
        if (sizeScreen.height == 568.0f)
            return kPlatformNormallyiPhone5;
        else
            return kPlatformNormallyiPhone;
    }
    
    return kPlatformN_A;
}


+ (NSString *) getImageName:(NSString *) name
{
    if (IS_IPAD)
    {
        name = [NSString stringWithFormat:@"ipad_%@", name];
    }
    return name;
}


+(NSString *) checkDevice:(NSString *)viewFirstName{
    NSString *viewName=@"";
    kTypePlatform typePlatform = [Common checkPlatform];
    switch (typePlatform) {
            
        case kPlatformNormallyiPhone5:
        {
            viewName = [NSString stringWithFormat:@"Iphone5%@", viewFirstName];
        }
            break;
        case kPlatformNormallyiPhone:
        {
            viewName =viewFirstName;
        }
            
            break;
        case kPlatformIpad:
        {
           viewName = [NSString stringWithFormat:@"Ipad%@", viewFirstName];
        }
            
            break;
        default:
            break;
    }
    
    return viewName;
}



-(BOOL) allowGoogleAdmob
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"allowGoogleAdmob"])
    {
        //--NSLog(@" vao day la sao");
        [defaults setBool:YES forKey:@"allowGoogleAdmob"];
    }

    
    return [defaults boolForKey:@"allowGoogleAdmob"];
}



+(void) setOrientation:(NSString *) orientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:orientation forKey:@"orientation"];
    [defaults synchronize];
}

+(NSString *) getOrientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *orientation = [defaults valueForKey:@"orientation"];
    return orientation;
}




+ (NSString*) documentsPath
{
    NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* _documentsPath = [searchPaths objectAtIndex: 0];
    
    return _documentsPath;
}




//-------------------------------------------------------
//
+(NSString *)savePathForDownloadedRingtonesWithRingtoneName: (NSString *)ringtoneName
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsPath = [[searchPaths objectAtIndex: 0] stringByAppendingString:@"/Downloaded"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if (!exists)
    {

        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    }
    
    NSString *saveFolderPath = [documentsPath stringByAppendingPathComponent:ringtoneName];

    return saveFolderPath;
}


//-------------------------------------------------------
//
+(NSString *)savePathForCreatedRingtonesWithRingtoneName: (NSString *)ringtoneName
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsPath = [[searchPaths objectAtIndex: 0] stringByAppendingString:@"/Created"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if (!exists)
    {
        
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
    }
    
    NSString *saveFolderPath = [documentsPath stringByAppendingPathComponent:ringtoneName];
    
    return saveFolderPath;
}

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
#pragma mark - DEVICE


//////////////////////////////////////////////////////////////////
-(NSString *) makeUUID
{
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	NSString *deviceUuid;

		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		id uuid = [defaults objectForKey:@"deviceUuid"];
		if (uuid)
			deviceUuid = (NSString *)uuid;
		else {
            CFUUIDRef cfuuid = CFUUIDCreate(NULL);
            deviceUuid = (NSString *)CFUUIDCreateString(NULL, cfuuid);
            CFRelease(cfuuid);
            [defaults setObject:deviceUuid forKey:@"deviceUuid"];
            [deviceUuid autorelease];
            [defaults synchronize];
		}
    
    return deviceUuid;
}



+(NSString *)urlEncodeUsingEncoding:(NSString *) keyword
{
    NSString *trimmedString = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *encodedString = @"";
    encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)trimmedString, NULL, NULL, kCFStringEncodingUTF8) ;
    encodedString = [encodedString autorelease];
    //--NSLog(@"encodedString %@",encodedString);
    return encodedString;

}


/////////////////////////////////////////////////////////////////////////////////////////////
//--Get info device and apps
-(NSString *) infoAppName
{
    
#if !DEBUG
    
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
#endif
    return  @"";
}


//////////////////////////////////////////////////////////////////
+(BOOL) validateEmail:(NSString *)originalString
{
    NSString *regexString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regex evaluateWithObject:originalString];
}


//////////////////////////////////////////////////////////////////
/**
 * Check network wifi and wlan
 */
+(BOOL) checkNetWork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com.vn"];
    NetworkStatus intenetStatus = [r currentReachabilityStatus];
    
    if ((intenetStatus != ReachableViaWiFi) && (intenetStatus != ReachableViaWWAN))
    {
        return NO;
    }
    return YES;
}

+ (BOOL) validatePhone: (NSString *) aMobile
{
    NSString *phoneRegex = @"^+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:aMobile];
}


//////////////////////////////////////////////////////////////////
//--format date from date to string
-(NSDate *) formatDateFromString:(NSString *) stringDate
{
    //    NSLog(@"String date: %@", stringDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    [dateFormatter release];
  
    
    return date;
}


//////////////////////////////////////////////////////////////////
//--format date from date to string
-(NSDate *) formatDateFromString2:(NSString *) stringDate
{
    //    NSLog(@"String date: %@", stringDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    [dateFormatter release];
    
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:timeZoneOffset];
    
    
    return localDate;
}



//////////////////////////////////////////////////////////////////
//--formatdate from string to date
+(NSString *) formatStringFromDate:(NSDate *) date
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    NSString *stringReturn = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    return  stringReturn;
}



- (NSString  *)dateUS:(NSString *) dateStr
{
    // e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setDateFormat:@"%a, %d %b %Y %H:%M:%S GMT"]; // won't work with -init, which uses new (unicode) format behaviour.
	[dateFormatter setDateFormat:@"MMM dd, HH:mm"];

    NSDate *gmtDate  = [self formatDateFromString:dateStr];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:gmtDate];
    NSDate *localDate = [gmtDate dateByAddingTimeInterval:timeZoneOffset];
    
    NSString *dateStr2 = [dateFormatter stringFromDate:localDate];

    
	return dateStr2;
}


//////////////////////////////////////////////////////////////////
- (int)daysBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2 {
    int numDays;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    numDays = [components day];
    [gregorian release];
    return numDays;
}




//////////////////////////////////////////////////////////////////
- (int)hourBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2 {
    int numDays;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    numDays = [components hour];
    
    [gregorian release];
    return numDays;
}


//////////////////////////////////////////////////////////////////
- (int)minitueBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2 {
    int numDays;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    numDays = [components minute];

    [gregorian release];
    return numDays;
}

//////////////////////////////////////////////////////////////////
- (int)secondsBetweenDates:(NSDate *)dt1 andDate:(NSDate *)dt2 {
    int numDays;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
   NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    numDays = [components second];
    [gregorian release];
    return numDays;
}




//-------------------------------------------------------
//
+(NSString *) returnFileNameWithoutTheExtension:(NSString *)fileName
{
    NSString *fileName_extension = [fileName pathExtension];
    NSInteger fileNameExtensionLength = [fileName_extension length];
    NSInteger fileName_length = [fileName length];
    fileName_length = fileName_length - (1 + fileNameExtensionLength);
    return [ fileName substringWithRange:NSMakeRange(0, fileName_length) ];
}



//-------------------------------------------------------
//
+(NSString *)returnMusicTimeFormatWithValue: (float)value
{
    if (value < 0) {
        value = 0.0f;
    }
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:value];
    //Then specify output format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"m:ss"];
    
    NSString *timeLeft = [NSString stringWithFormat:@"-%@", [dateFormatter stringFromDate:d]];
    
    return timeLeft;
    
}



//+(void) reduceNumberBadgeApp
//{
//    int currentNumberBadge =  [UIApplication sharedApplication].applicationIconBadgeNumber;
//    
//    if (currentNumberBadge > 0)
//    {
//        int hieu = currentNumberBadge-1;
//        if(hieu <= 0) hieu = 0;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hieu];
//
//    }
//}
//
//+(void) reduceNumber:(int) numberBadge
//{
//    int currentNumberBadge =  [UIApplication sharedApplication].applicationIconBadgeNumber;
//    
//    /*UIAlertView *alert2= [[UIAlertView alloc] initWithTitle:@"Current badge" message:[NSString stringWithFormat:@"The current badge %d",currentNumberBadge] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert2 show];
//    [alert2 release];*/
//    
//    if (currentNumberBadge > 0)
//    {
//        int hieu = currentNumberBadge-numberBadge;
//        if(hieu <= 0) hieu = 0;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hieu];
//    }
//}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
#pragma mark - GROUP MODEL





@end
