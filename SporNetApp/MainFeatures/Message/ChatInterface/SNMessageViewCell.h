//
//  SNMessageViewCell.h
//  Messaging
//
//  Created by Peng on 8/16/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNChatModelFrame;

@interface SNMessageViewCell : UITableViewCell

@property (nonatomic, strong) SNChatModelFrame *modelFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView; 

@end
