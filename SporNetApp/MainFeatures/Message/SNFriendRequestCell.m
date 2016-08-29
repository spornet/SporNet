//
//  SNFriendRequestCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNFriendRequestCell.h"
#import "AVObject.h"
#import "MessageManager.h"
@implementation SNFriendRequestCell

- (void)awakeFromNib {
    // Initialization code
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
}

- (IBAction)acceptButtonClicked:(UIButton *)sender {
    NSLog(@"接受");
    [[MessageManager defaultManager] acceptFriendRequest:self.conversation];
//    [[[MessageManager defaultManager] fetchAllCurrentFriendRequests] removeObject:self.conversation];
}
- (IBAction)removeButtonClicked:(UIButton *)sender {
    NSLog(@"拒绝");
    
}
-(void)configureCellWithConversation:(Conversation*)conversation {
    self.conversation = conversation;
    self.nameLabel.text = [conversation.basicInfo objectForKey:@"name"];
    self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[conversation.basicInfo objectForKey:@"bestSport"]integerValue]]];
    [[_userImageView layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[conversation.basicInfo objectForKey:@"sportTimeSlot"]integerValue]];
    [_userImageView.layer setBorderColor:color.CGColor];
    
    self.schoolLabel.text = [conversation.basicInfo objectForKey:@"school"];
    self.userImageView.image = [UIImage imageWithData:[[conversation.basicInfo objectForKey:@"icon"]getData]];
    
}

@end
