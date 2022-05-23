//
//  Handlers.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/21/22.
//

import Foundation

typealias ActionHandler = (_ status: Bool, _ message: String) -> ()

typealias CompletionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()

typealias CompletionHandlerWithData = (_ status: Bool, _ code: Int, _ message: String, _ data: Any?) -> ()

typealias CompletionHandlerWithKeyValueData = (_ status: Bool, _ code: Int, _ message: String, _ keys: Any?, _ data: Any?) -> ()

typealias CompletionHandlerWithStatusCode = (_ status: Bool, _ message: String, _ code: Int) -> ()
typealias CompletionHandlerWithStatusCodeAndData = (_ status: Bool, _ message: String, _ code: Int, _ data: Any?) -> ()
typealias FileDownloadHandler = (_ status: Bool, _ message: String, _ url: String?) -> ()

func delay(_ delay: Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}




