//
//  LBXPermissions.swift
//  swiftScan
//
//  Created by xialibing on 15/12/15.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

public class PhotoPerm {

	public static func authPhoto(_ comletion: @escaping (Bool) -> Void) {
		let g = PHPhotoLibrary.authorizationStatus()
		switch g {
		case .authorized:
			comletion(true)
		case .denied, .restricted:
			comletion(false)
		case .notDetermined:
			PHPhotoLibrary.requestAuthorization({ (status) in
				DispatchQueue.main.async {
					comletion(status == .authorized)
				}
			})
		default:
			break
		}
	}

	public static func authCameraVideo(_ comletion: @escaping (Bool) -> Void) {
		let g = AVCaptureDevice.authorizationStatus(for: .video);

		switch g {
		case .authorized:
			comletion(true)
			break;
		case .denied:
			comletion(false)
			break;
		case .restricted:
			comletion(false)
			break;
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
				DispatchQueue.main.async {
					comletion(granted)
				}
			})
		default:
			break
		}
	}

	//跳转到APP系统设置权限界面
	public static func jumpToSetting() {
		let url = URL(string: UIApplication.openSettingsURLString)
		url?.open()
	}

}
