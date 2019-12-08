//
//  RecordViewActions.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum RecordViewAction {
    case newRecordAdded(record: Record)
    case setRecords(records: [Record])
    case setCaffeineEntries(caffeineEntries: [CaffeineEntry])
    case setRecordFormIsPresent(status: Bool)
    case setCaffeineTrackerIsPresent(status: Bool)
}

struct RecordViewReducer {
    let reducer: Reducer<RecordViewState, RecordViewAction> = Reducer { state, action in
        switch action {
        case let .setRecords(records):
            state.records = records
        case let .newRecordAdded(record):
            state.isCaffeineTrackerPresented = false
            state.isAddRecordNoteFormPresented = false
            state.records.insert(record, at: 0)
        case let .setCaffeineEntries(caffeineEntries):
            state.caffeineEntries = caffeineEntries
        case let .setRecordFormIsPresent(status):
            state.isAddRecordNoteFormPresented = status
//            if (status == true) {
//                state.isCaffeineTrackerPresented = false
//            }
        case let .setCaffeineTrackerIsPresent(status):
            print("setCaffeineTrackerIsPresent\(status)")
            state.isCaffeineTrackerPresented = status
//            if (status == true) {
//                state.isAddRecordNoteFormPresented = false
//            }
        }
    }
}

enum RecordViewAsyncAction: Effect {
    case getMyRecords(query: String)
    case addRecord(record: Record)
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .getMyRecords(query):
            return dependencies.webDatabaseQueryService
                .getMyRecords(query: query)
            .replaceError(with: [])
                .map { let recordViewAction: RecordViewAction = .setRecords(records: $0)
                    return AppAction.recordview(action: recordViewAction) }
            .eraseToAnyPublisher()
        case let .addRecord(record):
            return dependencies.webDatabaseQueryService
            .addRecord(record: record)
                .replaceError(with: nil)
                .map {
                    if ($0 != nil) {
                        let recordViewAction: RecordViewAction = .newRecordAdded(record: $0!)
                        return AppAction.recordview(action: recordViewAction)
                    } else {
                        return AppAction.emptyAction(action: .nilAction(nil: true))
                    }
            }
            .eraseToAnyPublisher()
        }
    }
}


let recordViewReducer = RecordViewReducer()
