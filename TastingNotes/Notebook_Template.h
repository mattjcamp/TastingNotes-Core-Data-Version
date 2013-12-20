//
//  Notebook_Template.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group_Template, Notebook;

@interface Notebook_Template : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Notebook *belongsToNotebook;
@property (nonatomic, retain) NSOrderedSet *groups;
@end

@interface Notebook_Template (CoreDataGeneratedAccessors)

- (void)insertObject:(Group_Template *)value inGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGroupsAtIndex:(NSUInteger)idx;
- (void)insertGroups:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGroupsAtIndex:(NSUInteger)idx withObject:(Group_Template *)value;
- (void)replaceGroupsAtIndexes:(NSIndexSet *)indexes withGroups:(NSArray *)values;
- (void)addGroupsObject:(Group_Template *)value;
- (void)removeGroupsObject:(Group_Template *)value;
- (void)addGroups:(NSOrderedSet *)values;
- (void)removeGroups:(NSOrderedSet *)values;
@end
