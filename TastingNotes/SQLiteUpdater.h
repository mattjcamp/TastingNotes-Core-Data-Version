//
//  SQLiteExporter.h
//  TastingNotes
//
//  Created by Matt on 1/6/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDB.h"
#import "AppContent.h"

@interface SQLiteUpdater : NSObject

-(void)importSQLtoCoreData;

@end