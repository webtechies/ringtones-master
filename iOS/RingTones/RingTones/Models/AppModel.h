//
//  AppModel.h
//  SpexBeta
//
//  Created by DucNguyen on 9/14/12.
//  Copyright (c) 2012 Carbon8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define kNameDatabase @"Ringtones.sqlite"
@interface AppModel : NSObject
{
    sqlite3 *db;
    NSString *usesTable;
    NSString *idRow;
}

@property (nonatomic, assign) sqlite3 *db;

@property (strong, nonatomic) NSString *usesTable;
@property (strong, nonatomic) NSString *idRow;




/* init root model class */
-(id) init;


/* Perform open database */
-(void) openDatabase;


/* Close database */
-(void) closeDatabase;


#pragma mark - Saving Your Data


/* create a new row */
-(BOOL) create:(id) data;


/* save a field  */
/* before using. set entiry.id = ? */
-(BOOL) saveField:(NSString *) fieldName value:(id) fieldValue;


/** update all field */
-(BOOL) updateAll:(id) data;



#pragma mark - Retrieving Your Data


/* find data from entity */
/* type will be: max, first, count, all */
-(NSMutableArray *) find:(NSString *) type andCondition:(NSArray *) condition andOrderBy:(NSArray *) fieldsOrder limitRow:(NSInteger) limit;


#pragma  mark - Deleting Data

/* delete by id*/
-(BOOL) deleteById:(NSInteger) idDelete;


/* delete all data with conditiosn and callback is return id has deleted */
-(void) deleteAll:(NSArray *) conditions;


#pragma mark - Additional Methods and Properties


/* Returns true if a record with the particular ID exists. */
-(BOOL)exists:(NSInteger) idEntity;


/* Returns the column type of a column in the model. */
-(NSString *) getColumnType;


/* Returns the current record’s ID. */
-(id) getId:(NSInteger) idEntity;


/* Returns the ID of the last record this model inserted. */
-(NSInteger) getInsertID;


/** Tim charact '*/
-(NSString *) escapeSingleQuote:(NSString *) str;



@end
