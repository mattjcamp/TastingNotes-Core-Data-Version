//
//  SmallTextEditorVC.m
//  TastingNotes
//
//  Created by Matt on 3/13/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "SmallTextEditorVC.h"

@interface SmallTextEditorVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property Content *content;

@end

@implementation SmallTextEditorVC

-(id)initWithContent:(Content *)c{
    self = [super initWithNibName:@"SmallTextEditorVC" bundle:nil];
    if (self) {
        self.content = c;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Editor";
    self.titleLabel.text = self.content.inThisContent_Type.name;
    [self.contentTextView becomeFirstResponder];
}

@end