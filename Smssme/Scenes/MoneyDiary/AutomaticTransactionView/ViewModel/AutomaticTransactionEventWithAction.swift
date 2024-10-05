//
//  AutomaticTransactionEventWithAction.swift
//  Smssme
//
//  Created by KimRin on 10/4/24.
//

import Foundation

enum AutomaticTransactionAction {
    case onsave(String?)

}

enum AutomaticTransactionEvent {
    case onSaveComplete(String, String)
    case onSaveFail(String, String)
}


