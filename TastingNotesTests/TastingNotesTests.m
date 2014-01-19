//
//  TastingNotesTests.m
//  TastingNotesTests
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface TastingNotesTests : XCTestCase

@property AppContent *ac;

@end

@implementation TastingNotesTests

-(void)setUp{
    [super setUp];
    self.ac = [AppContent sharedContent];
}

-(void)tearDown{
    [super tearDown];
}

-(void)testCoreDataStack{
    XCTAssertNotNil(self.ac, "AppContent is not initializing");
    XCTAssertNotNil(self.ac.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.ac.save, @"Can't save and the data model is probably out of sync");
}

@end