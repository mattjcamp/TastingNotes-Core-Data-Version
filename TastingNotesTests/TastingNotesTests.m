//
//  TastingNotesTests.m
//  TastingNotesTests
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "TastingNotesTests.h"

@implementation TastingNotesTests

int testNum = 0;

-(void)setUp{
    [super setUp];
    testNum++;
    self.ac = [AppContent sharedContent];
    self.log = [[NSMutableString alloc] init];
}

-(void)tearDown{
    [super tearDown];
    [self.log writeToFile:[NSString stringWithFormat:@"/Users/matt/desktop/log-%i.txt", testNum]
               atomically:NO
                 encoding:NSStringEncodingConversionAllowLossy
                    error:nil];
}

-(void)testCoreDataStack{
    
    [self.log appendString:@"\n\n"];
    [self.log appendString:@"------------------------\n"];
    [self.log appendFormat:@"TEST CORE DATA STACK\n"];
    [self.log appendString:@"------------------------"];
    
    XCTAssertNotNil(self.ac, "AppContent is not initializing");
    
    [self createNotebookArrayTestData];
    
    XCTAssertNotNil(self.ac.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.ac.save, @"Can't save and the data model is probably out of sync");
    
    [self.ac.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.log appendString:@"\n\n"];
        [self.log appendString:@"------------------------\n"];
        [self inspectThisNotebook:obj];
        [self.log appendString:@"------------------------\n\n"];
    }];
    NSLog(@"%@", self.log);
    
}

-(void)testNotebookArray{
    [self createNotebookArrayTestData];
    
    [self.log appendString:@"\n\n"];
    [self.log appendString:@"------------------------\n"];
    [self.log appendFormat:@"TEST NOTEBOOK ARRAY\n"];
    [self.log appendString:@"------------------------\n\n"];
    
    [self.ac.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    [self.log appendFormat:@"TEST WINE NOTEBOOK\n"];
    [self.log appendString:@"------------------------\n\n"];
    
    [self.log appendString:@"\n\n"];
    [self.log appendString:@"------------------------\n"];
    [self inspectThisNotebook:[self.ac newWineNotebook]];
    [self.log appendString:@"------------------------\n\n"];
    NSLog(@"%@", self.log);
}

-(void)seeIfThisContent:(Content *)content
 matchesThisContentType:(ContentType_Template *)ct{
    
    //[self.log appendFormat:@"                   ct.name =  %@\n", ct.name];
    
}



-(void)addToThisNotebookTemplate:(Notebook_Template *)template
                    thisGroupNum:(int)gtnum
           andThisContentTypeNum:(int)ctnum{
    
    NSString *gts = [NSString stringWithFormat: @"%@_GT%i", template.belongsToNotebook.name, gtnum];
    
    Group_Template *gt1 = [self.ac addGroupTemplateWithThisName:gts
                                                 toThisNotebookTemplate:template];
    [template addGroupsObject:gt1];
    for(int i=0;i<3;i++){
        NSString *cts = [NSString stringWithFormat: @"%@_CT%i", gts, i + 1];
        ContentType_Template *c = [self.ac addContentTypeTemplateWithThisName:cts
                                                                  toThisGroupTemplate:gt1];
        c.type = @"smalltext";
        [gt1 addContentTypesObject:c];
    }
}

-(void)inspectThisNotebook:(Notebook *)notebook{
    //Notebook Template
    XCTAssertNotNil(notebook, "No notebook");
    XCTAssertNotNil(notebook.name, "No notebook name");
    XCTAssertNotNil(notebook.order, "No notebook order");
    XCTAssertNotNil(notebook.template, "No notebook template");
    [self.log appendString:@"NOTEBOOKS\n"];
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
                    
                    //TESTING
                    [self seeIfThisContent:c matchesThisContentType:ct];
                    
                }
                
            }];
        }];
    }];
}

-(void)createNotebookArrayTestData{
    //Make notebooks
    for(int ni=1;ni<3;ni++){
        NSString *notebookName = [NSString stringWithFormat:@"NB%i", ni];
        Notebook *nb = [self.ac addNewNotebookWithThisName:notebookName];
        
        //Add Notebook Templates
        NSString *notebookTemplateName = [NSString stringWithFormat:@"%@_NBT", notebookName];
        Notebook_Template *nbt = [self.ac addNewNotebookTemplateWithThisName:notebookTemplateName
                                                              toThisNotebook:nb];
        
        for(int i=1;i<3;i++)
            [self addToThisNotebookTemplate:nbt thisGroupNum:i andThisContentTypeNum:1];
        
        //Add Note Content to each content type in notebook
        for(int i=0;i<3;i++){
            Note *n;
            n = [self.ac addNoteToThisNotebook:nb];
            
            [[nbt groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                int gi = [[obj order]integerValue];
                Group_Template *gt = obj;
                [[obj contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    int ci = [[obj order]integerValue];
                    Content *c = [self.ac addNewContentToThisNote:n
                                              inThisGroupTemplate:gt
                                               andThisContentType:obj];
                    c.data = [NSString stringWithFormat:@"NB%@_GT%i_CT%i_C", n.belongsToNotebook.order, gi, ci];
                }];
            }];
        }
    }
}

@end
