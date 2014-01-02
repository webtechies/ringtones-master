//
//  DatabaseManager.m
//  ThanksApp
//
//  Created by Dat Nguyen on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"
#import "Constants.h"
#import "FMDatabase.h"
#import "CommonUtils.h"



static DatabaseManager *_defaultManager;
static FMDatabase *_database;
@implementation DatabaseManager

+ (DatabaseManager *)defaultManager
{
    if (_defaultManager == nil) {
        _defaultManager = [[DatabaseManager alloc]init];
        
        [_defaultManager copyDatabaseIfNeeded];
    }
    
    return _defaultManager;
}

//--------------------------------------------------------------------------//
- (NSString *)getDBPath;
{	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    
	return [documentsDir stringByAppendingPathComponent:DATABASE_FILENAME_FULL];
}
//--------------------------------------------------------------------------//

//--------------------------------------------------------------------------//
// Function to copy database file to mobile
- (void)copyDatabaseIfNeeded;
{	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
//	[fileManager removeItemAtPath:dbPath error:&error];

	if(!success) {	
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_FILENAME_FULL];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	} 
}

- (FMDatabase *)database
{
    if (_database == nil) {
        _database = [[FMDatabase alloc]initWithPath:[self getDBPath]];
    }
    
    return _database;
}


#pragma -Query Pocket
- (NSMutableArray *)selectRingtoneFromDBError:(NSError **)errorOrNil;
{
    if (![[self database] open]) {
        NSLog(@"Could not open db.");
        
        return nil;
    }
    
    NSMutableArray *listReturn = nil;
    
    FMResultSet *rs = [[self database] executeQuery:@"SELECT id,name,rate,createdDate,size,duration FROM tableRingtone"];
    while ([rs next]) {
        if (listReturn == nil) {
            listReturn = [[NSMutableArray alloc]init];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        //id
        NSString * ringtoneId= [NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]];
        [dict setObject:ringtoneId forKey:@"id"];

        //name
        NSString * name= [rs stringForColumn:@"name"];
        [dict setObject:name forKey:@"name"];

        //rate
        NSString * rate= [NSString stringWithFormat:@"%d",[rs intForColumn:@"rate"]];
        [dict setObject:rate forKey:@"rate"];

        //createdDate
        double createdDateDouble = [rs doubleForColumn:@"createdDate"];
        NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:createdDateDouble];
        [dict setObject:createdDate forKey:@"createdDate"];

        //size
        NSString * size= [NSString stringWithFormat:@"%f",[rs doubleForColumn:@"size"]];
        [dict setObject:size forKey:@"size"];

        //duration
        NSString * duration= [NSString stringWithFormat:@"%f",[rs doubleForColumn:@"duration"]];
        [dict setObject:duration forKey:@"duration"];

        [listReturn addObject:dict];
        
        [dict release];
    }
    
    
    return [listReturn autorelease];
}

- (BOOL)insertRingtoneToDB:(NSDictionary *)dict error:(NSError **)errorOrNil;
{
    if (![[self database] open]) {
        NSLog(@"Could not open db.");
        
        return FALSE;
    }
    
    // insert to DB
    NSString* query = [NSString stringWithFormat:@"INSERT INTO tableRingtone (name,rate,createdDate,size,duration) VALUES ('%@','%d','%f','%f','%f')",
                       [CommonUtils getSafeValueForKey:@"name" inDictionary:dict],
                       [[CommonUtils getSafeValueForKey:@"rate" inDictionary:dict] intValue],
                       [[CommonUtils getSafeValueForKey:@"createdDate" inDictionary:dict] doubleValue],
                       [[CommonUtils getSafeValueForKey:@"size" inDictionary:dict] doubleValue],
                       [[CommonUtils getSafeValueForKey:@"duration" inDictionary:dict] doubleValue]                       
                       
                       ];
    BOOL result = [[self database] executeUpdate:query error:errorOrNil withArgumentsInArray:NULL orVAList:nil];
    
    [[self database] close];
    
    return result;
    
    return TRUE;
}

- (BOOL)deleteRingtoneFromDB:(NSDictionary *)dict error:(NSError **)errorOrNil;
{
    if (![[self database] open]) {
        NSLog(@"Could not open db.");
        
        return FALSE;
    }
    
    // remove from db
    NSString* query = [NSString stringWithFormat:@"DELETE FROM tableRingtone WHERE 'id' = '%@'",
                       [CommonUtils getSafeValueForKey:@"id" inDictionary:dict]                       ];
    BOOL result = [[self database] executeUpdate:query error:errorOrNil withArgumentsInArray:NULL orVAList:nil];
    
    [[self database] close];
    
    return result;
    
    return TRUE;
}

//
//
//
//#pragma -Query Send
//- (BOOL)insertSentItemToDB:(CardItem *)itemObj error:(NSError **)errorOrNil
//{
//    if (![[self database] open]) {
//        NSLog(@"Could not open db.");
//        
//        return FALSE;
//    }
//    
//    // insert to DB
//    NSString* query = [NSString stringWithFormat:@"INSERT INTO tblPocket (IDFrom,IDTo,SendTime,MessageContent,MessagePosition,UseTemplate,MySendCard,Viewed,Image) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",
//                       [NSString stringWithFormat:@"%@:%@", itemObj.IDFrom, itemObj.sender], 
//                       [NSString stringWithFormat:@"%@:%@", itemObj.IDTo, itemObj.toName], 
//                       [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]],
//                       itemObj.MessageContent, 
//                       itemObj.MessagePosition, 
//                       @"1",
//                       itemObj.myCard ? @"1": @"0",
//                       @"1",
//                       itemObj.templateId];
//    BOOL result = [[self database] executeUpdate:query error:errorOrNil withArgumentsInArray:NULL orVAList:nil];
//    
//    [[self database] close];
//    
//    return result;
//    
//}
//
//
//#pragma Query Wall
//- (BOOL)insertWallItemToDB:(MessageItem *)itemObj error:(NSError **)errorOrNil
//{
//    if (![[self database] open]) {
//        NSLog(@"Could not open db.");
//        
//        return FALSE;
//    }
//        
//    // insert to DB
//    NSString* query = [NSString stringWithFormat:@"INSERT INTO tblWall (fromID,fromName,SendTime,MessageContent) VALUES ('%@','%@','%@','%@')",itemObj.fromID, itemObj.fromName, itemObj.SendTime, itemObj.MessageContent];
//    
//    BOOL result = [[self database] executeUpdate:query error:errorOrNil withArgumentsInArray:NULL orVAList:nil];
//    
//    [[self database] close];
//    
//    return result;
//}


@end
