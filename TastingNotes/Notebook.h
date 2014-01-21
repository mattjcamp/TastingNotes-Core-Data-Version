//
//  Notebook.h
//  TastingNotes
//
//  Created by Matt on 1/21/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentType_Template, Group_Template, Note;

@interface Notebook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *summaryContentTypes;
@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group_Template *)value;
- (void)removeGroupsObject:(Group_Template *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

- (void)addSummaryContentTypesObject:(ContentType_Template *)value;
- (void)removeSummaryContentTypesObject:(ContentType_Template *)value;
- (void)addSummaryContentTypes:(NSSet *)values;
- (void)removeSummaryContentTypes:(NSSet *)values;

@end
