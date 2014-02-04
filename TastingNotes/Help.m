//
//  Help.m
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "Help.h"

@implementation Help

+(void)printThisRect:(CGRect)rect
       withThisLabel:(NSString *)label{
    NSLog(@"%@", label);
    NSLog(@"rect(x,y,w,h) = %f:%f:%f:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

+(void)printThisSize:(CGSize)size
       withThisLabel:(NSString *)label{
    NSLog(@"%@", label);
    NSLog(@"size(w,h) = %f:%f", size.width, size.height);

}

@end
