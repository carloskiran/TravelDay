
import Foundation
import UIKit

struct TextConstant {
    let emptyText = ""
    static let sharedInstance = TextConstant()
    
    let kUserLocationPermission = "It seems that you have not enabled Location Permission in your Settings. Please go to your Settings and Turn On the Permissions to use the application effectively."
    let kAlwaysLocationNeedInfo = "To provide you with the best travel experience, our app offers a feature that allows us to create a travel record in the background even when the app is closed. To enable this functionality, we kindly request you to enable always-on location access at all times, which will enhance your overall experience and provide you with detailed records of your journeys"
        
    public let SCancel: String = "Cancel"
    public let SEmpty: String = ""
    public let SOk: String = "Ok"
    public let COk: String = "OK"
    public let cameraPermission =  "Allow this app to open camera"
    public let MNoInterNetConnection : String = "Please Check your internet connection."
    public let MRequestTimeOut: String = "The request timed out."
    public let MNetworkConnectionLost: String = "Your network Connection Lost."
    let kContentType = "Content-Type"
    let vContentType = "application/json"
    let emptyemailerror = "Email id is Required"
    let emptypassworderror = "Password is Required"
    let erroremail = "Invalid Email id"
    let errorpassword = "Invalid password"
    let toastMsgDuration = 1.0
    let errorvalidpassword = "6 characters with at least 1 numeric character and 1 Symbol"
    let KContectPermissionGiveAccess = "This app requires access to Contacts to proceed. Go to Settings to grant access."
    let KOpenSettings = "Open Settings"
    let errorsamepassword = "Both password must be same"
    let errorfirstname = "Enter First name field"
    let errorlastname = "Enter Last name field"
    let errorEmailEmpty = "Email cannot be empty"
    let kErrorEnterProjectName = "Please enter the project name"
    let errorfirstnamecount = "FirstName cannot be empty"
    let errorlastnamecount = "LastName cannot be empty"
    let loginsucess = "Login Sucessfully"
    let errormobilenumber = "Please enter valid Mobile number"
    let errormobilenumbercount = "Mobile numberr must be greater than are equal to 6 and less than or equal to 10"
    let deleteUserAlertMessage = "Are you sure you want to remove the member from the Project"
    let imageFormatDifferant = "One or more image is not in jpg, Jpeg or Png image format"
    let recordingEnded = "Recording has been finished"
    let recdordingStarted = "Recording has been Started"
    let  galleryPermission =  "Allow this app to pick image from gallery"
    let errorEnterAlbumName = "Please enter the name of your Album"
    let errorEnterAlbumPurpose = "Please enter a album purpose"
    let erroremailexist = "Email Id Already Exist"
    let errorcode = "Please Kindly Choose Country Code"
    let errorotp = "OTP is Incorrect/Invalid OTP"
    let kTeamChanged = "Teamname changed successfully"
    let KWorkspaceChnged = "Workspace name changed successfully"
    let KWorkspaceExist = "Workspace name already exists"
    let KTeamNameExist = "Teamname already exists"
    let KAlbumNameAlreadyExist = "Album name already exist"
    let KAlbumIdList = "albumidList"
    let KErrorOccured = "Error Occured Please try again"
    let KBadRequest = "Bad Request"
    let kUsertype = "usertype"
    let KUserAlreadyInvit = "User already invited."
    let KPleaseEnterComment = "Please enter the comment you want to share!!!"
    let KTagAlreadyExist = "Tag name already exist."
    // Create Tag
    let kEnterTagName = "Please enter the tag name"
    let KEnterTagPurpose = "Please enter the tag purpose"
    let KTagUpdatedSuccess = "Tag edited successfully."
    let KPleaseSelectTag = "Please select any Tag from the list"
    let vcTagPurpose = "Tag Purpose"
    //Params
    let kAuthorization = "Authorization"
    let kTeamName = "teamName"
    let KTeamId = "teamId"
    let kEmail = "email"
    let KMembershipId = "membershipId"
    let kSearch = "search"
    let kSortBy = "sortby"
    let korderBy = "orderby"
    let kMemberType = "memberType"
    let kFirstName = "firstName"
    let KLastName = "lastName"
    let KPageNumber = "pagenumber"
    let KPageRecord = "pagerecord"
    let kFullMember = "fullmember"
    let kEmpty = ""
    let kSortbyOrder = "asc"
    let albumName = "albumName"
    let description = "description"
    let albumVisibility = "albumVisibility"
    let albumMembers = "albumMembers"
    let KPublicAlbum = "PUBLIC"
    let KPrivateAlbum = "PRIVATE"
    let KAlbumId = "albumId"
    let KFile = "file"
    let sortType = "sortType"
    let KLatitude = "lattitude"
    let KLongitude = "longitude"
    let KKey = "key"
    let KSortParam = "sortParam"
    let KphotoName = "photoName"
    let kverificationCode = "verificationCode"
    let kroletype = "roleType"
    let kcompanyname = "companyName"
    let klatitude = "lattitude"
    let klongitude = "longitude"
    
    //loginviewcontroller
    let kpassword = "password"
    let kusername = "username"
    let kverificationcode = "verificationCode"
    let kuserid = "user_id"
    let kkuserid = "userId"
    let KRegisterationId = "registrationId"
    //changepassword
    let koldpassword = "oldPassword"
    let kconfirmpassword  = "confirmPassword"
    let kphonecode = "phoneCode"
    let kphonenumber = "phoneNumber"
    let kgmailid = "gmailid"
    let kgrantype = "grant_type"
    let KDevice = "device"
    let VDevice = "iOS"
    //profileviewcontroller
    let kimageurl = "imageurl"
    let kbackground = "backgroundimageurl"
    let kCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let kDirection = "direction"
    let KAwskey = "awskey"
    let KExtension = "extension"
    // create tag
    let KTagTitle = "title"
    let KTagPurpose = "purpose"
    let KTagColor = "color"
    let KCreateTag = "Create Tag"
    let KNewTag = "New Tag"
    let KEditTag = "Edit Tag"
    let KSaveTag = "Save Changes"
    
    // TagListPage
    let KTagTypeId = "tagTypeId"
    let KphotoId = "photoId"
    let KcharSet = "charset"
    let VcharSet = "utf-8"
    let KType = "type"
    let KTodoId = "todoId"
    //PlaceTag Page
    let KTop = "top"
    let KLeft = "left"
    let KAlbumMembershipId = "membershipIds"
    let kText = "text"
    let KAttachment = "attachment"
    let Klabel = "label"
    let KNoteid = "noteid"
    let KStatus = "status"
    let VStatus = "complete"
    let deleteAccess = "You dont have the access to delete album."
    //AlbumDetails View Controller
    let KAssignedTo = "assignedTo"
    let kcreated = "created"
    let ksortviewby = "sortviewby"
    let kdesc = "desc"
    let KgenericNumber = "genericNumber"
    let tagId = "tagId"
    let KPhotoTagId = "photoTagId"
    //AlertValues
    let deleteTitle = "Are you sure?"
    let deleteSubTitle = "Your file will be permanently deleted!"
    let KChangePassGmail = "You cannot change the password for Login using google."
    let cancelButton = "Cancel"
    let okButton = "Yes, delete it!"
    let kcopied = "Copied!"
    let kcopiedmessage = "Your image has been copied to clipboard"
    let ksaved = "Saved!"
    let ksavedmessage = "Your image has been saved to your photos"
    let saveSubTitle = "You really want to download Images"
    let saveokButton = "Yes, Download it!"
    let kdeleted = "Deleted!"
    
    // Choose Project
    let kworkspacename = "workSpaceName"
    let datePeriodError = "Please enter a valid validation period"
    let errorRole = "Please choose the role"
    let kprojectId = "projectId"
    
    
    //Set password viewcontroller
    let invalid = "Invalid"
    let loginsuccess = "Login SuccessFully"
    
    
    //Changepassword
    let Bearer = "Bearer"
    
    //signup
    let origin = "origin"
    let FirstName = "First Name"
    let LastName = "Last Name"
    let EMail = "E-Mail"
    let CreatePassword = "Create Password"
    let EnterPhoneNumber = "Enter Phone Number (Optional)"
    let CompanyName = "Company Name (Optional)"
    let otp = "otp"
    let startingAt = "startingAt"
    
    
    //verifyOTP
    let OTPVerifiedSucessfully = "OTP Verified Sucessfully"
    
    
    //Edit Profile
    let UpdatedSuccessfully = "Updated Successfully"
    let InvalidData = "Invalid Data"
    let Warning = "Warning"
    let nocamera  = "You don't have camera"
    let Setting = "Setting"
    
    let workSpaceId = "workSpaceId"
    
    let SavedA = "Saved!"
    let savephotos =  "Your altered image has been saved to your photos."
    let photocount = "In Basic Account you can only Upload 300 photo's"
    let Projectcount = "In Basic Account you can only create 3 Project's"
    
    // CoreData things
    let kTagFireBase = "You are offline will be uploaded once back online"
    let KAlbumFireStore = "You are offline now and the album will be created once back online"
    let KTagEditFirestore = "You are offline now and the tag will be updated once back online."
    let KCreateTagFirestore = "You are offline now and the tag will be created once back online."
    let KDeleteTagFirestore = "You are offline now and the tag will be Deleted once back onliine."
    
    //StoryBoardName List
    let storyauthentiation  = "Authentication"
    let storyAlbum = "Album"
    let storyWorkSpace  = "WorkSpace"
    let storyMain  = "Main"
    let Basicsubscription = "BASIC"
    
    struct CoreDataKey {
        static let kContainerName = "TravelPro"
        static let kProjectMembers = "ProjectMembers"
        static let KAlbumDetails = "AlbumDetails"
        static let KTagLibrary = "TagLibrary"
        static let KAlbumList = "AlbumList"
        static let kAppLogDetails = "AppLogDetails"
    }
}

struct CoreDataAttributeKey {
    static let sharedInstance = CoreDataAttributeKey()
    let KuserName = "userName"
    let KAlbumId = "albumId"
    let KListview = "listview"
    let KTagData = "tagData"
    let kalbumListData = "albumListData"
}

struct nibNameKeyConstant {
    static let sharedInstance = nibNameKeyConstant()
    
    //LoginViewController
    let LoginCell = "LoginCell"
    
    //FeedViewController
    let FeedCollectionCell = "FeedCollectionCell"
    let collectionviewcellid = "collectionviewcellid"
    
    //SideMenuTableViewController
    let LeftMenuCell = "LeftMenuCell"
    
    //ViewAllWorkSpaceViewController
    let ChooseProjectTableViewCell = "ChooseProjectTableViewCell"
    
    //AppSettingViewController
    let AppSettingTableViewCell = "AppSettingTableViewCell"
    let AppsettingHeaderTableViewCell = "AppsettingHeaderTableViewCell"
    let AppsettingNotificationTableViewCell = "AppsettingNotificationTableViewCell"
    let AppsettingnormalTableViewCell = "AppsettingnormalTableViewCell"
    let ShownotificationTableViewCell = "ShownotificationTableViewCell"
    
    //DomainAccessViewController
    let DomainHederTableViewCell = "DomainHederTableViewCell"
    let DomainNameTableViewCell = "DomainNameTableViewCell"
    let DemoteamTableViewCell = "DemoteamTableViewCell"
    
    //WorkSpaceSettingViewController
    let WorkSpaceSettingCell = "WorkSpaceSettingCell"
    
    //WorkSpaceDashBoardViewController
    let WorkSpaceHeaderCell = "WorkSpaceHeaderCell"
    let WorkSpaceCell = "WorkSpaceCell"
    
    //CustomCamViewController
    let AlbumListCell = "AlbumListCell"
    
    //AddMembersViewController
    let NameSectionViewHeaderTableViewCell = "NameSectionViewHeaderTableViewCell"
    let AddMembersToProjectTableViewCell = "AddMembersToProjectTableViewCell"
    let NewMemberTableViewCell = "NewMemberTableViewCell"
    
    //AlbumTagDetailViewContoller
    let AlbumTagFilterTableViewCell = "AlbumTagFilterTableViewCell"
    let AlbumTagDetailTableViewCell = "AlbumTagDetailTableViewCell"
    
    //AlbumTagLibraryViewController
    let TagLibraryCountTableViewCell = "TagLibraryCountTableViewCell"
    
    //ViewPickedAlbumImageViewContoller
    let SelectedPickedAlbumCollectionCell = "SelectedPickedAlbumCollectionCell"
    let ViewPickedAlbumImagesCollectionViewCell = "ViewPickedAlbumImagesCollectionViewCell"
    
    //AlbumDetailsTableViewCell
    let AlbumDetailsCollectionCell = "AlbumDetailsCollectionCell"
    
    //AlbumListingCells
    let AlbumListInnerCollectionViewCell = "AlbumListInnerCollectionViewCell"
    
    //AlbumDetailsViewController
    let AlbumDetailsViewTableViewHeader = "AlbumDetailsViewTableViewHeader"
    let AlbumDetailsTableViewCell = "AlbumDetailsTableViewCell"
    
    //AlbumListingViewController
    let AlbumListingCells = "AlbumListingCells"
    
    //AlbumListHeaderCollection
    let AlbumListHeaderCell = "AlbumListHeaderCell"
    
    //AlbumListViewController
    let AlbumListHeaderCollection = "AlbumListHeaderCollection"
    
    //TagCommentViewController
    let TagCommentsTableViewCell = "TagCommentsTableViewCell"
    let TagAssignMembersTableViewCell = "TagAssignMembersTableViewCell"
    let TagCommentsAssignCollectionCell = "TagCommentsAssignCollectionCell"
    
    //TagLibraryViewController
    let TagLibraryTableViewCell = "TagLibraryTableViewCell"
    
    //ProjectViewController
    let PeopleCell = "PeopleCell"
    
    //PendingInvitesListViewController
    let AddedmemberCell = "AddedmemberCell"
    
    //To_DoCompleteViewController
    let ToDoCompleteTableViewcell = "ToDoCompleteTableViewcell"
    let ToDoCompleteTableViewHeader = "ToDoCompleteTableViewHeader"
    
    //ToDoListPhotoDetailViewController
    let ToDoListDetailTableViewCell = "ToDoListDetailTableViewCell"
    let ToDolistReasonTableViewCell = "ToDolistReasonTableViewCell"
    
    //ToDolistViewController
    let ToDoListTableViewCell = "ToDoListTableViewCell"
    
    //NotificationViewController
    let NotificationTableViewCell = "NotificationTableViewCell"
    let NotificatonHeaderTableViewCell = "NotificatonHeaderTableViewCell"
    
    //TagsViewController
    let TagsCell = "TagsCell"
    
    //AddCompanyViewController
    let AddCompanyCell = "AddCompanyCell"
    
    //search Menu
    let SearchPhotoCollectionCell = "SearchPhotoCollectionCell"
}
