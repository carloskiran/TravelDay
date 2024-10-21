
//
//  UserDefaultModule.swift
 

import Foundation
class UserDefaultModule {
    static let shared = UserDefaultModule()
   
    func setUserID(userID: String){
        UserDefaults.standard.set(userID, forKey: "user_id")
    }
    
    func getUserID() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "user_id"))
    }
    
    func setEmailID(userID: String){
        UserDefaults.standard.set(userID, forKey: "email_id")
    }
    
    func getEmailID() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "email_id"))
    }
    
    func setUserTypeID(userID: Int){
        UserDefaults.standard.set(userID, forKey: "userTypeid")
    }
    func getUserTypeID() -> Int? {
        return utilsClass.sharedInstance.checkNullvalueInt(passedValue: UserDefaults.standard.value(forKey: "userTypeid"))
    }
    
    func getApiAuthendicationToken()->String{
        
        return ("bearer \(self.getAccessToken())")
    }
    func setAccessToken(token:String){
        UserDefaults.standard.set(utilsClass.sharedInstance.checkNullvalue(passedValue: token), forKey: "accessToken")
    }
    
    func getAccessToken()->String{
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "accessToken"))
    }
    
    func setgetuserLoggedStatus(logStatus:String){
        UserDefaults.standard.set(utilsClass.sharedInstance.checkNullvalue(passedValue: logStatus), forKey: "logStatus")
    }
    
    func getuserLoggedStatus()->String{
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "logStatus"))
    }
    
    func setUsertype(userType: String){
        UserDefaults.standard.set(userType, forKey: "usertype")
    }
    func getUserType() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "usertype"))
    }
    func setUserName(userID: String){
        UserDefaults.standard.set(userID, forKey: "username")
    }
    func getUserName() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "username"))
    }
    func setProfilePic(userID: String){
        UserDefaults.standard.set(userID, forKey: "profilepic")
    }
    func getProfilePic() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "profilepic"))
    }
    
    func textDesctription() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "textDesctription"))
    }
    func settextDesctription() {
        UserDefaults.standard.set("", forKey: "textDesctription")
    }
    
    func setUserResident(resident: String) {
        UserDefaults.standard.set(resident, forKey: "user_resident")
    }
    
    func setThresholdDetails(threshold: String) {
        UserDefaults.standard.set(threshold, forKey: "alert_threshold")
    }
    
    func getThresholdDetails() -> String {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "alert_threshold"))
    }
    
    func setNonWorkingDays(days: String) {
        UserDefaults.standard.set(days, forKey: "non_workingday")
    }
    
    func getNonWorkingDays() -> String {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "non_workingday"))
    }
    
    func setSettingsTaxableStartDate(startDate: String) {
        UserDefaults.standard.set(startDate, forKey: "tax_start_date")
    }
    
    func getSettingsTaxableStartDate() -> String {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "tax_start_date"))
    }
    
    func setSettingsTaxableEndDate(endDate: String) {
        UserDefaults.standard.set(endDate, forKey: "tax_end_date")
    }
    
    func getSettingsTaxableEndDate() -> String {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "tax_end_date"))
    }
    
    func setMaximumStayCount(dayCount: Int) {
        UserDefaults.standard.set(dayCount, forKey: "max_stay_count")
    }
    
    func setDefinitionOfDay(time: String) {
        UserDefaults.standard.set(time, forKey: "definition_of_day")
    }
    
    func getMaximumStayCount() -> Int {
        return utilsClass.sharedInstance.checkNullvalueInt(passedValue: UserDefaults.standard.value(forKey: "max_stay_count"))
    }
    
    func getUserResident() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "user_resident"))
    }
    
    func getDefinitionOfDay() -> String {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "definition_of_day"))
    }
    
    func setUseremail(email: String){
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func getUseremail() -> String? {
        return utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaults.standard.value(forKey: "email"))
    }
    
    /// set
    /// - Parameters:
    ///   - value: Any
    ///   - key: Key
    func set(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// value
    /// - Parameter key: Key
    /// - Returns: Any
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    /// containsValue
    /// - Parameter key: Key
    /// - Returns: Bool
    func containsValue(forKey key: String) -> Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }
    
    /// removeObject
    /// - Parameter key: Key
    func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
   
}

