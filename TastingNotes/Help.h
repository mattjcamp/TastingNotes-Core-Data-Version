//
//  Help.h
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Help : NSObject

+(void)printThisRect:(CGRect)rect
       withThisLabel:(NSString *)label;
+(void)printThisSize:(CGSize)rect
       withThisLabel:(NSString *)label;

@end
