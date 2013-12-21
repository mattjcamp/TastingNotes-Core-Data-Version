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
@property NSMutableString *log;

@end

@implementation TastingNotesTests

-(void)setUp{
    [super setUp];
    self.contentApp = [[AppContent alloc]init];
    self.log = [[NSMutableString alloc] init];
}

-(void)tearDown{
    [super tearDown];
}

-(void)testCoreDataStack{
    XCTAssertNotNil(self.contentApp, "AppContent is not initializing");
    XCTAssertNotNil(self.contentApp.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.contentApp.save, @"Can't save and the data model is probably out of sync");
}

-(void)testNotebookArray{
    [self createNotebookArrayTestData];
    
    [self.log appendString:@"\n\n"];
    [self.log appendString:@"------------------------\n"];
    [self.log appendFormat:@"self.contentApp.notebooks.count: %i\n", self.contentApp.notebooks.count];
    [self.log appendString:@"------------------------\n\n"];
    
    [self.contentApp.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.log appendString:@"\n\n"];
        [self.log appendString:@"------------------------\n"];
        [self inspectThisNotebook:obj];
        [self.log appendString:@"------------------------\n\n"];
    }];
    NSLog(@"%@", self.log);
}

-(void)testWineNotebook{
    [self.log appendString:@"\n\n"];
    [self.log appendString:@"------------------------\n"];
    [self inspectThisNotebook:[self.contentApp newWineNotebook]];
    [self.log appendString:@"------------------------\n\n"];
    NSLog(@"%@", self.log);
}

-(void)createNotebookArrayTestData{
    Notebook *nb1 = [self.contentApp newNotebookWithThisName:@"NB1"];
    Notebook_Template *nbt = [self.contentApp newNotebookTemplateWithThisName:@"NB1_NBT"];
    nb1.template = nbt;
    Group_Template *gt1 = [self.contentApp newGroupTemplateWithThisName:@"NB1_GT1"];
    [nbt addGroupsObject:gt1];
    ContentType_Template *ct1 = [self.contentApp newContentType_TemplateWithThisName:@"NB1_GT1_CT1"];
    ct1.type = @"smalltext";
    [gt1 addContentTypesObject:ct1];
    ContentType_Template *ct2 = [self.contentApp newContentType_TemplateWithThisName:@"NB1_GT1_CT2"];
    ct2.type = @"largetext";
    [gt1 addContentTypesObject:ct2];
}

-(void)inspectThisNotebook:(Notebook *)notebook{
    //Notebook Template
    XCTAssertNotNil(notebook, "No notebook");
    XCTAssertNotNil(notebook.name, "No notebook name");
    XCTAssertNotNil(notebook.order, "No notebook order");
    XCTAssertNotNil(notebook.template, "No notebook template");
    [self.log appendString:@"NOTEBOOK\n"];
    [self.log appendFormat:@"%@[%@]\n", notebook.name, notebook.order];
    
    //Notebook Template Tests
    [self.log appendString:@"   NOTEBOOK.TEMPLATE\n"];
    XCTAssertNotNil(notebook.template.belongsToNotebook, "No notebook template parent notebook");
    [self.log appendFormat:@"   %@\n", notebook.template.name];
    
    //Notebook Group Template Tests
    [self.log appendString:@"       GROUP TEMPLATES\n"];
    XCTAssertNotNil([notebook.template groupsByOrder], "No notebook groups");
    [[notebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Group_Template *gt = (Group_Template *)obj;
        XCTAssertNotNil(gt.name, "No group template name");
        XCTAssertNotNil(gt.order, "No group template order");
        XCTAssertNotNil(gt.belongsToNotebook, "No group template parent notebook");
        [self.log appendFormat:@"       %@[%@]\n", gt.name, gt.order];
        
        //Notebook Group Template Content_Type Template Tests
        [self.log appendString:@"           CONTENT_TYPE TEMPLATES\n"];
        XCTAssertNotNil([gt contentTypesByOrder], "No contentTypes for group %@", gt.name);
        
        [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType_Template *ct = (ContentType_Template *)obj;
            XCTAssertNotNil(ct.name, "No contentTypes template name");
            XCTAssertNotNil(ct.order, "No contentTypes template order");
            XCTAssertNotNil(ct.type, "No contentTypes template type");
            if(!([ct.type isEqualToString:@"smalltext"] || [ct.type isEqualToString:@"largetext"]
                 || [ct.type isEqualToString:@"list"])){
                XCTFail(@"%@ is an unsupported ContentType", ct.type);
            }
            
            XCTAssertNotNil(ct.belongsToGroup, "No contentTypes template group template");
            [self.log appendFormat:@"               %@[%@]\n", ct.name, ct.order];
            [self.log appendFormat:@"               type = %@\n", ct.type];
        }];
    }];
    
    //Notebook Content
    [self.log appendString:@"\nNOTES\n"];
    [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        XCTAssertNotNil(note.order, "No note order");
        [self.log appendFormat:@"NOTE[%@]\n", note.order];
        
        [[note.belongsToNotebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *g = (Group_Template *)obj;
            [self.log appendFormat:@"        %@[%@]\n", g.name.uppercaseString, g.order];
            
            [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [self.log appendFormat:@"               %@[%@]\n", ct.name.uppercaseString, ct.order];
                
                Content *c = [note contentInThisGroup:g
                                   andThisContentType:ct];
                if(c){
                    XCTAssertNotNil(c.data, "No content data");
                    XCTAssertNotNil(c.belongsToNote, "Content doesn't belong to a note");
                    XCTAssertNotNil(c.inThisGroup, "Content doesn't belong to a group");
                    XCTAssertNotNil(c.inThisContent_Type, "Content doesn't belong to a contentType");
                    [self.log appendString:@"                   CONTENT\n"];
                    [self.log appendFormat:@"                   data =  %@\n", c.data];
                }
                
            }];
        }];
    }];
}

@end
