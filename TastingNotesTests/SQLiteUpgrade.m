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
#import "SQLiteDB.h"

@interface SQLiteUpgrade : XCTestCase

@property AppContent *ac;
@property NSMutableString *log;

@end

@implementation SQLiteUpgrade

int testNum2 = 0;

-(void)setUp{
    [super setUp];
    testNum2++;
    self.ac = [AppContent sharedContent];
    self.log = [[NSMutableString alloc] init];
}

-(void)tearDown{
    [super tearDown];
    if([self.log length] > 0)
        [self.log writeToFile:[NSString stringWithFormat:@"/Users/matt/desktop/SQLiteUpgrade-log-%i.txt", testNum2]
                   atomically:NO
                     encoding:NSStringEncodingConversionAllowLossy
                        error:nil];
}

-(void)testSQLite{
    SQLiteDB *database = [SQLiteDB sharedDatabase];
    
    NSArray *listOfTables = [database getListOfTableNamesInDatabase];
    
    [listOfTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.log appendFormat:@"%@\n", obj];
    }];
    
}

@end
