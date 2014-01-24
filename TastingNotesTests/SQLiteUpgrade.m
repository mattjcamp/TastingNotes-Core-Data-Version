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

#define REF_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/ReferenceOutput.txt")
#define OUTPUT_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/DataOutput.txt")
#define LOG_FILE (@"/Users/matt/Code/Objective-C/TastingNotes/TastingNotesTests/Output/SQLiteUpgrade_log.txt")

@interface SQLiteUpgrade : XCTestCase

@end

@implementation SQLiteUpgrade

-(void)testSQLiteImport{
    [[AppContent sharedContent] removeAllContent];
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    NSString *refFile = [NSString stringWithContentsOfFile:REF_FILE
                                                  encoding:NSStringEncodingConversionAllowLossy
                                                     error:nil];
    NSString *outFile = [Dump generateNewOutputFile:OUTPUT_FILE];
    if(![refFile isEqualToString:outFile])
        XCTFail(@"Files are not matching...");
}

@end
