//
//  Notebook.h
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group_Template, Note;

@interface Notebook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *groups;
@property (strong) NSNumber *pk;
@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

- (void)addGroupsObject:(Group_Template *)value;
- (void)removeGroupsObject:(Group_Template *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
