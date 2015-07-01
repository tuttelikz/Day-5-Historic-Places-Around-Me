//
//  AddPinViewController.m
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import "AddPinViewController.h"

@interface AddPinViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.text = self.place.name;
    self.descriptionTextField.text = self.place.descr;
    self.imageView.image = self.place.picture;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTap:)];
    [self.imageView addGestureRecognizer:singleTapRecognizer];
}

-(void)handleImageViewTap:(UITapGestureRecognizer *)recognizer
{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) image = info[UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(UIButton *)sender {
    self.place.name = self.nameTextField.text;
    self.place.descr = self.descriptionTextField.text;
    self.place.picture = self.imageView.image;
    [self.delegate didAdd:self.place];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
