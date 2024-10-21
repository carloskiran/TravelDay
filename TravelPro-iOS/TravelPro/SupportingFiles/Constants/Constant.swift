
import Foundation
import UIKit

struct Constant {
    static let sharedInstance = Constant()
    var appActionSheetCustomTitleColor = UIColor.darkGray
    public let toastDuration = 3.0
    let borderlineColor = UIColor(red: 32/255, green: 61/255, blue: 131/255, alpha: 1.0)
    let topGradientColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
    let bottomGradientColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.81)
    var WIDTH = UIScreen.main.bounds.size.width
    var HEIGHT = UIScreen.main.bounds.size.height
    let appColor = UIColor(red: 14/255, green: 99/255, blue: 252/255, alpha: 1.0)
    let regularFont = UIFont(name: FontName.sharedInstance.APP_FONT_REGULAR, size: 16.0)
    let boldFont =  UIFont(name: FontName.sharedInstance.APP_FONT_BOLD, size: 36.0)
    let appOrangeColor = UIColor.orange
    let appBlackColor = UIColor.black
}
 struct FontName {
     static let sharedInstance = FontName()
    // MARK: Default Font
    let APP_FONT_REGULAR = "DarkerGrotesque-Regular"
     let APP_FONT_BOLD = "DarkerGrotesque-Bold"
 }
 struct CustomColor {
    
    static let shared = CustomColor()
    
     public let lightColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
     public let borderColor = #colorLiteral(red: 0.3333333333, green: 0.4156862745, blue: 0.6745098039, alpha: 1)
     public let grayColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
    public let themecolor = #colorLiteral(red: 0.3333333333, green: 0.4156862745, blue: 0.6745098039, alpha: 1)
 }


// MARK: - Localize strings

public enum login_localize {
    static let password = "Password".localized()

}

public enum signup_localize {
    static let first_name = "First Name".localized()
    static let last_name = "Last Name".localized()
    static let others = "Others".localized()
}

public enum dashboard_localize {
    static let update_now = "UPDATE NOW".localized()
    static let profile_update = "Profile_updated".localized()
}

public enum confirm_password_localize {
    static let title = "Create your new password".localized()
    static let Description = "You need to create a strong password to make sure this application is used by you.".localized()
    static let new_password_placeholder = "New password".localized()
    static let confirm_password_placeholder = "Confirm password".localized()
    static let reset_password = "RESET PASSWORD".localized()
    static let confirm = "Confirm".localized()
    static let Not_same_password = "Not same password".localized()
}

public enum my_profile_localize {
    static let my_profile = "My Profile".localized()
    static let hi_text = "Hi".localized()
    static let edit_text = "Edit".localized()
    static let vertified = "Verified".localized()
    static let verify = "Verify".localized()
    static let travelinfo = "This Year you have travelled".localized()
    static let trips = "TRIPS".localized()
    static let edit_details = "Edit details".localized()
    static let complete_profile = "Completed profile".localized()
}

public enum edit_profile_localize {
    static let edit_profile = "Edit Profile".localized()
    static let first_name = "First Name".localized()
    static let last_name = "Last Name".localized()
    static let country = "Country".localized()
    static let email = "Email/Phone".localized()
    static let you_are = "You are".localized()
    static let phone = "Phone".localized()
    static let dateOfBirth = "Date of Birth".localized()
    static let gender = "Gender".localized()
    static let residents = "Residents".localized()
    static let update = "UPDATE".localized()
    static let update_now = "UPDATE NOW".localized()
}

public enum create_travel_localize {
    static let create_new_travel = "New Travel Record".localized()
    static let from = "From".localized()
    static let to = "To".localized()
    static let taxable_days = "Taxable days".localized()
    static let definition = "Definition of day".localized()
    static let departure = "Departure".localized()
    static let return_text = "Return".localized()
    static let alert_threshold = "Alert Threshold".localized()
    static let create_new_record = "CREATE NEW RECORD".localized()
}

public enum welcome_landing_controller {
    static let welcom_to = "welcom_to".localized()
    static let app_name = "app_name".localized()
    static let app_desc = "app_desc".localized()
    static let login = "login".localized()
    static let register = "register".localized()
}

public enum login_page_controller {
    static let hello_again = "hello_again".localized()
    static let next = "next".localized()
    static let forgot_password = "forgot_password".localized()
    static let signup = "signup".localized()
    static let continue_with = "continue_with".localized()
    static let hello_signup = "hello_signup".localized()
    static let you_travelling = "you_travelling".localized()
}

public enum email_view_controller {
    static let contact_digitally = "contact_digitally".localized()
    static let first_instruction = "first_instruction".localized()
    static let second_instruction = "second_instruction".localized()
    static let add_phone = "add_phone".localized()
    static let submit = "submit".localized()
    static let confirm_email = "confirm_email".localized()
    static let verify_now = "verify_now".localized()
    static let verify_later = "verify_later".localized()
    static let phone_first_instruction = "phone_first_instruction".localized()
}


public enum tp_strings {
    
    // MARK: - Welcome controller strings
    public enum welcome_controller {
        //Splash screen texts
        static let plan_your_dream = "Explore the world with TravelTaxDay"
        static let calculate_tax = "You can Enjoy your Travel anywhere in the world"
        static let enjoy_business_trip = "You just completed your travel, we calculate your taxable days"
        
        //Splash screen descriptions
        static let travel_places = "Travel. Your money will return. Your time won’t."
        static let enjoy_your_journey = "Wish you to enjoy your journey and find something new"
        static let income_tax_returns = "Income tax returns are the most imaginative fiction being written today."
        
        //Splash button titles
        static let lets_go = "Let’s Go"
        static let continues = "Continue"
        static let lets_start = "Let’s Start"
        
        // CollectionView cell reuseidentifier
        static let welcome_collection_cell = "WelcomeCollectionViewCell"
        static let welcome_collection_end_cell = "WelcomeEndCollectionViewCell"
        
    }
    
    public enum general {
        static let app_name = "TravelTaxDay"
        static let cancel_button_title = "Cancel"
        static let ok_button_title = "OK"
    }
    
    public enum Confirm_Email_Controller {
        static let need_to_change = "Do you need to Change! Click Here"
        static let verify_this_email = "Do you wish to verify this -\n\nEmail ID & Mobile Number now!"
    }
    
    
    public enum login_page {
        static let term_use = "Terms of Use"
        static let  mobile_number = "Mobile Number"
        static let  email =  "Email"
        static let name = "Name"
        static let confirm_password = "Confirm Password"
        static let eyeclosedicon = "eyeClosedIcon"
        static let blnk_check_box = "blankCheckBox"
        static let login_signup_cell = "LoginAndSignUpCellTableViewCell"
    }
    
    public enum model_text {
        static let setup_config = "please setup the core data stack with a configuration"
        static let dd_MM_yyyy = "dd-MM-yyyy"
        static let fr_tube_internal_cache = "fr.appsolute.Tubes.internal-cache-queue"
        static let persistent_store = "persistent_store"
        static let sqlite = "sqlite"
        static let persistentcontainer = ".persistent-container"
        static let view_context = ".view-context"
        static let import_context = ".import-context"
        static let stack_queue = ".stack-queue"
        static let com_save_task = "com.mobiversa.CoreDataStack.background-save-task"
        static let userID = "userID"
        static let videoID = "videoID"
        static let phoneNumber = "phoneNumber"
        static let isFirstTimeLaunch =  "isFirstTimeLaunch"
        static let istrue = "true"
        static let wrong_type_null = "Wrong type for JSONNull"
        static let decode_Any = "Cannot decode JSONAny"
        static let encode_Any = "Cannot encode JSONAny"
    }
    
    public enum reset_password {
        static let invalid_mobile = "Invalid mobile number"
        static let invalid_code =  "Invalid country code"
        static let invalid_cred = "Invalid credentials"
        static let create_password_title = "Create New Password"
        static let confirm_password_title = "Confirm New Password"
    }
    
    public enum push_notification {
        static let gcm_sender_id = "1020779129507"
        static let platform = "iOS"
    }

    public enum forgot_password {
        
        static let welcome = "Welcome"
        static let forgot_password_title = "Forgot Password"
        static let enter_your_mobile_number_title = "Enter Your Mobile Number"
        static let next_button_title = "Next"
        
    }
    
    public enum verify_otp {
        
        static let verify_otp_title = "Verify Your Mobile"
        static let verify_otp_description = "A text has been sent to your mobile number. Please enter Code below"
        static let not_received_button_title = "Didn't receive the text?"
        static let not_received_resend_otp_title = "Resend Text"
        static let not_received_submit_button_title = "Submit"

    }
    
    public enum reset_password_success {
        
        static let reset_password_title = "Password"
        static let reset_password_description = "Your password was successfully updated."

    }
    
}
