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
#import "SQLiteUpdater.h"

#define REF_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/WineDatabaseOutput.txt")
#define OUTPUT_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/DataOutput.txt")
#define LOG_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/SQLiteUpgrade_log.txt")

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
        [self.log writeToFile:LOG_FILE
                   atomically:NO
                     encoding:NSStringEncodingConversionAllowLossy
                        error:nil];
}

#warning TODO: Use attributed objects for notebook and contenttype categories

-(void)testNewImport{
    
    [self.ac removeAllContent];
    
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    
    [self outputNotebooks];

    NSString *refFile = [NSString stringWithContentsOfFile:REF_FILE
                                                  encoding:NSStringEncodingConversionAllowLossy
                                                     error:nil];
    
    NSString *outFile = [NSString stringWithContentsOfFile:OUTPUT_FILE
                                                  encoding:NSStringEncodingConversionAllowLossy
                                                     error:nil];
    if([refFile isEqualToString:outFile]){
        [self.log appendString:@"Both files match"];
    }
    else{
        [self.log appendString:@"Files are not matching..."];
        XCTFail(@"Files are not matching...");
    }
}

-(void)testCoreData{
    
}

-(void)outputNotebooks{
    NSMutableString *output = [[NSMutableString alloc]init];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookTemplate:obj
                           intoThisLog:output];
    }];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookContent:obj
                          intoThisLog:output];
    }];
    
    [output writeToFile:OUTPUT_FILE
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];
}

-(void)testSQLiteTemplateImport{
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookTemplate:obj
                           intoThisLog:self.log];
    }];
}

-(void)testSQLiteContentImport{
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookContent:obj
                          intoThisLog:self.log];
    }];
}

@end
