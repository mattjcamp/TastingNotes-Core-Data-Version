//
//  AppState.h
//  TastingNotes
//
//  Created by Matt on 1/24/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notebook;

@interface AppState : NSManagedObject

@property (nonatomic, retain) NSNumber * legacySQLUpdated;
@property (nonatomic, retain) Notebook *selectedNotebook;

@end
