//
//  SQLiteDB.h
//  TastingNotes
//
//  Created by Matthew Campbell on 2/2/11.
//  Copyright 2011 App Shop LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteColumnMetaData.h"
#import <sqlite3.h>
  
@interface SQLiteDB : NSObject

+(id) sharedDatabase;

-(void) copyDatabaseIfAbsent;
-(void) initializeDatabase;

-(id) getValueFromThisTable:(NSString *)tableName 
   usingThisSelectStatement:(NSString *)sql;
-(NSArray *) getColumnValuesFromThisTable: (NSString *)tableName 
				 usingThisSelectStatement:(NSString *)sql 
						   fromThisColumn:(int)columnIndex;
-(NSArray *) getRowValuesFromThisTable:(NSString *)tableName 
			  usingThisSelectStatement:(NSString *)sql;
-(void) executeThisSQLStatement:(NSString *)sql;
-(NSNumber *) addRowToThisTable:(NSString *)tableName 
			 withThisColumnName:(NSString *)columnName 
				  withThisValue:(NSString *)valueName;
-(void) updateNumberInThisTable:(NSString *)tableName 
				   inThisColumn:(NSString *)columnName 
				  withThisValue:(NSNumber *)valueName 
		usingThisWhereStatement:(NSString *)whereStatement;
-(void) updateStringInThisTable:(NSString *)tableName 
				   inThisColumn:(NSString *)columnName 
				  withThisValue:(NSString *)valueName 
		usingThisWhereStatement:(NSString *)whereStatement;
-(void) updateDataInThisTable:(NSString *)tableName 
				 inThisColumn:(NSString *)columnName 
				withThisValue:(NSData *)data 
	  usingThisWhereStatement:(NSString *)whereStatement;

-(NSArray *) getListOfTableNamesInDatabase;
-(NSArray *) getColumnMetaDataFromThisTable:(NSString *)tableName;
-(void)restartDatabase;

@end
