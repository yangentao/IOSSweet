import UIKit
import AVFoundation

public class QRScaner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
	private let device: AVCaptureDevice
	private lazy var session = AVCaptureSession()
	private lazy var metaOut: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
	private var previewLayer: AVCaptureVideoPreviewLayer? = nil
	private var needProcess: Bool = true
	private var interestRect: CGRect = .zero

	var successBlock: (QRResult) -> Void = { _ in
	}

	init(device: AVCaptureDevice, devInput: AVCaptureDeviceInput, videoView: UIView, interestRect: CGRect) {
		self.device = device
		super.init()

		self.interestRect = interestRect
		if session.canAddInput(devInput) {
			session.addInput(devInput)
		}

		if session.canAddOutput(metaOut) {
			session.addOutput(metaOut)
		}
		metaOut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
		metaOut.metadataObjectTypes = [.qr]

		if #available(iOS 10, *) {
			let photoOut = AVCapturePhotoOutput()
			if #available(iOS 11, *) {
				photoOut.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg.rawValue])
			} else {
				photoOut.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
			}
			if session.canAddOutput(photoOut) {
				session.addOutput(photoOut)
			}
		} else {
			let imgOut: AVCaptureStillImageOutput = AVCaptureStillImageOutput();
			imgOut.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			if session.canAddOutput(imgOut) {
				session.addOutput(imgOut)
			}
		}

		session.sessionPreset = .hd1280x720

		let preLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
		preLayer.videoGravity = .resizeAspectFill
		preLayer.frame = videoView.bounds
		videoView.layer.insertSublayer(preLayer, at: 0)
		self.previewLayer = preLayer

		self.configDevice { dev in
			if (dev.isFocusPointOfInterestSupported && dev.isFocusModeSupported(.continuousAutoFocus)) {
				devInput.device.focusMode = .continuousAutoFocus
			}
		}
	}

	deinit {
		self.previewLayer?.removeFromSuperlayer()
	}

	public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if !needProcess {
			return
		}
		needProcess = false
		for mo in metadataObjects {
			if let code = mo as? AVMetadataMachineReadableCodeObject {
				let r = QRResult(code.stringValue)
				stop()
				successBlock(r)
				self.successBlock = {
					_ in
				}
				return
			}
		}
		if self.session.isRunning {
			needProcess = true
		}
	}

	func start() {
		if !session.isRunning {
			needProcess = true
			session.startRunning()
			if let r = self.previewLayer?.metadataOutputRectConverted(fromLayerRect: self.interestRect) {
				self.metaOut.rectOfInterest = r
			}
		}
	}

	func stop() {
		if session.isRunning {
			needProcess = false
			session.stopRunning()
		}
	}

	public var hasTorch: Bool {
		return self.device.hasFlash && self.device.hasTorch
	}

	public func setTorch(torch: Bool) {
		self.configDevice {
			dev in
			if dev.hasTorch {
				dev.torchMode = torch ? .on : .off
			}
		}
	}

	public var isTorchOn: Bool {
		return self.device.torchMode == .on
	}

	public func toggleTorch() {
		self.configDevice {
			dev in
			if dev.hasTorch {
				switch dev.torchMode {
				case .on:
					dev.torchMode = .off
				case .off:
					dev.torchMode = .on
				case .auto:
					dev.torchMode = .on
				default:
					break
				}
			}
		}
	}

	public func configDevice(_ block: (AVCaptureDevice) -> Void) {
		let dev = self.device
		do {
			try dev.lockForConfiguration()
			block(dev)
			dev.unlockForConfiguration()
		} catch {
			print("error: \(error)")
		}
	}

}
