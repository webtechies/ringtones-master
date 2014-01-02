

////SearchHistoryModel.h 
//  Project 
// 
//  Created by TeamiOS on 2013-12-21 17:27:59 +0000. 
//
// 

#import <Foundation/Foundation.h>
#import "AppModel.h"
#import "SearchHistoryField.h"

@interface SearchHistoryModel : AppModel
{

}


/** Get all rows in Table SearchHistory **/
-(NSMutableArray *) getAllRowsInTableSearchHistory;

-(NSMutableArray *) getTop5RowsInTableSearchHistory;

/** Get rows by rowid in Table SearchHistory **/
-(SearchHistoryField *) getRowByRowsInTableSearchHistoryByRowId:(NSString *) rowid;


/** create a new row **/
-(BOOL)createRowInTableSearchHistory:(SearchHistoryField *) data;

/** update row **/
-(BOOL)updateRowInTableSearchHistory:(SearchHistoryField *) data;

/** delete row **/
-(BOOL)deleteRowByRowId:(NSString *) rowid;

@end