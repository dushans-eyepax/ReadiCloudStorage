//
//  StringExtensions.swift
//  ReadiCloudStorage
//
//  Created by Yohan Alahakoon on 2022-08-23.
//

import Foundation

extension String{
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
