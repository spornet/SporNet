//
//  ViewBigPhotoViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "ViewBigPhotoViewController.h"
#import "globalMacros.h"
@interface ViewBigPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentImageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ViewBigPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentImageScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    self.contentImageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pictures.count, self.contentImageScrollView.frame.size.height*0.2);
    CGFloat xPos = 0.0;
    for(int i = 0; i < self.pictures.count; i++) {
        UIImage *image = self.pictures[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.frame = CGRectMake(xPos, 0.0, SCREEN_WIDTH, SCREEN_WIDTH);
        [self.contentImageScrollView addSubview:imageView];
        xPos += SCREEN_WIDTH;
    }
    self.pageControl.numberOfPages = self.pictures.count;
}
-(void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.contentImageScrollView.contentOffset.x / SCREEN_WIDTH;
}
@end