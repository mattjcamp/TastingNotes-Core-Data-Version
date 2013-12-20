//
//  Note.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notebook;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Notebook *belongsToNotebook;

@end
