//
//  LoginForm.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginFormController.h"
#import "FirstSynchronizationController.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginFormController ()
{
    AppDelegate *Syncr;
}
@end


@implementation LoginFormController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[Syncr NotificationsWindow] setParentView:[self view]];
    [[Syncr SyncInterface] setDelegate:self]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardShowHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardShowHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    UIImageView *Logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    [Logo setFrame:CGRectMake(0, -80, Logo.frame.size.width, Logo.frame.size.height)];
    [LoginForm addSubview:Logo];
    
    [[LoginForm layer] setMasksToBounds:NO];
    [[LoginForm layer] setShadowColor:[[UIColor grayColor] CGColor]];
    [[LoginForm layer] setShadowOffset:CGSizeMake(0,0)];
    [[LoginForm layer] setShadowRadius:15];
    [[LoginForm layer] setShadowOpacity:1];
    [[LoginForm layer] setCornerRadius:10];  
    
    [LoginField setDelegate:self]; 
    [PasswordField setDelegate:self];
        
    return self;
}

- (void)drawRect:(CGRect)rect
{
    LoginForm.layer.masksToBounds = NO;
    LoginForm.layer.shadowColor = [[UIColor whiteColor] CGColor];
    LoginForm.layer.shadowOffset = CGSizeMake(0,2);
    LoginForm.layer.shadowRadius = 2;
    LoginForm.layer.shadowOpacity = 0.2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
    [[UIColor blackColor] setFill];
    
    [path fill];
}


- (void)Login:(NSString *)Status
{
    if (Status == @"starting") 
    {
        [[Syncr NotificationsWindow] show];
    }
    else if (Status == @"error_network") 
    {
        [[Syncr NotificationsWindow] hide];
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No network connection", nil) message:NSLocalizedString(@"You must be connected to the internet to use this app", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (Status == @"error_password")
    {
        [[Syncr NotificationsWindow] hide];
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong login or password", nil) message:NSLocalizedString(@"Check your credentials and try one more time", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    else if (Status == @"success")
    {
        [[Syncr NotificationsWindow] hide];
        FirstSynchronizationController *FirstSynchronization = [[FirstSynchronizationController alloc] initWithNibName:@"FirstSynchronization" bundle:nil];
        [self presentModalViewController:FirstSynchronization animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)TextField {
    
    if (TextField == LoginField)
    {
        [LoginField resignFirstResponder];
        [PasswordField becomeFirstResponder];
    } 
    else if (TextField == PasswordField)
    {
        [self LoginButtonClick:nil];
    }
        
    return YES;    
}

- (IBAction)LoginButtonClick:(id)sender
{
    [Syncr.SyncInterface LoginAtGoogle:[LoginField text]:[PasswordField text]];
    [self touchesEnded:nil withEvent:nil];
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    [LoginField resignFirstResponder];
    [PasswordField resignFirstResponder];
}

-(void)KeyboardShowHide:(NSNotification *)Notification
{
    int x = 0;
    int y = 0;
    
    if ([Notification name] == UIKeyboardWillShowNotification) y = -80;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform Transform = CGAffineTransformMakeTranslation(x, y);
    
    [LoginForm setTransform:Transform];
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    return (InterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
