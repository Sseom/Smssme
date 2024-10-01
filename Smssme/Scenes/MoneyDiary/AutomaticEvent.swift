//
//  AutomaticState.swift
//  Smssme
//
//  Created by KimRin on 10/1/24.
//

import Foundation

enum AutomaticEvent {
    case onSaveComplete(String, String)
    case onSaveFail(String, String)
}
