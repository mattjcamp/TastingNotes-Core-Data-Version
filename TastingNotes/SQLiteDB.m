//
//  SQLiteDB.m
//  TastingNotes
//
//  Created by Matthew Campbell on 2/2/11.
//  Copyright 2011 App Shop LLC. All rights reserved.
//

#import "SQLiteDB.h"

@implementation SQLiteDB

//#define DatabaseFileName @"paddb.sql"
#define DatabaseFileName @"tasting-notes-database-paddb.sql"
#define SQLITE_INTEGER  1
#define SQLITE_FLOAT    2
#define SQLITE_TEXT     3
#define SQLITE_BLOB     4
#define SQLITE_NULL     5

sqlite3 *sqlite;
NSString *databaseFolderName;
NSString *writableDatabaseFullFileName;

#pragma mark Database initialization and setup

#warning This will have to change to not copy the database from the bundle

-(void) copyDatabaseIfAbsent{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDatabaseAlreadyPresent;
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *userDirectory = [[paths objectAtIndex:0] stringByAppendingFormat:@"/User/"];
	BOOL directoryExists = [fileManager fileExistsAtPath:userDirectory];
	NSError *err;
	if(directoryExists == NO)
		[fileManager createDirectoryAtPath:userDirectory
			   withIntermediateDirectories:NO
								attributes:nil error:&err];
    
	NSString *dbFilename = [NSString stringWithFormat:@"/%@", DatabaseFileName];
    writableDatabaseFullFileName = [userDirectory stringByAppendingString:dbFilename];
	
    isDatabaseAlreadyPresent = [fileManager fileExistsAtPath:writableDatabaseFullFileName];
	
    if (isDatabaseAlreadyPresent)
		return;
    
	NSString *databaseInBundleFileName = [NSString stringWithFormat:@"%@%@", 
										  [[NSBundle mainBundle] resourcePath],
										  dbFilename];
	NSError *error;
    BOOL databaseCopiedSuccessfully = [fileManager copyItemAtPath:databaseInBundleFileName 
														   toPath:writableDatabaseFullFileName 
															error:&error];
    if (!databaseCopiedSuccessfully)
        NSAssert1(0, @"Error: Database did not get copied: '%@'.", 
				  [error localizedDescription]);
}

-(void)initializeDatabase{
    if (sqlite3_open([writableDatabaseFullFileName UTF8String], &sqlite) != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSAssert1(0, @"Error: Database did not open: '%s'.", 
				  sqlite3_errmsg(sqlite));
    }
}

#pragma mark DataRetrieval

//Returns autoreleased NSString, NSNumber, NSNull or NSData depending on what is in the database
-(id)getValue:(sqlite3_stmt *) statement columnPosition:(int)index{
	int dataType = sqlite3_column_type(statement, index);
	switch (dataType) {
		case SQLITE_FLOAT:{
			double d = sqlite3_column_double(statement, index);
			NSNumber *num = [[NSNumber alloc] initWithDouble:d];
			return num;
		}
		case SQLITE_INTEGER:{
			int n = sqlite3_column_int(statement, index);
			NSNumber *num = [[NSNumber alloc] initWithInt:n];
			return num;
		}
		case SQLITE_TEXT:{
			NSString *text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, index)];
			return text;
		}
		case SQLITE_NULL:{
			return [NSNull null];
		}
		case SQLITE_BLOB:{
			NSData *data = [[NSData alloc] initWithBytes:
							sqlite3_column_blob(statement, index) 
												  length:sqlite3_column_bytes(statement, index)];
			
			return data;
		}
		default:{
			NSAssert(0, @"New SQLite Data Type That We Don't Know About?");
			return nil;
		}
	}
}

//Returns autoreleased NSString, NSNumber, NSNull or NSData based on the sql statement
//Throws an error if you specify more than one value to be returned in the SQLstatement
-(id) getValueFromThisTable:(NSString *)tableName 
   usingThisSelectStatement:(NSString *)sql{
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
		if (sqlite3_step(statement) == SQLITE_ROW) {
			int numCol = sqlite3_column_count(statement);
			if(numCol == 1){
				id value = [self getValue:statement columnPosition:0];
				sqlite3_finalize(statement);
				return value;
			}
			else{
				sqlite3_finalize(statement);
				NSAssert(0, @"Error: sql statement specified more than one value to be returned.");
				return nil;
			}
		}
		else{
			//returns nil when no rows correspond to sql statement.
			sqlite3_finalize(statement);
			return nil;	
		}
	}
	else{
		sqlite3_finalize(statement);
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
		return nil;
	}
}

//Gets all the values in the specified column
//[NSNull null] is used as a placeholder when values are not found
-(NSArray *) getColumnValuesFromThisTable:(NSString *)tableName 
				 usingThisSelectStatement:(NSString *)sql 
						   fromThisColumn:(int)columnIndex{
	NSMutableArray *columnlist = [[NSMutableArray alloc] init];		
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
		while (sqlite3_step(statement) == SQLITE_ROW)
			[columnlist addObject:[self getValue:statement columnPosition:columnIndex]];
	}
	else{
		sqlite3_finalize(statement);
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
	}
	sqlite3_finalize(statement);
	
	return columnlist;
}

//Gets all the values in the specified row
//[NSNull null] is used as a placeholder when values are not found
-(NSArray *) getRowValuesFromThisTable:(NSString *)tableName 
			  usingThisSelectStatement:(NSString *)sql{
	NSMutableArray *rowlist = [[NSMutableArray alloc] init];		
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
		if (sqlite3_step(statement) == SQLITE_ROW) {
			int numCol = sqlite3_column_count(statement);
			for(int i = 0;i<numCol;i++)
				[rowlist addObject:[self getValue:statement columnPosition:i]];
		}
	}
	else{
		sqlite3_finalize(statement);
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
	}
	sqlite3_finalize(statement);
    
	return rowlist;
}

//Executes the SQL statement
-(void) executeThisSQLStatement:(NSString *)sql{
	const char *SQL = [sql UTF8String];	
	sqlite3_stmt *statement;  
	if (sqlite3_prepare_v2(sqlite, SQL, -1, &statement, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
	int success = sqlite3_step(statement);
	if (success != SQLITE_DONE)
		NSAssert1(0, @"Error: SQL did not execute: '%s'.", 
				  sqlite3_errmsg(sqlite));
	sqlite3_finalize(statement);
}

//Adds a new row to a table and returns the primary key
-(NSNumber *) addRowToThisTable:(NSString *)tableName 
			 withThisColumnName:(NSString *)columnName 
				  withThisValue:(NSString *)valueName{
	NSString *v = [valueName stringByReplacingOccurrencesOfString: @"'" withString:@"''"];
	sqlite3_stmt *statement;
	NSInteger pk = -1;
	NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES('%@');",
					  tableName,columnName,v];
	const char *sql = [sql1 UTF8String];
    if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK) 
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
	int success = sqlite3_step(statement);
	if (success == SQLITE_ERROR)
		NSAssert1(0, @"Error: row did not get added: '%s'.", 
				  sqlite3_errmsg(sqlite));
	else
		pk = (int)sqlite3_last_insert_rowid(sqlite);
	sqlite3_finalize(statement);
	NSNumber *pk_return = [[NSNumber alloc] initWithInt:pk];
	
	return pk_return;
}

//Updates a number in the database
-(void) updateNumberInThisTable:(NSString *)tableName 
				   inThisColumn:(NSString *)columnName 
				  withThisValue:(NSNumber *)valueName 
		usingThisWhereStatement:(NSString *)whereStatement{
	NSString *v = [valueName stringValue];
	NSString *sql1 = [NSString stringWithFormat: @"UPDATE %@ SET %@ = '%@' %@;", 
					  tableName, columnName, v, whereStatement];
	const char *sql = [sql1 UTF8String];	
	sqlite3_stmt *statement;  
	if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.",
				  sqlite3_errmsg(sqlite));
	int success = sqlite3_step(statement);
	if (success != SQLITE_DONE)
		NSAssert1(0, @"Error: value did not get updated: '%s'.", 
				  sqlite3_errmsg(sqlite));
	sqlite3_finalize(statement);
}

//Updates a string in the database
-(void) updateStringInThisTable:(NSString *)tableName 
				   inThisColumn:(NSString *)columnName 
				  withThisValue:(NSString *)valueName 
		usingThisWhereStatement:(NSString *)whereStatement{
	NSString *v = [valueName stringByReplacingOccurrencesOfString: @"'" withString:@"''"];
	NSString *sql1 = [NSString stringWithFormat: @"UPDATE %@ SET %@ = '%@' %@;", 
					  tableName, columnName, v, whereStatement];
	const char *sql = [sql1 UTF8String];	
	sqlite3_stmt *statement;  
	if (sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.",
				  sqlite3_errmsg(sqlite));
	int success = sqlite3_step(statement);
	if (success != SQLITE_DONE)
		NSAssert1(0, @"Error: value did not get updated: '%s'.", 
				  sqlite3_errmsg(sqlite));
	sqlite3_finalize(statement);
}

//Updates binary data (BLOB) in the database
-(void) updateDataInThisTable:(NSString *)tableName 
				 inThisColumn:(NSString *)columnName 
				withThisValue:(NSData *)data 
	  usingThisWhereStatement:(NSString *)whereStatement{
	NSString *sql1 = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ? %@;", 
					  tableName, columnName, whereStatement];
	const char *sql = [sql1 UTF8String];	
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(sqlite));
	
	if (sqlite3_bind_blob(statement, 1, [data bytes], [data length], NULL) != SQLITE_OK)
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.",
				  sqlite3_errmsg(sqlite));
	int success = sqlite3_step(statement);
	if (success != SQLITE_DONE)
		NSAssert1(0, @"Error: value did not get updated: '%s'.", 
				  sqlite3_errmsg(sqlite));
	sqlite3_finalize(statement);
}

#pragma mark Database Meta Data
//Returns a list of the tables in the database
-(NSArray *)getListOfTableNamesInDatabase{
	return [self getColumnValuesFromThisTable:@"master_sqlite" 
					 usingThisSelectStatement:@"SELECT tbl_name as N FROM sqlite_master" 
							   fromThisColumn:0];
}

//[Returns list of SQLiteColumnMetaData objects]
-(NSArray *)getColumnMetaDataFromThisTable:(NSString *)tableName{
	NSMutableArray *columnInfoList = [[NSMutableArray alloc] init];		
	sqlite3_stmt *statement;
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@;", tableName];
	if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
		if (sqlite3_step(statement) == SQLITE_ROW) {
			int numCol = sqlite3_column_count(statement);
			for(int i = 0;i<numCol;i++){
				SQLiteColumnMetaData *metaData = [[SQLiteColumnMetaData alloc] init];
				metaData.columnPosition = i;
				metaData.sqliteType = sqlite3_column_type(statement, i);
				NSString *text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(statement, i)];
				metaData.columnName = text;
				[columnInfoList addObject:metaData];
			}
		}
	}
	else{
		sqlite3_finalize(statement);
		NSAssert1(0, @"Error: sqlite statement did not get prepared: '%s'.", 
				  sqlite3_errmsg(sqlite));
	}
	sqlite3_finalize(statement);
	
	return columnInfoList;
}

#pragma mark Singleton Methods

static SQLiteDB *sharedObject = nil;

+(id)sharedDatabase {
    @synchronized(self) {
        if(sharedObject == nil)
            sharedObject = [[super allocWithZone:NULL] init];
    }
    return sharedObject;
}

-(id)init {
    if ((self = [super init])) {
		[self copyDatabaseIfAbsent];
		[self initializeDatabase];
    }
    
    return self;
}

-(void)dealloc{
    [self restartDatabase];
}

-(void)restartDatabase{
   	if (sqlite3_close(sqlite) != SQLITE_OK)
        NSAssert1(0, @"Error: Database did not close: '%s'.", 
				  sqlite3_errmsg(sqlite)); 
}

@end
