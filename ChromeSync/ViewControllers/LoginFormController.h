//
//  LoginForm.h
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRSync.h"

@interface LoginFormController : UIViewController <UITextFieldDelegate, CRSyncDelegate>
{
    IBOutlet UIView *LoginForm;
    IBOutlet UITextField *LoginField;
    IBOutlet UITextField *PasswordField;
    IBOutlet UIImageView *ImageView;
    
}

- (IBAction)LoginButtonClick:(id)sender;


@end
