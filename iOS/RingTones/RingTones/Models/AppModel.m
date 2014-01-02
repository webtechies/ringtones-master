//
//  AppModel.m
//  SpexBeta
//
//  Created by DucNguyen on 9/14/12.
//  Copyright (c) 2012 Carbon8. All rights reserved.
//

#import "AppModel.h"

static sqlite3  *initDatabase = NULL;


@interface AppModel ()

-(NSString *) filePath;
-(void) isExistDatabase;

-(void) openDatabase;
-(void) closeDatabase;

@end

@implementation AppModel
@synthesize db;
@synthesize idRow;
@synthesize usesTable;


#pragma mark - Init



/* init database */
-(id) init
{
    self = [super init];
    if (self)
    {

        [self isExistDatabase];
        [self openDatabase];
  
    }
    return self;
}




#pragma mark - Open Database



/* File path to document directory */
-(NSString *) filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:kNameDatabase];
}


/* check database already import in my app */
-(void) isExistDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *finalPath = [documentPath stringByAppendingPathComponent:kNameDatabase];
    success = [fileManager fileExistsAtPath: finalPath];
    //NSLog(@"final path: %@", finalPath);
    
    if (success) 
    {
      
        return;
    }
    else
    {
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kNameDatabase];
        NSError *error;
        success = [fileManager copyItemAtPath:defaultPath toPath:finalPath error:&error];
    }
}


#pragma mark - query


/* Perform open database */
-(void) openDatabase
{
    if (initDatabase == NULL)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *pathToDabase = [self filePath];
            
            
            if (sqlite3_open([pathToDabase UTF8String], &db) != SQLITE_OK)
            {
     
                sqlite3_close(db);
                NSAssert(0, @"Can not open database at line: %d in the function %@", __LINE__, NSStringFromSelector(_cmd));
            }
          
            initDatabase =  self.db;
        });
       
    }else{
        self.db =  initDatabase;
    }
}


/* Close database */
-(void) closeDatabase
{
    sqlite3_close(self.db);
}





#pragma mark - Saving Your Data


/* create a new row */
-(BOOL) create:(id) data
{
    return YES;
}


/* save a field  */
/* before using. set entiry.id = ? */
-(BOOL) saveField:(NSString *) fieldName value:(id) fieldValue
{
    return YES;
}


/** update all field */
-(BOOL) updateAll:(id) data
{
    return NO;
}



#pragma mark - Retrieving Your Data


/* find data from entity */
/* type will be: max, first, count, all */
-(NSMutableArray *) find:(NSString *) type andCondition:(NSArray *) condition andOrderBy:(NSArray *) fieldsOrder limitRow:(NSInteger) limit
{
    return nil;
}


#pragma  mark - Deleting Data

/* delete by id*/
-(BOOL) deleteById:(NSInteger) idDelete
{
    return YES;
}


/* delete all data with conditiosn and callback is return id has deleted */
-(void) deleteAll:(NSArray *) conditions
{
    
}


#pragma mark - Additional Methods and Properties


/* Returns true if a record with the particular ID exists. */
-(BOOL)exists:(NSInteger) idEntity
{
    return YES;
}


/* Returns the column type of a column in the model. */
-(NSString *) getColumnType
{
    return nil;
}


/* Returns the current record’s ID. */
-(id) getId:(NSInteger) idEntity
{
    return nil;
}


/* Returns the ID of the last record this model inserted. */
-(NSInteger) getInsertID
{
    NSInteger i = sqlite3_last_insert_rowid(self.db);
    //--NSLog(@"i = %d", i);
    
    return i;
}


/** Tim charact '*/
-(NSString *) escapeSingleQuote:(NSString *) str
{
    return  [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}


@end
