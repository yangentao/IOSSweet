//
// Created by entaoyang@163.com on 2019/9/21.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
public class QRResult {
	public var text: String = ""

	public init(_ str: String?) {
		self.text = str ?? ""
	}
}

public class QR {
	public static func recognizeQRImage(image: UIImage) -> QRResult? {
		if let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) {
			let img = CIImage(cgImage: image.cgImage!)
			let features: [CIFeature] = detector.features(in: img, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
			for feature in features {
				if let featureTmp = feature as? CIQRCodeFeature {
					return QRResult(featureTmp.messageString)
				}
			}
		}
		return nil
	}

	public static func createQRImage(codeString: String, size: CGSize, qrColor: UIColor = .black, bkColor: UIColor = .white) -> UIImage? {
		guard  let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
			return nil
		}
		qrFilter.setValue(codeString.data(using: String.Encoding.utf8), forKey: "inputMessage")
		qrFilter.setValue("M", forKey: "inputCorrectionLevel")
		guard let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": qrFilter.outputImage!, "inputColor0": CIColor(cgColor: qrColor.cgColor), "inputColor1": CIColor(cgColor: bkColor.cgColor)]) else {
			return nil
		}
		guard let qrImage = colorFilter.outputImage else {
			return nil
		}
		let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent)!
		UIGraphicsBeginImageContext(size);
		let context = UIGraphicsGetCurrentContext()!;
		context.interpolationQuality = CGInterpolationQuality.none;
		context.scaleBy(x: 1.0, y: -1.0);
		context.draw(cgImage, in: context.boundingBoxOfClipPath)
		let codeImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return codeImage
	}

	public static func addImageLogo(srcImg: UIImage, logoImg: UIImage, logoSize: CGSize) -> UIImage {
		UIGraphicsBeginImageContext(srcImg.size);
		srcImg.draw(in: CGRect(x: 0, y: 0, width: srcImg.size.width, height: srcImg.size.height))
		let rect = CGRect(x: srcImg.size.width / 2 - logoSize.width / 2, y: srcImg.size.height / 2 - logoSize.height / 2, width: logoSize.width, height: logoSize.height);
		logoImg.draw(in: rect)
		let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return resultingImage!;
	}
}