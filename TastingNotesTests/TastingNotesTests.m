//
//  TastingNotesTests.m
//  TastingNotesTests
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppContent.h"
#import "Notebook.h"

@interface TastingNotesTests : XCTestCase

@property AppContent *content;

@end

@implementation TastingNotesTests

-(void)setUp{
    [super setUp];
    self.content = [[AppContent alloc]init];
}

-(void)tearDown{
    [super tearDown];
}

-(void)testNotebookCreation{
    NSMutableString *log = [[NSMutableString alloc] init];
    [log appendString:@"\n\n"];
    [log appendString:@"------------------------\n"];
    XCTAssertNotNil(self.content, "AppContent is not initializing");
    if(![self.content.test isEqualToString:@"TEST"])
        XCTFail(@"content.test is not the right value");
    
    XCTAssertNotNil(self.content.notebooks, @"Notebooks are not getting created");
    
    Notebook *notebook = [self.content.notebooks firstObject];
    [log appendFormat:@"notebook = %@\n", notebook];
    [log appendFormat:@"notebook.name = %@\n", notebook.name];
    [log appendFormat:@"notebook.order = %@\n", notebook.order];
    notebook.order = [NSNumber numberWithInt:[notebook.order integerValue] + 1];
    
    XCTAssertNoThrow(self.content.save, @"Can't save and the data model is probably out of sync");
    
    [log appendString:@"------------------------\n\n"];
    NSLog(@"%@", log);

}

-(void)testTemplateHierarchy{
    NSMutableString *log = [[NSMutableString alloc] init];
    [log appendString:@"\n\n"];
    [log appendString:@"------------------------\n"];
    XCTAssertNotNil(self.content, "AppContent is not initializing");
    
    XCTAssertNotNil(self.content.notebooks, @"Notebooks are not getting created");
    
    Notebook *notebook = [self.content.notebooks firstObject];
    [log appendFormat:@"notebook = %@\n", notebook];
    [log appendFormat:@"notebook.name = %@\n", notebook.name];
    [log appendFormat:@"notebook.order = %@\n", notebook.order];
    notebook.order = [NSNumber numberWithInt:[notebook.order integerValue] + 1];
    
    XCTAssertNoThrow(self.content.save, @"Can't save and the data model is probably out of sync");
    
    [log appendString:@"------------------------\n\n"];
    NSLog(@"%@", log);
    
}

@end
