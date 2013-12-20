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
@property (nonatomic, retain) NSSet *groups;
@end

@interface Notebook_Template (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group_Template *)value;
- (void)removeGroupsObject:(Group_Template *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
