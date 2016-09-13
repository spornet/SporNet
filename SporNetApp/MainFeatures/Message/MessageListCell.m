//
//  MessageListCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageListCell.h"
#import "TimeManager.h"
#import <JSBadgeView.h>
@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
    _badgeView = [[JSBadgeView alloc] initWithParentView:_userImageView alignment:JSBadgeViewAlignmentTopRight];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
}


-(void)configureCellWithConversation:(Conversation*)c {
    
    
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[c.basicInfo objectForKey:@"sportTimeSlot"]integerValue]];
    [_userImageView.layer setBorderColor:color.CGColor];
    [[_userImageView layer] setBorderWidth:2.0f];
    self.userImageView.image = [UIImage imageWithData:[[c.basicInfo objectForKey:@"icon"]getData]];
    if(c.unreadMessageNumber) {
        _badgeView.hidden = NO;
        _badgeView.badgeText = [NSString stringWithFormat:@"%ld", c.unreadMessageNumber];
    } else _badgeView.hidden = YES;
    self.userNameLabel.text = [c.basicInfo objectForKey:@"name"];
    self.lastTimeLabel.text = [TimeManager getTimeStringFromNSDate:c.conversation.lastMessageAt];
    self.bestSportImage.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[c.basicInfo objectForKey:@"bestSport"]integerValue]]];
//    AVIMMessage *message =[c.conversation queryMessagesFromCacheWithLimit:1][0];
//    self.lastMessageLabel.text = [(AVIMTypedMessage*)message text];
//    self.lastTimeLabel.text = [TimeManager getConvastionTimeStr: [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000]];
    [c.conversation queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
        AVIMMessage *message = (AVIMMessage*)objects[0];
        self.lastMessageLabel.text = [objects[0]text];
        self.lastTimeLabel.text = [TimeManager getConvastionTimeStr: [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000]];
    }];
}
@end
