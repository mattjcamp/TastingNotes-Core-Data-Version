//
//  SQLiteUpgrade.m
//  TastingNotes
//
//  Created by Matt on 1/6/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Dump.h"
#import "AppContent+ContentUtilities.h"
#import "SQLiteUpdater.h"

@interface SQLiteUpgrade : XCTestCase

@property AppContent *ac;
@property NSMutableString *log;

@end

@implementation SQLiteUpgrade

-(void)setUp{
    [super setUp];
    self.ac = [AppContent sharedContent];
    self.log = [[NSMutableString alloc] init];
}

-(void)tearDown{
    [super tearDown];
    if([self.log length] > 0)
        [self.log writeToFile:@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/SQLiteUpgrade-log.txt"
                   atomically:NO
                     encoding:NSStringEncodingConversionAllowLossy
                        error:nil];
}

-(void)testSQLiteTemplateImport{
    
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookTemplate:obj
                           intoThisLog:self.log];
    }];
}

-(void)testSQLiteContentImport{
    
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookContent:obj
                          intoThisLog:self.log];
    }];
}

-(void)testSQLiteImportAndSaveToText{
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookTemplate:obj
                          intoThisLog:self.log];
    }];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookContent:obj
                          intoThisLog:self.log];
    }];
    
}

-(void)testCoreData{
    NSArray *n1 = [self.ac notebooks];
    [n1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookContent:obj
                          intoThisLog:self.log];
    }];
    
}

@end
