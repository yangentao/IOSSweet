//
// Created by yangentao on 2019/11/4.
// Copyright (c) 2019 yangentao. All rights reserved.
//

import Foundation

public class FileX {
	let handle: FileHandle

	fileprivate init(handle: FileHandle) {
		self.handle = handle
	}

	deinit {
		handle.closeFile()
		println("FileX closed")
	}

	var availableData: Data {
		self.handle.availableData
	}

	func write(data: Data) {
		self.handle.write(data)
	}

	func readData() -> Data {
		self.handle.readDataToEndOfFile()
	}

	func readData(length: Int) -> Data {
		self.handle.readData(ofLength: length)
	}

	var offsetInFile: UInt64 {
		self.handle.offsetInFile
	}

	func seekEnd() -> ULong {
		self.handle.seekToEndOfFile()
	}

	func seek(to n: ULong) {
		self.handle.seek(toFileOffset: n)
	}

	@available(iOS 13.0, *)
	func seek(offset: UInt64) throws {
		try self.handle.seek(toOffset: offset)
	}

	static func open(reading: URL) throws -> FileX {
		do {
			return FileX(handle: try FileHandle(forReadingFrom: reading))
		} catch {
			Log.error(error.localizedDescription)
			throw error
		}
	}

	static func open(writing: URL) throws -> FileX {
		do {
			return FileX(handle: try FileHandle(forWritingTo: writing))
		} catch {
			Log.error(error.localizedDescription)
			throw error
		}
	}
}

extension FileX {
	func readText(_ enc: String.Encoding) -> String? {
		String(data: self.readData(), encoding: enc)
	}

	func readText() -> String? {
		String(data: self.readData(), encoding: .utf8)
	}

	func write(text: String) {
		self.write(data: text.dataUtf8)
	}

	func write(text: String, encoding: String.Encoding) {
		if let d = text.data(using: encoding) {
			self.write(data: d)
		} else {
			Log.error("text to data failed", #file, #function)
		}
	}
}