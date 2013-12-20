//
//  TastingNotesTests.m
//  TastingNotesTests
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <XCTest/XCTest.h>

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

-(void)testCoreDataStack{
    XCTAssertNotNil(self.content, "AppContent is not initializing");
    XCTAssertNotNil(self.content.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.content.save, @"Can't save and the data model is probably out of sync");
}

-(void)createNotebookArrayTestData{
    NSMutableString *log = [[NSMutableString alloc] init];
    [self.content.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [log appendFormat:@"notebook.name = %@\n", [obj name]];
        [log appendFormat:@"notebook.order = %@\n", [obj order]];
        if([[obj notesByOrder]count] == 0){
            for(int i=0;i<5;i++){
                Note *n = [self.content addNoteToThisNotebook:obj];
                n.order = [NSNumber numberWithInt:i];
            }
        }
    }];
    [self.content save];
}

-(void)testNotebookArray{
    NSMutableString *log = [[NSMutableString alloc] init];
    [self createNotebookArrayTestData];
    [self.content.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [log appendString:@"\n\n"];
        [log appendString:@"------------------------\n"];
        Notebook *notebook = (Notebook *)obj;
        [log appendFormat:@"notebook.name = %@\n", notebook.name];
        [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Note *note = (Note *)obj;
            [log appendFormat:@"    note.order = %@\n", note.order];
            Group_Template *g = [note.belongsToNotebook.template.groupsByOrder firstObject];
            [log appendFormat:@"    note's first group = %@\n", g.name];
        }];
        [log appendString:@"------------------------\n\n"];
    }];
    
    NSLog(@"%@", log);
    
}

-(void)testWineNotebook{
    [self checkThisNotebookHierarchy:[self.content newWineNotebook]];
}

-(void)checkThisNotebookHierarchy:(Notebook *)notebook{
    
    NSMutableString *log = [[NSMutableString alloc] init];
    [log appendString:@"\n\n"];
    [log appendString:@"------------------------\n"];
    
    XCTAssertNotNil(notebook, @"Notebook didn't get created");
    [log appendFormat:@"notebook.name = %@\n", notebook.name];
    [log appendFormat:@"notebook.order = %@\n", notebook.order];
    XCTAssertNotNil(notebook.template, @"No Notebook Template");
    [log appendFormat:@"notebook.template.name = %@\n", notebook.template.name];
    [log appendFormat:@"notebook.template.belongsToNotebook.name = %@\n", notebook.template.belongsToNotebook.name];
    XCTAssertNotNil(notebook.template.groups, @"No Group Templates");
    
    [[notebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Group_Template *g = (Group_Template *)obj;
        [log appendFormat:@"notebook.template.groups[%i].name = %@\n", idx, g.name];
        int gi = idx;
        [[g contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType_Template *c = (ContentType_Template *)obj;
            XCTAssertNotNil(c.order, @"No ContentType Order Defined For %@", c.name);
            XCTAssertNotNil(c.type, @"No ContentType Type Defined For %@", c.name);
            
            [log appendFormat:@"notebook.template.groups[%i].contentTypes[%i] = %@\n", gi, idx, c.name];
        }];
        
    }];
    
    [log appendString:@"------------------------\n\n"];
    NSLog(@"%@", log);
}

@end
