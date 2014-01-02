

////SearchHistoryField.m 
//  Project 
// 
//  Created by TeamiOS on 2013-12-21 17:27:59 +0000. 
//

//--CREATE TABLE "SearchHistory" ("searchKey" TEXT, "other1" TEXT, "other2" TEXT, "other3" TEXT, )

#import "SearchHistoryModel.h"

@implementation SearchHistoryModel

/** init class */
-(id) init
{
	self = [super init];

	if (self)
	{
		self.usesTable = @"SearchHistory";
	}
	return self;
}


/* free memory */
-(void) dealloc
{
	[super dealloc];
}



/********************************************************************************/
#pragma mark  - Insert Row To Table

-(BOOL)createRowInTableSearchHistory:(SearchHistoryField *) data
{
	NSString *searchKey = data.searchKey;
	NSString *other1 = data.other1;
	NSString *other2 = data.other2;
	NSString *other3 = data.other3;

	NSString *searchKeyInit = @"";
	NSString *other1Init = @"";
	NSString *other2Init = @"";
	NSString *other3Init = @"";


	if (searchKey)
		searchKeyInit = searchKey;

	if (other1)
		other1Init = other1;

	if (other2)
		other2Init = other2;

	if (other3)
		other3Init = other3;

	sqlite3_stmt *createStmt = nil;

	if (createStmt == nil)
	{
		//--string sql
		const char *sql = "INSERT INTO \"SearchHistory\" (\"searchKey\",\"other1\",\"other2\",\"other3\") VALUES (?1,?2,?3,?4)";

		if(sqlite3_prepare_v2(self.db, sql, -1, &createStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(self.db));
	}

 	//--searchKey
	sqlite3_bind_text(createStmt, 1, [searchKeyInit UTF8String], -1, SQLITE_TRANSIENT);

 	//--other1
	sqlite3_bind_text(createStmt, 2, [other1Init UTF8String], -1, SQLITE_TRANSIENT);

 	//--other2
	sqlite3_bind_text(createStmt, 3, [other2Init UTF8String], -1, SQLITE_TRANSIENT);

 	//--other3
	sqlite3_bind_text(createStmt, 4, [other3Init UTF8String], -1, SQLITE_TRANSIENT);



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

/********************************************************************************/


/********************************************************************************/
#pragma mark  - Update Row To Table

-(BOOL)updateRowInTableSearchHistory:(SearchHistoryField *) data
{

	NSString *searchKey = data.searchKey;
	NSString *other1 = data.other1;
	NSString *other2 = data.other2;
	NSString *other3 = data.other3;

	NSString *searchKeyInit = @"";
	NSString *other1Init = @"";
	NSString *other2Init = @"";
	NSString *other3Init = @"";


	if (searchKey)
		searchKeyInit = searchKey;

	if (other1)
		other1Init = other1;

	if (other2)
		other2Init = other2;

	if (other3)
		other3Init = other3;

	sqlite3_stmt *createStmt = nil;

	if (createStmt == nil)
	{
		//--string sql
		NSString *sqlOriginal = [NSString stringWithFormat:@"UPDATE \"SearchHistory\" SET \"searchKey\" = ?, \"other1\" = ?, \"other2\" = ?, \"other3\" = ? WHERE rowid = %@", data.rowid];

		const char *sql = sqlOriginal.UTF8String;

		if(sqlite3_prepare_v2(self.db, sql, -1, &createStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(self.db));
	}

 	//--searchKey
	sqlite3_bind_text(createStmt, 1, [searchKeyInit UTF8String], -1, SQLITE_TRANSIENT);

 	//--other1
	sqlite3_bind_text(createStmt, 2, [other1Init UTF8String], -1, SQLITE_TRANSIENT);

 	//--other2
	sqlite3_bind_text(createStmt, 3, [other2Init UTF8String], -1, SQLITE_TRANSIENT);

 	//--other3
	sqlite3_bind_text(createStmt, 4, [other3Init UTF8String], -1, SQLITE_TRANSIENT);



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

/********************************************************************************/


/********************************************************************************/
#pragma mark  - Delete Row To Table

-(BOOL)deleteRowByRowId:(NSString *) rowid
{
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

/********************************************************************************/


/********************************************************************************/
#pragma mark  - Select All Row In Table

-(NSMutableArray *) getAllRowsInTableSearchHistory
{
	//--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ ", self.usesTable];

	return [self getArrayDataBy_SQL:qsql];
}


-(NSMutableArray *) getTop5RowsInTableSearchHistory
{
	//--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ LIMIT 5 ", self.usesTable];
    
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

			//--searchKey
			char *searchKey = (char *) sqlite3_column_text(statement, 1);
			NSString *searchKeyStr = (searchKey == NULL) ? @"":[NSString stringWithUTF8String:searchKey];

			//--other1
			char *other1 = (char *) sqlite3_column_text(statement, 2);
			NSString *other1Str = (other1 == NULL) ? @"":[NSString stringWithUTF8String:other1];

			//--other2
			char *other2 = (char *) sqlite3_column_text(statement, 3);
			NSString *other2Str = (other2 == NULL) ? @"":[NSString stringWithUTF8String:other2];

			//--other3
			char *other3 = (char *) sqlite3_column_text(statement, 4);
			NSString *other3Str = (other3 == NULL) ? @"":[NSString stringWithUTF8String:other3];



			//--add Object
			SearchHistoryField *object = [[SearchHistoryField alloc]init];

			object.rowid = rowidStr;
			object.searchKey = searchKeyStr;
			object.other1 = other1Str;
			object.other2 = other2Str;
			object.other3 = other3Str;
			
			[array addObject:object];

			//--free memory
			[object release];

		}
	}

	if (statement)
	{
		sqlite3_reset(statement);
		sqlite3_finalize(statement);
	}

	return array;
}



/********************************************************************************/


/********************************************************************************/
#pragma mark  - Select Row By rowid In Table

-(SearchHistoryField *) getRowByRowsInTableSearchHistoryByRowId:(NSString *) rowid
{
	//--retrive rows
	NSString *qsql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE rowid = \"%@\" ", self.usesTable,rowid];

	return [self getData_SearchHistoryField_BySQL:qsql];
}



//--Retrieving Data
-(SearchHistoryField *) getData_SearchHistoryField_BySQL:(NSString *) qsql
{
	sqlite3_stmt *statement;
	SearchHistoryField *object = nil;

	if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statement, nil) == SQLITE_OK)
	{
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			//--rowid
			char *rowid = (char *) sqlite3_column_text(statement, 0);
			NSString *rowidStr  = [NSString stringWithUTF8String:rowid];

			//--searchKey
			char *searchKey = (char *) sqlite3_column_text(statement, 1);
			NSString *searchKeyStr = (searchKey == NULL) ? @"":[NSString stringWithUTF8String:searchKey];

			//--other1
			char *other1 = (char *) sqlite3_column_text(statement, 2);
			NSString *other1Str = (other1 == NULL) ? @"":[NSString stringWithUTF8String:other1];

			//--other2
			char *other2 = (char *) sqlite3_column_text(statement, 3);
			NSString *other2Str = (other2 == NULL) ? @"":[NSString stringWithUTF8String:other2];

			//--other3
			char *other3 = (char *) sqlite3_column_text(statement, 4);
			NSString *other3Str = (other3 == NULL) ? @"":[NSString stringWithUTF8String:other3];



			//--add Object
			object = [[[SearchHistoryField alloc] init] autorelease];

			object.rowid = rowidStr;
			object.searchKey = searchKeyStr;
			object.other1 = other1Str;
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



/********************************************************************************/
@end