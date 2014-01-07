//
//  SQLiteExporter.m
//  TastingNotes
//
//  Created by Matt on 1/6/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "SQLiteUpdater.h"

//Helper Categories
@interface Notebook (Notebook_Importer_Helper)

@property (strong) NSNumber *pk;

@end

@implementation Notebook (Notebook_Importer_Helper)

NSNumber *_pk;
-(NSNumber *)pk {
    return _pk;
}

-(void)setPk:(NSNumber *)value{
    _pk = value;
}

@end

@interface SQLiteUpdater()

@property AppContent *ac;
@property SQLiteDB *db;

-(void)importNotebookWithThisPrimaryKey:(NSNumber *)pk;

@end

@implementation SQLiteUpdater

-(id)init{
    self = [super init];
    if (self) {
        self.ac = [AppContent sharedContent];
        self.db = [SQLiteDB sharedDatabase];
    }
    return self;
}

-(void)importSQLtoCoreData{

    NSArray *notebookPK = [self.db getColumnValuesFromThisTable:@""
                                          usingThisSelectStatement:@"SELECT pk FROM ListsTable ORDER BY ListOrder"
                                                    fromThisColumn:0];
    
    [notebookPK enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self importNotebookWithThisPrimaryKey:obj];
    }];
    
    [self.ac save];
}

-(void)importNotebookWithThisPrimaryKey:(NSNumber *)pk{
    NSArray *notebookData = [self.db getRowValuesFromThisTable:@"ListsTable"
                                      usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM ListsTable WHERE pk = %@", pk]];
    
    [self.ac addNewNotebookWithThisName:[notebookData objectAtIndex:1]];
    Notebook *n = [[self.ac notebooks]lastObject];
    Notebook_Template *nt = [self.ac addNewNotebookTemplateToThisNotebook:n];
}

@end