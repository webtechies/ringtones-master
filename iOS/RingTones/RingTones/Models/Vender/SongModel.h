//
//  SongModel.h
//  RingTones
//
//  Created by VinhTran on 12/22/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"
#import "SongField.h"

@interface SongModel : AppModel

/** Get all rows in Table Songs **/
-(NSMutableArray *) getAllRowsInSongTable;
-(NSMutableArray *) getAllRingTonesInSongTable;
-(NSMutableArray *) getDownloadeRingtonesInSongTable;
-(NSMutableArray *) getMyRingtonesInSongTable;



/** Get rows by rowid in Table Songs **/
-(SongField *) getRowByRowsInSongTableByRowId:(NSString *) rowid;


/** create a new row **/
-(BOOL)createRowInSongTable:(SongField *) data;


/** update row **/
-(BOOL)updateRowInSongTable:(SongField *) data;


/** delete row **/
-(BOOL)deleteRowByRowId:(NSString *) rowid;


@end
