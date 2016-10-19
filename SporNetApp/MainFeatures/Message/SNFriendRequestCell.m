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
    [super awakeFromNib];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
}

- (IBAction)acceptButtonClicked:(UIButton *)sender {
    [[MessageManager defaultManager] acceptFriendRequest:self.conversation];

}
- (IBAction)removeButtonClicked:(UIButton *)sender {
    NSLog(@"拒绝");
    
}
-(void)configureCellWithConversation:(Conversation*)conversation {
    self.conversation = conversation;
 
    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:conversation.myInfo];
    
    [user fetch];
                
    self.nameLabel.text = [user objectForKey:@"name"];
    self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[user objectForKey:@"bestSport"]integerValue]]];
    [[_userImageView layer] setBorderWidth:2.0f];
    NSInteger colorIndex =[[user objectForKey:@"sportTimeSlot"]integerValue];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[colorIndex];
    [_userImageView.layer setBorderColor:color.CGColor];
                
    self.schoolLabel.text = [user objectForKey:@"school"];
    self.userImageView.image = [UIImage imageWithData:[[user objectForKey:@"icon"]getData]];
          
    
}

@end
