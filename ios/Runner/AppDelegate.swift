import CoreLocation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  private let locationChannelName = "agrix/location"
  private let locationMethodGetCurrent = "getCurrentLocation"

  private let locationManager = CLLocationManager()
  private var pendingResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: locationChannelName,
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }

        if call.method == self.locationMethodGetCurrent {
          self.handleLocationRequest(result: result)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }

  private func handleLocationRequest(result: @escaping FlutterResult) {
    guard pendingResult == nil else {
      result(
        FlutterError(
          code: "LOCATION_IN_PROGRESS",
          message: "A location request is already in progress.",
          details: nil
        )
      )
      return
    }

    pendingResult = result

    let status = currentAuthorizationStatus()

    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.requestLocation()
    case .restricted, .denied:
      completeWithError(
        code: "LOCATION_PERMISSION_DENIED",
        message: "Location permission denied."
      )
    @unknown default:
      completeWithError(
        code: "LOCATION_AUTH_UNKNOWN",
        message: "Unknown location authorization status."
      )
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard pendingResult != nil else { return }

    let status = currentAuthorizationStatus()
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      manager.requestLocation()
    } else if status == .restricted || status == .denied {
      completeWithError(
        code: "LOCATION_PERMISSION_DENIED",
        message: "Location permission denied."
      )
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let result = pendingResult else { return }
    guard let location = locations.first else {
      completeWithError(
        code: "LOCATION_NOT_FOUND",
        message: "No location data available."
      )
      return
    }

    result([
      "latitude": location.coordinate.latitude,
      "longitude": location.coordinate.longitude,
    ])
    pendingResult = nil
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    completeWithError(
      code: "LOCATION_FAILED",
      message: error.localizedDescription
    )
  }

  private func completeWithError(code: String, message: String) {
    pendingResult?(
      FlutterError(
        code: code,
        message: message,
        details: nil
      )
    )
    pendingResult = nil
  }

  private func currentAuthorizationStatus() -> CLAuthorizationStatus {
    if #available(iOS 14.0, *) {
      return locationManager.authorizationStatus
    }
    return CLLocationManager.authorizationStatus()
  }
}
