//
//  SNContactCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/26/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNContactCell.h"

@implementation SNContactCell

- (void)awakeFromNib {
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
}
-(void)configureCellWithConversation:(Conversation *)c {
    [self.userImageView.layer setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[c.basicInfo objectForKey:@"sportTimeSlot"]integerValue]];
    [_userImageView.layer setBorderColor:color.CGColor];
    self.userNameField.text = [c.basicInfo objectForKey:@"name"];
    self.userImageView.image = [UIImage imageWithData:[[c.basicInfo objectForKey:@"icon"]getData]];
    self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[c.basicInfo objectForKey:@"bestSport"]integerValue]]];
}
@end
