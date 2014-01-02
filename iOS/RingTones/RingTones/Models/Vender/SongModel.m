//
//  SongModel.m
//  RingTones
//
//  Created by VinhTran on 12/22/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel

/** init class */
-(id) init
{
	self = [super init];
    
	if (self)
	{
		self.usesTable = @"Song";
	}
	return self;
}

/** Get all rows in Table SearchHistory **/
-(NSMutableArray *) getAllRowsInSongTable{
    //--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ where type = '0' ", self.usesTable];
    
	return [self getArrayDataBy_SQL:qsql];
}

-(NSMutableArray *) getAllRingTonesInSongTable{
    //--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ where type = '1' ", self.usesTable];
    
	return [self getArrayDataBy_SQL:qsql];

}



-(NSMutableArray *) getDownloadeRingtonesInSongTable
{
    NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE type = \"0\" ", self.usesTable];
    
	return [self getArrayDataBy_SQL:qsql];
}



-(NSMutableArray *) getMyRingtonesInSongTable
{
    NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE type = \"1\" ", self.usesTable];
    
	return [self getArrayDataBy_SQL:qsql];
}


//--Retrieving Array Data
-(NSMutableArray *) getArrayDataBy_SQL:(NSString *)qsql
{
	NSMutableArray *array = [NSMutableArray array];
    
	sqlite3_stmt *statement;
    
	if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
	{
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			//--rowid
			char *rowid = (char *) sqlite3_column_text(statement, 0);
			NSString *rowidStr  = [NSString stringWithUTF8String:rowid];
            
			//--name
			char *name = (char *) sqlite3_column_text(statement, 1);
			NSString *nameStr = (name == NULL) ? @"":[NSString stringWithUTF8String:name];
            
            //--date
			char *date = (char *) sqlite3_column_text(statement, 2);
			NSString *dateStr = (date == NULL) ? @"":[NSString stringWithUTF8String:date];
            
			//--duration
			char *duration = (char *) sqlite3_column_text(statement, 3);
			NSString *durationStr = (duration == NULL) ? @"":[NSString stringWithUTF8String:duration];
            
			//--path
			char *path = (char *) sqlite3_column_text(statement, 4);
			NSString *pathStr = (path == NULL) ? @"":[NSString stringWithUTF8String:path];
            
			//--type
			char *type = (char *) sqlite3_column_text(statement, 5);
			NSString *typeStr = (type == NULL) ? @"":[NSString stringWithUTF8String:type];
            
			//--other1
			char *url = (char *) sqlite3_column_text(statement, 6);
			NSString *urlStr = (url == NULL) ? @"":[NSString stringWithUTF8String:url];
            
			//--other2
			char *other2 = (char *) sqlite3_column_text(statement, 7);
			NSString *other2Str = (other2 == NULL) ? @"":[NSString stringWithUTF8String:other2];
            
			//--other3
			char *other3 = (char *) sqlite3_column_text(statement, 8);
			NSString *other3Str = (other3 == NULL) ? @"":[NSString stringWithUTF8String:other3];
            
            
            
			//--add Object
			SongField *object = [[SongField alloc]init];
            
			object.rowid = rowidStr;
			object.name = nameStr;
            object.date = dateStr;
            object.duration = durationStr;
            object.path = pathStr;
            object.type = typeStr;
			object.url = urlStr;
			object.other2 = other2Str;
			object.other3 = other3Str;
			
			[array addObject:object];
        
            
		}
	}
    
	if (statement)
	{
		sqlite3_reset(statement);
		sqlite3_finalize(statement);
	}
    
	return array;
}




/** Get rows by rowid in Table SearchHistory **/
-(SongField *) getRowByRowsInSongTableByRowId:(NSString *) rowid{
    //--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE rowid = \"%@\" ", self.usesTable,rowid];
    
	return [self getData_SongField_BySQL:qsql];
}



//--Retrieving Data
-(SongField *) getData_SongField_BySQL:(NSString *) qsql
{
	sqlite3_stmt *statement;
	SongField *object = nil;
    
	if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
	{
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			//--rowid
			char *rowid = (char *) sqlite3_column_text(statement, 0);
			NSString *rowidStr  = [NSString stringWithUTF8String:rowid];
            
			//--name
			char *name = (char *) sqlite3_column_text(statement, 1);
			NSString *nameStr = (name == NULL) ? @"":[NSString stringWithUTF8String:name];
            
            //--date
			char *date = (char *) sqlite3_column_text(statement, 2);
			NSString *dateStr = (date == NULL) ? @"":[NSString stringWithUTF8String:date];
            
			//--duration
			char *duration = (char *) sqlite3_column_text(statement, 3);
			NSString *durationStr = (duration == NULL) ? @"":[NSString stringWithUTF8String:duration];
            
			//--path
			char *path = (char *) sqlite3_column_text(statement, 4);
			NSString *pathStr = (path == NULL) ? @"":[NSString stringWithUTF8String:path];
            
			//--type
			char *type = (char *) sqlite3_column_text(statement, 5);
			NSString *typeStr = (type == NULL) ? @"":[NSString stringWithUTF8String:type];
            
			//--other1
			char *url = (char *) sqlite3_column_text(statement, 6);
			NSString *urlStr = (url == NULL) ? @"":[NSString stringWithUTF8String:url];
            
			//--other2
			char *other2 = (char *) sqlite3_column_text(statement, 7);
			NSString *other2Str = (other2 == NULL) ? @"":[NSString stringWithUTF8String:other2];
            
			//--other3
			char *other3 = (char *) sqlite3_column_text(statement, 8);
			NSString *other3Str = (other3 == NULL) ? @"":[NSString stringWithUTF8String:other3];
			
            
			//--add Object
            object = [[SongField alloc]init];
            
			object.rowid = rowidStr;
			object.name = nameStr;
            object.date = dateStr;
            object.duration = durationStr;
            object.path = pathStr;
            object.type = typeStr;
			object.url = urlStr;
			object.other2 = other2Str;
			object.other3 = other3Str;
		}
	}
    
	if (statement)
	{
		sqlite3_reset(statement);
		sqlite3_finalize(statement);
	}
    
	return object;
}

/** create a new row **/
-(BOOL)createRowInSongTable:(SongField *) data{
    NSString *name = data.name;
    NSString *date = data.date;
    NSString *duration = data.duration;
    NSString *path = data.path;
    NSString *type = data.type;
	NSString *url = data.url;
	NSString *other2 = data.other2;
	NSString *other3 = data.other3;
    
	NSString *nameInit = @"";
    NSString *dateInit = @"";
    NSString *durationInit = @"";
    NSString *pathInit = @"";
    NSString *typeInit = @"0";
	NSString *urlInit = @"";
	NSString *other2Init = @"";
	NSString *other3Init = @"";
    
    
	if (name)
		nameInit = name;
    
    if (date)
		dateInit = date;
    
    if (duration)
		durationInit = duration;
    
    if (path)
		pathInit = path;
    
    if (type)
		typeInit = type;
    
	if (url)
		urlInit = url;
    
	if (other2)
		other2Init = other2;
    
	if (other3)
		other3Init = other3;
    
	sqlite3_stmt *createStmt = nil;
    
	if (createStmt == nil)
	{
		//--string sql
		const char *sql = "INSERT INTO \"Song\" (\"name\",\"date\",\"duration\",\"path\",\"type\",\"url\",\"other2\",\"other3\") VALUES (?1,?2,?3,?4,?5,?6,?7,?8)";
        
		if(sqlite3_prepare_v2(self.db, sql, -1, &createStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(self.db));
	}
    
 	//--searchKey
	sqlite3_bind_text(createStmt, 1, [nameInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--date
	sqlite3_bind_text(createStmt, 2, [dateInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--duration
	sqlite3_bind_text(createStmt, 3, [durationInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--path
	sqlite3_bind_text(createStmt, 4, [pathInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--type
	sqlite3_bind_text(createStmt, 5, [typeInit UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other1
	sqlite3_bind_text(createStmt, 6, [urlInit UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other2
	sqlite3_bind_text(createStmt, 7, [other2Init UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other3
	sqlite3_bind_text(createStmt, 8, [other3Init UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
	if(SQLITE_DONE != sqlite3_step(createStmt))
	{
		//NSLog(@"Error code: %d", sqlite3_step(createStmt));
		sqlite3_close(db);
		NSAssert1(0, @"Error while inserting data. '%d'", sqlite3_step(createStmt));
		return NO;
	}
    
	//--NSLog(@"id isnert: %llu", sqlite3_last_insert_rowid(db));
	sqlite3_finalize(createStmt);
    
	return YES;

}


/** update row **/
-(BOOL)updateRowInSongTable:(SongField *) data{
    NSString *name = data.name;
    NSString *date = data.date;
    NSString *duration = data.duration;
    NSString *path = data.path;
    NSString *type = data.type;
	NSString *url = data.url;
	NSString *other2 = data.other2;
	NSString *other3 = data.other3;
    
	NSString *nameInit = @"";
    NSString *dateInit = @"";
    NSString *durationInit = @"";
    NSString *pathInit = @"";
    NSString *typeInit = @"0";
	NSString *urlInit = @"";
	NSString *other2Init = @"";
	NSString *other3Init = @"";
    
    
	if (name)
		nameInit = name;
    
    if (date)
		dateInit = date;
    
    if (duration)
		durationInit = duration;
    
    if (path)
		pathInit = path;
    
    if (type)
		typeInit = type;
    
	if (url)
		urlInit = url;
    
	if (other2)
		other2Init = other2;
    
	if (other3)
		other3Init = other3;
    
    sqlite3_stmt *createStmt = nil;
    
	if (createStmt == nil)
	{
		//--string sql
		NSString *sqlOriginal = [NSString stringWithFormat:@"UPDATE \"Song\" SET \"name\" = ?,\"date\" = ?,\"duration\" = ?,\"path\" = ?,\"type\" = ?, \"url\" = ?, \"other2\" = ?, \"other3\" = ? WHERE rowid = %@", data.rowid];
        
		const char *sql = sqlOriginal.UTF8String;
        
		if(sqlite3_prepare_v2(self.db, sql, -1, &createStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(self.db));
	}
    
    
    //--searchKey
	sqlite3_bind_text(createStmt, 1, [nameInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--date
	sqlite3_bind_text(createStmt, 2, [dateInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--duration
	sqlite3_bind_text(createStmt, 3, [durationInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--path
	sqlite3_bind_text(createStmt, 4, [pathInit UTF8String], -1, SQLITE_TRANSIENT);
    
    //--type
	sqlite3_bind_text(createStmt, 5, [typeInit UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other1
	sqlite3_bind_text(createStmt, 6, [urlInit UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other2
	sqlite3_bind_text(createStmt, 7, [other2Init UTF8String], -1, SQLITE_TRANSIENT);
    
 	//--other3
	sqlite3_bind_text(createStmt, 8, [other3Init UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
	if(SQLITE_DONE != sqlite3_step(createStmt))
	{
		//NSLog(@"Error code: %d", sqlite3_step(createStmt));
		sqlite3_close(db);
		NSAssert1(0, @"Error while inserting data. '%d'", sqlite3_step(createStmt));
		return NO;
	}
    
	//--NSLog(@"id isnert: %llu", sqlite3_last_insert_rowid(db));
	sqlite3_finalize(createStmt);
    
	return YES;

}


/** delete row **/
-(BOOL)deleteRowByRowId:(NSString *) rowid{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE rowid = %@", self.usesTable, rowid];
	//--NSLog(@"sql: %@", sql);
    
	char *err;
	if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
		NSLog(@"reture code: %d",sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err));
        
		sqlite3_close(db);
		NSAssert(0, @"Error insert table ZCARDGAME.");
        
	}
    
	return YES;
}


@end
