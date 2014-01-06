//
//  columnMetaData.h
//  WinePad
//
//  Created by Matthew Campbell on 9/16/09.
//  Copyright 2009 App Shop, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteColumnMetaData : NSObject

@property(nonatomic, assign) int sqliteType; 
@property(nonatomic, assign) int columnPosition;
@property(nonatomic, strong) NSString *columnName; 

@end