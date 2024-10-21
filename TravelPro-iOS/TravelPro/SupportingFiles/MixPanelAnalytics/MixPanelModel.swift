//
//  MixPanelModel.swift
//  TravelPro
//
//  Created by VIJAY M on 11/06/23.
//

import Foundation

/// Control the app orientation and lock specific viewcontroller
public class TravelTaxDayManager {
    static let shared = TravelTaxDayManager()
    func getUTCZoneDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: Date())
    }
    
    func getLocalZoneDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }
    
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}

public enum mixpanel_action: String {
    case login = "Login"
    case welcome = "WelcomePage"
    case locationPush = "LocationPushService"
    case dashboard = "dashboard"
    case createNewTravel = "CreateNewTravel"
    case selectTravelCountry = "SelectTravelCountry"
    case createTravelType = "CreateTravelType"
    case createMissingTravel = "CreateMissingTravel"
    case settings = "Settings"
    case termsAndCondition = "TermsAndCondition"
    case settingsCells = "SettingsCells"
    case privacyViewController = "PrivacyViewController"
    case notificationPage = "NotificationViewController"
    case export = "ExportViewController"
    case mytravel_detail = "MyTravelDetailViewController"
    case locationManager = "LocationManager"
    
    case appdelegate = "Appdelegate"
    case userSession = "User Session"
    case deviceToken = "DeviceToken"
    case network = "Network"
    case liveConnection = "Live Connection"
    case reply = "Reply"
    case player = "Player"
    case live = "Live"
    case thl_socket = "THLSocket"
    case talktohostLive = "THL"
    case larix_config = "Larix"
    case signup = "Signup"
    case profile = "Profile"
    case home = "Home"
    case unitTest = "Unit Test"
    case firstOpen = "First Open"
    case vote = "Vote"
    case poll = "Poll"
    case shoutout = "Shoutout"
    case videoUpload = "Video Uploaded"
    case invite = "Invite Friends"
    case createStation = "Station Created"
    case fanShow = "Fan Show"
    case fanBeTheHost = "Fan be the Host"
    case getInLine = "Get In Line"
    case stations = "Stations"
    case hostControl = "Host Control"
    case win = "Win"
    case report = "Report"
    case chat = "Chat"
    case homePagePlayerIdle = "Player Idle State"
    case hostCountdownInHostLive = "Host Countdown In HostLive"
}

public enum live_session: String {
    
    case reached_live_page = "Reached Live Page"
    
    case nlp_Reached_invalidate_timer = "navigateToLivePanel - invalidate timer"
    
    //    case nlp_Reached_checkForAuthorizationStatus = "navigateToLivePanel - checkForAuthorizationStatus"
    //    case nlp_Reached_checkMicAuthorizationStatus = "navigateToLivePanel - checkMicAuthorizationStatus"
    //    case nlp_Reached_mic_AVAuthorizationStatusnotDetermined = "navigateToLivePanel - Mic_AVAuthorizationStatusnotDetermined"
    //    case nlp_Reached_mic_AVAuthorizationStatusauthorized = "navigateToLivePanel - Mic_AVAuthorizationStatusauthorized"
    //    case nlp_Reached_video_AVAuthorizationStatusauthorized = "navigateToLivePanel - Video_AVAuthorizationStatusauthorized"
    //    case nlp_Reached_video_AVAuthorizationStatusnotDetermined = "navigateToLivePanel - Video_AVAuthorizationStatusnotDetermined"
    
    case talk_to_host_button_tapped = "LP - Triggered - Talk to host button"
    
    case get_auto_live_trigger_host_sheduler_api_success = "LP - Success - GetAutoLiveTriggerHostShedulerApiCal"
    case nlp_getAutoLiveTriggerHostShedulerApiCal = "navigateToLivePanel - getAutoLiveTriggerHostShedulerApiCal - Failed"
    case nlp_HostControlPanelViewController_navigate = "navigateToLivePanel - HostControlPanelViewController- navigate"
    case nlp_createStreamEngineApi_liveidmissing = "createStreamEngineApi - liveID_Missing"
    case nlp_createStreamEngineApi_applicationIdMissing = "createStreamEngineApi - applicationID_missing"
    
    case cp_pushed_to_live_page = "CP - Pushed to live page"
    case home_pushed_to_live_page = "Home - Pushed to live page"
    
    case sendDeletedHostSchedule_triggered = "sendDeletedHostSchedule - Host schedule api triggered"
    case cp_sendCreatedHostSchedule_triggered = "CP - sendCreatedHostSchedule - Host schedule api triggered"
    case h_sendCreatedHostSchedule_triggered = "H - sendCreatedHostSchedule - Host schedule api triggered"
    
    
    
    case home_host_live_count_down_disabled = "Home - Host Live Count Down Disabled"
    case hidden_home_host_live_count_down_not_disabled = "Home - Hidden - Host Live Count Down Not Disabled"
    case noHidden_home_host_live_count_down_not_disabled = "Home - No Hidden - Host Live Count Down Not Disabled"
    case cp_host_live_count_down_disabled = "CP - Host Live Count Down Disabled"
    case cp_host_live_count_down_not_disabled = "CP - Host Live Count Down Not Disabled"
    
    case home_playlist_details_updated = "H - LiveID & PlaylistID Updated"
    case cp_playlist_details_updated = "CP - LiveID & PlaylistID Updated"
    
    ///Live
    
    case appdelegate_terminate = "AppDelegate - Terminate"
    case appdelegate_become_active = "AppDelegate - Become Active"
    case appdelegate_app_resign_active = "AppDelegate - Triggered - App resign active"
    case appdelegate_live_app_terminated = "AppDelegate - Live App Terminated"
    case appdelegate_live_app_enter_foreground = "AppDelegate - Live App Entered Foreground"
    case appdelegate_live_app_enter_background = "AppDelegate - Live App Entered Background"
    
    case app_resign_active = "Triggered - App resign active"
    case live_app_terminated = "Live App Terminated"
    case live_app_enter_foreground = "Live App Entered Foreground"
    case live_app_enter_background = "Live App Entered Background"
    case live_back_button_triggered = "Triggered - Live Back button"
    
    case start_next_video = "Triggered - Click To Start Next Video Action"
    
    case capture_failed_error_alert_triggered = "Triggered - Capture failed error alert"
    case capture_failed_error = "Capture failed"
    
    
    case connection_status_disconnected = "Connection disconnected"
    case connection_status_auth_failed = "Connection Auth failed"
    case connection_status_unknown_failed = "Connection Unknown failed"
    case connection_status_timeout = "Connection Timeout"
    case connection_status_failed = "Connection Unstable. Connection Failed"
    
    case scheduled_start_time = "Live Scheduled Start Time"
    case scheduled_end_time = "Live Scheduled End Time"
    case actual_start_time = "Full Live Actual Start Time"
    case actual_end_time = "Full Live Actual End Time"
    
    
    case no_schedule_info = "No Schedule Info in Update Live Timing Details"
    case no_host_schedule = "No host Schedule Info in Update Live Timing Details"
    
    
    
    
    case reached_host_control_panel = "Reached - Host Control Panel"
    
    case alert_live_closed_forcefully = "Triggered - Force Live Close Alert!!!"
    
    case live_closed_forcefully = "Live Closed Forcefully"
    
    ///Fan Station
    case fan_station_start_api_success = "Success - Fan Station Start Api"
    case fan_station_start_api_failure = "Failure - Fan Station Start Api"
    
    case fan_station_stop_api_success = "Success - Fan Station Stop Api "
    case fan_station_stop_api_failure = "Failure - Fan Station Stop Api "
    
    
    ///Fan be the Host
    case fan_start_api_success = "Success - Fan Be The Host Start Api "
    case fan_start_api_failure = "Failure - Fan Be The Host Start Api "
    
    case fan_stop_api_success = "Success - Fan Be The Host Stop Api "
    case fan_stop_api_failure = "Failure - Fan Be The Host Stop Api"
    
    
    case application_resign_active_keep_stream_triggered = "Triggered - Resign Active - Keep streaming"
    case application_resign_active_stop_stream_triggered = "Triggered - Resign Active - Stop streaming"
    
    
    ///Host Live
    
    case host_start_api_success = "Success - Host Start Api "
    case host_start_api_failure = "Failure - Host Start Api "
    
    case host_stop_api_success = "Success - Host Stop Api "
    case host_stop_api_failure = "Failure - Host Stop Api"
    
    
    case unknown
    
}


public enum MixPanelState: String {
    case error = "Error"
    case success = "Success"
    case info = "Info"
}

public struct MixPanelData {
    var message: String?
}
