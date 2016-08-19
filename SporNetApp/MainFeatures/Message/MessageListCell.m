//
//  MessageListCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageListCell.h"
#import "TimeManager.h"
@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellWithConversation:(Conversation*)c {
    self.userImageView.image = [UIImage imageWithData:[[c.basicInfo objectForKey:@"icon"]getData]];
    self.userNameLabel.text = [c.basicInfo objectForKey:@"name"];
    self.lastTimeLabel.text = [TimeManager getTimeStringFromNSDate: c.conversation.lastMessageAt];
    [c.conversation queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
        self.lastMessageLabel.text = [objects[0]text];
    }];
}
@end
