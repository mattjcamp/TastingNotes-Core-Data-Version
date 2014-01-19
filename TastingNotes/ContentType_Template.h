//
//  ContentType_Template.h
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Group_Template, ListObject;

@interface ContentType_Template : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Group_Template *belongsToGroup;
@property (nonatomic, retain) NSSet *contentInThisContent_Type;
@property (nonatomic, retain) NSSet *listObjects;
@property (strong) NSNumber *pk;
@end

@interface ContentType_Template (CoreDataGeneratedAccessors)

- (void)addContentInThisContent_TypeObject:(Content *)value;
- (void)removeContentInThisContent_TypeObject:(Content *)value;
- (void)addContentInThisContent_Type:(NSSet *)values;
- (void)removeContentInThisContent_Type:(NSSet *)values;

- (void)addListObjectsObject:(ListObject *)value;
- (void)removeListObjectsObject:(ListObject *)value;
- (void)addListObjects:(NSSet *)values;
- (void)removeListObjects:(NSSet *)values;

@end
