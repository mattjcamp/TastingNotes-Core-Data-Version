//
//  Note.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Notebook;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Notebook *belongsToNotebook;
@property (nonatomic, retain) NSSet *content;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addContentObject:(Content *)value;
- (void)removeContentObject:(Content *)value;
- (void)addContent:(NSSet *)values;
- (void)removeContent:(NSSet *)values;

@end
