//
//  SQLiteExporter.m
//  TastingNotes
//
//  Created by Matt on 1/6/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.

#import "SQLiteUpdater.h"

@interface SQLiteUpdater()

@property AppContent *ac;
@property SQLiteDB *db;

@end

@implementation SQLiteUpdater

-(id)init{
    self = [super init];
    if (self) {
        self.ac = [AppContent sharedContent];
        self.db = [SQLiteDB sharedDatabase];
    }
    return self;
}

-(void)importSQLtoCoreData{
    NSArray *notebookPK = [self.db getColumnValuesFromThisTable:@"ListsTable"
                                       usingThisSelectStatement:@"SELECT pk FROM ListsTable ORDER BY ListOrder"
                                                 fromThisColumn:0];
    [notebookPK enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self importNotebookWithThisPrimaryKey:obj];
    }];
    
    [[self.ac notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self importNotesIntoThisNotebook:obj];
    }];
    
    //[self.ac save];
}

-(void)importNotebookWithThisPrimaryKey:(NSNumber *)pk{
    NSArray *notebookData = [self.db getRowValuesFromThisTable:@"ListsTable"
                                      usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM ListsTable WHERE pk = %@", pk]];
    Notebook *n = [self.ac addNewNotebookWithThisName:[notebookData objectAtIndex:1]];
    n.pk = pk;
    Notebook_Template *nt = [self.ac addNewNotebookTemplateToThisNotebook:n];
    NSArray *groupPKs = [self.db getColumnValuesFromThisTable:@"SectionTable"
                                     usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM SectionTable WHERE fk_ToListsTable = %@ ORDER BY SectionOrder", pk]
                                               fromThisColumn:0];
    [groupPKs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self importGroupTemplateWithThisPK:obj
                           intoThisTemplate:nt];
    }];
}

-(void)importGroupTemplateWithThisPK:(NSNumber *)pk
                    intoThisTemplate:(Notebook_Template *)nt{
    NSArray *sectionData = [self.db getRowValuesFromThisTable:@"SectionTable"
                                     usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM SectionTable WHERE pk = %@", pk]];
    Group_Template *gt = [self.ac addGroupTemplateWithThisName:[sectionData objectAtIndex:2]
                                        toThisNotebookTemplate:nt];
    NSArray *controlPKs = [self.db getColumnValuesFromThisTable:@"ControlTable"
                                       usingThisSelectStatement:[NSString stringWithFormat:@"SELECT pk FROM ControlTable WHERE fk_ToSectionTable = %@ ORDER BY ControlOrder", [sectionData objectAtIndex:0]]
                                                 fromThisColumn:0];
    [controlPKs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self importControlTypeTemplateWithThisPK:obj
                                 intoThisTemplate:gt];
    }];
}

-(void)importControlTypeTemplateWithThisPK:(NSNumber *)pk
                          intoThisTemplate:(Group_Template *)gt{
    NSArray *controlData = [self.db getRowValuesFromThisTable:@"ControlTable"
                                     usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM ControlTable WHERE pk = %@", pk]];
    ContentType_Template *ct = [self.ac addContentTypeTemplateWithThisName:[controlData objectAtIndex:3] toThisGroupTemplate:gt];
    ct.type = [controlData objectAtIndex:2];
    ct.pk = pk;
    
    if([ct.type isEqualToString:@"List"]){
        NSArray *tagValueNames = [[SQLiteDB sharedDatabase] getColumnValuesFromThisTable:@"TagValues"
                                                                usingThisSelectStatement:[NSString stringWithFormat:@"SELECT TagValueText FROM TagValues WHERE fk_ToControlTable = %@ ORDER BY TagValueOrder", ct.pk]
                                                                          fromThisColumn:0];
        [tagValueNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.ac addListObjectWithThisName:obj
                                              toThisContentType:ct];
        }];
    }
}

-(void)importNotesIntoThisNotebook:(Notebook *)notebook{
    NSArray *notePKs = [self.db getColumnValuesFromThisTable:@"NotesInlistTable"
                                    usingThisSelectStatement:[NSString stringWithFormat:@"SELECT * FROM NotesInlistTable WHERE fk_ToListsTable = %@ ORDER BY NoteOrder", notebook.pk]
                                              fromThisColumn:0];
    [notePKs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *n = [self.ac addNoteToThisNotebook:notebook];
        NSNumber *notePK = (NSNumber *)obj;
        [n.belongsToNotebook.template.groupsByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *gt = (Group_Template *)obj;
            [gt.contentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [self importContentIntoThisNote:n
                             withThisPrimaryKey:notePK
                            inThisGroupTemplate:gt
                             andThisContentType:ct];
            }];
        }];
        
    }];
}

-(void)importContentIntoThisNote:(Note *)note
              withThisPrimaryKey:(NSNumber *)notePK
             inThisGroupTemplate:(Group_Template *)gt
              andThisContentType:(ContentType_Template *)ct{
    
    if([ct.type isEqualToString:@"SmallText"] || [ct.type isEqualToString:@"MultiText"]){
        NSArray *noteContent = [self.db getRowValuesFromThisTable:@"ContentInNoteAndControl"
                                         usingThisSelectStatement:[NSString stringWithFormat:@"SELECT ContentTextValue FROM ContentInNoteAndControl WHERE fk_ToNotesInlistTable = %@ AND fk_ToControlTable = %@", notePK, ct.pk]];
        if(noteContent){
            if(noteContent.count == 1 && [noteContent objectAtIndex:0] != [NSNull null]){
                Content *c = [self.ac addNewContentToThisNote:note
                                          inThisGroupTemplate:gt
                                           andThisContentType:ct];
                c.stringData = [noteContent objectAtIndex:0];
            }
        }
    }
    if([ct.type isEqualToString:@"5StarRating"] || [ct.type isEqualToString:@"Numeric"] || [ct.type isEqualToString:@"Currency"] || [ct.type isEqualToString:@"100PointScale"] || [ct.type isEqualToString:@"Date"]){
        NSArray *noteContent = [self.db getRowValuesFromThisTable:@"ContentInNoteAndControl"
                                         usingThisSelectStatement:[NSString stringWithFormat:@"SELECT ContentNumValue FROM ContentInNoteAndControl WHERE fk_ToNotesInlistTable = %@ AND fk_ToControlTable = %@", notePK, ct.pk]];
        if(noteContent){
            if(noteContent.count == 1 && [noteContent objectAtIndex:0] != [NSNull null]){
                Content *c = [self.ac addNewContentToThisNote:note
                                          inThisGroupTemplate:gt
                                           andThisContentType:ct];
                c.numberData = [noteContent objectAtIndex:0];
            }
        }
    }
    if([ct.type isEqualToString:@"Picture"]){
        NSArray *noteContent = [self.db getRowValuesFromThisTable:@"ContentInNoteAndControl"
                                         usingThisSelectStatement:[NSString stringWithFormat:@"SELECT ContentNumValue FROM ContentInNoteAndControl WHERE fk_ToNotesInlistTable = %@ AND fk_ToControlTable = %@", notePK, ct.pk]];
        if(noteContent){
            if(noteContent.count == 1 && [noteContent objectAtIndex:0] != [NSNull null]){
                Content *c = [self.ac addNewContentToThisNote:note
                                          inThisGroupTemplate:gt
                                           andThisContentType:ct];
                c.binaryData = [noteContent objectAtIndex:0];
            }
        }
    }
    if([ct.type isEqualToString:@"List"]){

            NSNumber *ContentInNoteAndControlPK = [self.db getValueFromThisTable:@"ContentInNoteAndControl"
                                                        usingThisSelectStatement:[NSString stringWithFormat:@"SELECT pk FROM ContentInNoteAndControl WHERE fk_ToNotesInlistTable = %@ AND fk_ToControlTable = %@", notePK, ct.pk]];
        
            Content *c = [self.ac addNewContentToThisNote:note
                                      inThisGroupTemplate:gt
                                       andThisContentType:ct];
            
            NSArray *fk_To_TagValues = [[SQLiteDB sharedDatabase] getColumnValuesFromThisTable:@"TagValuesInContent"
                                                                      usingThisSelectStatement:[NSString stringWithFormat:@"SELECT fk_To_TagValues FROM TagValuesInContent WHERE fk_To_ContentInNoteAndControl = %@", ContentInNoteAndControlPK]
                                                                                fromThisColumn:0];
            
            [fk_To_TagValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSString *tvText = [self.db getValueFromThisTable:@"TagValues"
                                              usingThisSelectStatement:[NSString stringWithFormat:@"SELECT TagValueText FROM TagValues WHERE pk = %@", obj]];
                NSPredicate *p = [NSPredicate predicateWithFormat:@"name = %@", tvText];
                NSArray *a = [ct.listObjectsByOrder filteredArrayUsingPredicate:p];
                ListObject *lo = (ListObject *)[a firstObject];
                
                [self.ac addSelectedListObjectWithThisIdentifier:lo.identifier
                                                   toThisContent:c];
                
            }];
        
    }
}

@end