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
    if([self.log length] > 0)
        [self.log writeToFile:[NSString stringWithFormat:@"/Users/matt/desktop/log-%i.txt", testNum]
                   atomically:NO
                     encoding:NSStringEncodingConversionAllowLossy
                        error:nil];
}

-(void)testCoreDataStack{
    XCTAssertNotNil(self.ac, "AppContent is not initializing");
    [self.ac generateTestDataForThisManyNotebooks:1
                         withThisManyContentTypes:1
                             andWithThisManyNotes:1];
    XCTAssertNotNil(self.ac.notebooks, @"Notebooks are not getting created");
    XCTAssertNoThrow(self.ac.save, @"Can't save and the data model is probably out of sync");
}

-(void)testNotebookArray{
    [self.ac generateTestDataForThisManyNotebooks:1
                         withThisManyContentTypes:6
                             andWithThisManyNotes:1];
    
    [self.ac.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Notebook *notebook = (Notebook *)obj;
        [Dump dumpThisNotebook:notebook
                   intoThisLog:self.log];
    }];
    
    [self.ac.notebooks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Notebook *notebook = (Notebook *)obj;
        [[notebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *gt = (Group_Template *)obj;
            
            [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                if(!([ct.type isEqualToString:@"smalltext"] || [ct.type isEqualToString:@"largetext"]
                     || [ct.type isEqualToString:@"list"])){
                    XCTFail(@"%@ is an unsupported ContentType", ct.type);
                }
            }];
        }];
        
        [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Note *note = (Note *)obj;
            [[note.belongsToNotebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Group_Template *g = (Group_Template *)obj;
                [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ContentType_Template *ct = (ContentType_Template *)obj;
                    Content *c = [note contentInThisGroup:g
                                       andThisContentType:ct];
                    if(c)
                        XCTAssertNotNil(c.data, "No content data");
                }];
            }];
        }];
    }];
    
}

@end