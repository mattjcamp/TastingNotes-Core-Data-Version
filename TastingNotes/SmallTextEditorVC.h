//
//  SmallTextEditorVC.h
//  TastingNotes
//
//  Created by Matt on 3/13/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallTextEditorVC : UIViewController<UITextViewDelegate>

-(id)initWithContent:(Content *)c;

@end