//
//  NewEntryViewController.m
//  Diary
//
//  Created by Shan Rammah on 2/1/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import "EntryViewController.h"
#import "DiaryEntry.h"
#import "CoreDataStack.h"
#import <CoreLocation/CoreLocation.h> 


@interface EntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) enum DiaryEntryMood pickedMood;

@property (weak, nonatomic) IBOutlet UIButton *badButton;

@property (weak, nonatomic) IBOutlet UIButton *averageButton;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *date;
    
    if (self.entry !=nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = DiaryEntryMoodGood;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date]; 
    
    
    self.textView.inputAccessoryView = self.accessoryView;
    
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)dismissSelf
{
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)loadLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000; //1000 meters or 0.6 miles
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    
    }];
}


- (void)insertDiaryEntry {
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.location = self.location;
    
    [coreDataStack saveContext];
    
}

- (void)updateDiaryEntry
{
    self.entry.body = self.textView.text;
    
    self.entry.mood = self.pickedMood; 
    
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (void)promptForSource {
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    
    [actionSheet showInView:self.view];
    
}


- (IBAction)doneWasPressed:(id)sender {
    
    if (self.entry != nil) {
        [self updateDiaryEntry];
    } else {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    
    [self dismissSelf]; 
}



                                  
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        if(buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    } else {
     
        [self.textView becomeFirstResponder];
        
    }
    
    
}

- (void)promptForCamera {
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)setPickedMood:(enum DiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
            
        case DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
            
        case DiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
    }
    
    
}

- (void)setPickedImage:(UIImage *)pickedImage
{
    
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noImage"] forState:UIControlStateNormal];
    }
    [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
}

- (IBAction)badWasPressed:(id)sender {
    
    self.pickedMood = DiaryEntryMoodBad;

}


- (IBAction)averageWasPressed:(id)sender {
    
    self.pickedMood = DiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(id)sender {
    
    self.pickedMood = DiaryEntryMoodGood;
}

- (IBAction)imageButtonWasPressed:(id)sender
{
    [self.textView resignFirstResponder];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
    
}


@end
