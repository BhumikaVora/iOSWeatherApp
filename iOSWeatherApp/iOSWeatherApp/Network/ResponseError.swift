//
//  ResponseError.swift
//  Created by Bhumika on 29/08/23.
//

import Foundation

enum ResponseError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
