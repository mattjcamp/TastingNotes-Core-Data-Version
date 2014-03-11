//
//  ViewFactory.h
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewFactory : NSObject

-(id)initWithNote:(Note *)n;

-(UIView *)viewForThisGroupTemplate:(Group_Template *)gt
                 andThisContent:(Content *)c;

@end
