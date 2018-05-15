//
//  Registration.h
//  MacOptimizer
//
//  Created by ahmed lotfy on 2/14/13.
//
//

#import <Foundation/Foundation.h>
#import "ChimpKit.h"
#import "RegistrationWindowController.h"

@interface MCRegistrationViewController : NSWindowController <ChimpKitDelegate>{
    NSString * ListID;
}

@property (retain, nonatomic) NSString * apiKey;
@property (retain, nonatomic) NSString * ListID;
@property (retain, nonatomic) NSString * mainTitle;
@property (retain, nonatomic) NSString * details;
@property (retain, nonatomic) NSString * defaultKey;
@property (retain, nonatomic) NSString * mergeDateKey;

- (void) setKeyValidationBlock:(BOOL(^)(NSString *inputKey)) validationBlock;

    //username, name, email , phone, password, additionalInfo
- (void) setSuccessRegistrationBlock:(void(^)(NSDictionary *regInfo)) regSuccess;
- (IBAction)registerInMailChimp:(id)sender;
- (IBAction)continueAction:(id)sender;
- (BOOL)validateData;
- (void)registerData;
- (void)beginSheetWindow:(NSWindow *)mainWindow;

@end
