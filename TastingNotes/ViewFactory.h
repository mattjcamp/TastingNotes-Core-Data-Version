//
//  ViewFactory.h
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewFactory : NSObject

@property int totalHeight;

-(id)initWithGroupTemplate:(Group_Template *)gt
                   andNote:(Note *)n
     forThisContainerFrame:(CGRect)frame;

-(UIView *)testView;

@end
