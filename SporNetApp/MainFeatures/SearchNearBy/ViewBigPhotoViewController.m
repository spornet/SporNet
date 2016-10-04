//
//  ViewBigPhotoViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "ViewBigPhotoViewController.h"
@interface ViewBigPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentImageScrollView;

@end

@implementation ViewBigPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentImageScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    self.contentImageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.contentImageScrollView.frame.size.height*0.2);
    
        UIImage *image = self.pictures[self.currentImageIndex];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        [self.contentImageScrollView addSubview:imageView];
    
    self.tabBarController.tabBar.hidden = YES;

}
-(void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
