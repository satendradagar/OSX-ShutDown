//
//  Registration.h
//  MacOptimizer
//
//  Created by ahmed lotfy on 2/14/13.
//
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "ChimpKit.h"

#define kPRESENTED_REGISTRATION @"IS REGISTRATION INVOKED"
#define kREGISTRATIONCOMPLETED @"IS Successfully Registered"
#define kRegisteredEmailID @"EmailID"

@interface RegistrationWindowController : NSWindowController <ChimpKitDelegate>

@property (retain) IBOutlet NSTextField *firstNameText;
@property (retain) IBOutlet NSTextField *bodyDescription;

@property (retain) IBOutlet NSTextField *LastNameText;
@property (retain) IBOutlet NSTextField *emailText;
@property (retain) IBOutlet NSTextField *confirmEmailText;
@property (retain) IBOutlet NSTextField *serialText;
@property (retain) IBOutlet NSImageView *emailIcon;
@property (retain) IBOutlet NSImageView *confirmIcon;
@property (retain) IBOutlet NSImageView *serialIcon;
@property (retain) IBOutlet NSWindow *registrationWindow;
@property (retain) IBOutlet NSImageView *firstNameIcon;
@property (retain) IBOutlet NSImageView *lastNameIcon;
@property (retain) IBOutlet NSTextField *serialLabel;
@property (retain) IBOutlet NSTextField *bodyLabel;
@property (retain) IBOutlet NSButton *cancelButton;

- (IBAction)registerInMailChimp:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (void)registerData;
- (void)beginregistrationPanel:(NSWindow*) parent;
@end
