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
        [self.log writeToFile:@"/Users/matt/desktop/SQLiteUpgrade-log.txt"
                   atomically:NO
                     encoding:NSStringEncodingConversionAllowLossy
                        error:nil];
}

-(void)testSQLite{
    
    NSArray *n1 = [self.ac notebooks];
    [self.log appendFormat:@"n1.count = %i\n", n1.count];
    
    SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
    [se importSQLtoCoreData];
    
    NSArray *n2 = [self.ac notebooks];
    [self.log appendFormat:@"n2.count = %i\n", n2.count];
    
}

-(void)testCoreData{
    NSArray *n1 = [self.ac notebooks];
    [n1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Dump dumpThisNotebookTemplate:obj
                           intoThisLog:self.log];
    }];
    
}

@end
