//
// Created by entaoyang on 2019-02-13.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet

public class ImageOption {
	var forceDownload: Bool = false
	var failedImage = ""
}

class _FileLocal {
	private let map: FileMap<String, String> = FileMap<String, String>(File.docFile("local_file_cache"))

	private let dirName = "file_cache"

	init() {
		let dir = File.cacheFile(dirName)
		if !dir.isDir {
			dir.mkdir()
		}
	}

	fileprivate func makeFile(_ filename: String) -> File {
		return File.cacheFile(dirName.appendPath(filename))
	}

	func find(_ url: String) -> File? {
		guard let f = map.get(url) else {
			return nil
		}
		let file = makeFile(f)
		if file.isFile {
			return file
		}
		sync(self) {
			map.remove(url)
			map.save()
		}
		return nil
	}

	func remove(_ url: String) {
		guard let f = map.get(url) else {
			return
		}
		File(f).remove()
		sync(self) {
			map.remove(url)
			map.save()
		}
	}

	func put(_ url: String, _ filename: String) {
		sync(self) {
			map.put(url, filename)
			map.save()
		}
	}

	func dump() -> [String: String] {
		return map.model.map
	}

}

let ImageLocal: _FileLocal = _FileLocal()

public typealias DownCallback = (String, Bool) -> Void

fileprivate class _FileDownloader {
	var processSet: Set<String> = Set<String>()
	private var listenMap = [String: [DownCallback]]()
	private let taskQueue = TaskQueue("file_download")

	func isDownloading(_ url: String) -> Bool {
		return listenMap.keys.contains(url)
	}

	func retrive(_ url: String, _ block: @escaping (File?) -> Void) {
		let f = ImageLocal.find(url)
		if f != nil {
			logd("使用缓存文件")
			block(f)
			return
		}
		logd("没有缓存")
		self.download(url, block)
	}

	func download(_ url: String, _ block: @escaping (File?) -> Void) {
		logd("下载文件")
		self.taskQueue.back {
			self.downSync(url) { u, ok in
				let f = ImageLocal.find(u)
				block(f)
			}
		}
	}

	private func downSync(_ url: String, _ callback: @escaping DownCallback) {
		if var arr = listenMap[url] {
			arr.append(callback)
			listenMap[url] = arr
		} else {
			listenMap[url] = [callback]
		}
		if self.processSet.contains(url) {
			return
		}
		self.processSet.insert(url)
		let filename = Date.tempFileName
		let file = ImageLocal.makeFile(filename)
		let ok = httpDown(url, file)
		if ok {
			ImageLocal.put(url, filename)
		} else {
			file.remove()
		}
		self.processSet.remove(url)
		Task.fore {
			let ls: [DownCallback]? = self.listenMap[url]
			self.listenMap.removeValue(forKey: url)
			if ls != nil {
				for l in ls! {
					l(url, ok)
				}
			}
		}
	}

	private func httpDown(_ url: String, _ file: File) -> Bool {
		guard let u = URL(string: url) else {
			return false
		}
		if url.count < 8 {
			return false
		}
		let r = HttpGet(url: u).requestSync()
		//let r = Http(url).get()
		if !r.OK {
			return false
		}
		guard let data = r.content else {
			return false
		}
		file.writeData(data: data)
		return file.isFile
	}

	func lock(_ obj: Any, _ block: BlockVoid) {
		objc_sync_enter(obj)
		block()
		objc_sync_exit(obj)
	}

}

fileprivate let FileDownloader: _FileDownloader = _FileDownloader()

public extension UIImageView {
	fileprivate var _httpUrl: String? {
		get {
			return getAttr("__httpurl__") as? String
		}
		set {
			setAttr("__httpurl__", newValue)
		}
	}

	func loadUrl(_ url: String, _ finishCallback: @escaping (UIImageView) -> Void = { a in
	}) {
		HttpImage(url).display(self, finishCallback)
	}
}

public class HttpImage {
	public let url: String
	private var opt = ImageOption()

	public weak var imageView: UIImageView? = nil

	public init(_ url: String) {
		self.url = url
	}
}

public extension HttpImage {

	func opt(_ op: ImageOption) -> HttpImage {
		self.opt = op
		return self
	}

	func image(_ block: @escaping (UIImage?) -> Void) {
		if opt.forceDownload {
			FileDownloader.download(url) { file in
				if let d = file?.readData() {
					block(UIImage(data: d))
				} else {
					block(nil)
				}
			}
		} else {
			FileDownloader.retrive(url) { file in
				if let d = file?.readData() {
					block(UIImage(data: d))
				} else {
					block(nil)
				}
			}
		}
	}

	func display(_ view: UIImageView, _ finishCallback: @escaping (UIImageView) -> Void = { a in
	}) {
		view._httpUrl = url
		self.imageView = view
		self.image { img in
			let iv = self.imageView
			if iv != nil {
				self.setupImage(img, iv!, finishCallback)
			}
		}
	}

	private func setupImage(_ img: UIImage?, _ iv: UIImageView, _ finishCallback: @escaping (UIImageView) -> Void = { a in
	}) {
		if iv._httpUrl != self.url {
			return
		}
		if img != nil {
			iv.image = img
		} else if !self.opt.failedImage.isEmpty {
			iv.image = UIImage(named: opt.failedImage)
		} else {
			iv.image = nil
		}
		finishCallback(iv)
	}

	static func batch(_ lsUrl: [String], _ callback: @escaping ([UIImage]) -> Void) {
		self.batch(lsUrl, ImageOption(), callback)
	}

	static func batch(_ lsUrl: [String], _ opt: ImageOption, _ callback: @escaping ([UIImage]) -> Void) {
		var lsImg = [UIImage?]()
		if lsUrl.isEmpty {
			callback(lsImg.compactMap({ $0 }))
		}
		for url in lsUrl {
			HttpImage(url).opt(opt).image { img in
				logd("http image: ", img == nil)
				lsImg.append(img)
				if lsImg.count == lsUrl.count {
					logd("batch callback ")
					callback(lsImg.compactMap({ $0 }))
				}
			}
		}
	}

}
