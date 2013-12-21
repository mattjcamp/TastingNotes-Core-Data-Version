//
//  TastingNotesTests.m
//  TastingNotesTests
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TastingNotesTests : XCTestCase

@property AppContent *contentApp;

@end

@implementation TastingNotesTests

-(void)setUp{
    [super setUp];
    self.contentApp = [[AppContent alloc]init];
}

-(void)tearDown{
    [super tearDown];
}

-(void)testCoreDataStack{
    XCTAssertNotNil(self.contentApp, "AppContent is not initializing");
    XCTAssertNotNil(self.contentApp.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.contentApp.save, @"Can't save and the data model is probably out of sync");
}

-(void)createNotebookArrayTestData{
    [self.contentApp.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Notebook *notebook = (Notebook *)obj;
        Group_Template *g = [[notebook.template groupsByOrder] objectAtIndex:0];
        ContentType_Template *ct = [[g contentTypesByOrder] objectAtIndex:0];
        
        if([[obj notesByOrder]count] == 0){
            for(int i=0;i<5;i++){
                Note *n = [self.contentApp addNoteToThisNotebook:obj];
                n.order = [NSNumber numberWithInt:i];
                for(int y=0;y<3;y++){
                    Content *c = [self.contentApp getNewContent];
                    c.data = [NSString stringWithFormat:@"note[%@].c=%i", n.order, y];
                    [n addThisContent:c
                          ToThisGroup:g
                    inThisContentType:ct];
                }
                
            }
        }
    }];
}

-(void)testNotebookArray{
    NSMutableString *log = [[NSMutableString alloc] init];
    [self createNotebookArrayTestData];
    [self.contentApp.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [log appendString:@"\n\n"];
        [log appendString:@"------------------------\n"];
        Notebook *notebook = (Notebook *)obj;
        [log appendFormat:@"%@[%@]\n", notebook.name, notebook.order];
        
        [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Note *note = (Note *)obj;
            [log appendFormat:@"    note[%@]\n", note.order];
            
            [[note.belongsToNotebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Group_Template *g = (Group_Template *)obj;
                [log appendFormat:@"        group[%@]\n", g.name];
                
                [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ContentType_Template *ct = (ContentType_Template *)obj;
                    [log appendFormat:@"            content_type[%@]\n", ct.name];
                    
                    
                }];
                
                /*[[note contentInThisGroup:g] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 Content *c = (Content *)obj;
                 [log appendFormat:@"            content[%i].data =  %@\n", idx, c.data];
                 }];*/
                
            }];
            
            
            
        }];
        [log appendString:@"------------------------\n\n"];
    }];
    
    NSLog(@"%@", log);
    
}

-(void)testWineNotebook{
    [self checkThisNotebookHierarchy:[self.contentApp newWineNotebook]];
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
