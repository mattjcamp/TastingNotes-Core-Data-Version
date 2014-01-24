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

@interface SQLiteUpgrade_DrillDown : XCTestCase

@end

@implementation SQLiteUpgrade_DrillDown

-(void)testMakeNewReferenceFile{
    [[AppContent sharedContent] removeAllContent];
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    [Dump generateNewOutputFile:REF_FILE];
}

@end
