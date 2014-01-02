//
//  DatabaseManager.h
//  ThanksApp
//
//  Created by Dat Nguyen on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DatabaseManager : NSObject {

}

+ (DatabaseManager *)defaultManager;

- (void)copyDatabaseIfNeeded;
- (NSString *)getDBPath;


- (NSMutableArray *)selectRingtoneFromDBError:(NSError **)errorOrNil;
- (BOOL)insertRingtoneToDB:(NSDictionary *)dict error:(NSError **)errorOrNil;
- (BOOL)deleteRingtoneFromDB:(NSDictionary *)dict error:(NSError **)errorOrNil;



@end
