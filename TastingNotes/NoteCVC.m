//
//  NoteCVC.m
//  TastingNotes
//
//  Created by Matt on 1/29/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteCVC.h"
#import "CCVC.h"
#import "ViewFactory.h"

@interface NoteCVC ()

@end

@implementation NoteCVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.note.title;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.note.belongsToNotebook groups].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder] objectAtIndex:indexPath.row];
    
    CCVC *cvc = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCCell"
                                                          forIndexPath:indexPath];
    
    cvc.myLabel.text = gt.name;
    
    /*
     NSMutableString *contentString = [[NSMutableString alloc]init];
     
     [gt.contentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     [contentString appendFormat:@"%@\n", [self.note contentInThisGroup:gt
     andThisContentType:obj]];
     }];
     
     cvc.myTextView.text = contentString;
     */

    
    //Add First View
    cvc.myScrollView.pagingEnabled = YES;
    CGFloat totalHeight = 0;
    CGFloat y = cvc.frame.origin.y;
    CGRect r = CGRectMake(cvc.frame.origin.x,
                          y,
                          cvc.frame.size.width,
                          cvc.frame.size.height);
    UIView *v = [ViewFactory testViewWithThisReferenceFrame:r];
    totalHeight = totalHeight + v.frame.size.height;
    [cvc.myScrollView addSubview:v];
    
    //Add Second View
    y = y + v.frame.size.height + 5;
    r = CGRectMake(cvc.frame.origin.x,
                   y,
                   cvc.frame.size.width,
                   v.frame.size.height);
    v = [ViewFactory testViewWithThisReferenceFrame:r];
    totalHeight = totalHeight + v.frame.size.height;
    [cvc.myScrollView addSubview:v];
    
    cvc.myScrollView.contentSize = CGSizeMake(cvc.contentView.frame.size.width, totalHeight);
    
    
    /*    for (int i = 0; i < numberOfViews; i++) {
     CGFloat y = cvc.frame.origin.y;
     [cvc.myScrollView addSubview:[ViewFactory testViewWithThisReferenceFrame:cvc.frame]];
     
     }*/
    
    /*
     for (int i = 0; i < numberOfViews; i++) {
     CGFloat yOrigin = i * (cvc.contentView.frame.origin.y + cvc.contentView.frame.size.height);
     CGRect r = CGRectMake(5, yOrigin, cvc.contentView.frame.size.width, cvc.contentView.frame.size.height);
     UIView * awesomeView = [[UIView alloc] initWithFrame:r];
     switch (i) {
     case 0:
     awesomeView.backgroundColor = [UIColor blueColor];
     break;
     case 1:
     awesomeView.backgroundColor = [UIColor yellowColor];
     break;
     case 2:
     awesomeView.backgroundColor = [UIColor greenColor];
     break;
     default:
     awesomeView.backgroundColor = [UIColor blackColor];
     break;
     }
     
     [cvc.myScrollView addSubview:awesomeView];
     }*/
    
    return cvc;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end