//
//  RecordViewActions.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

enum RecordViewAction {
    case newRecordAdded(record: Record)
    case setRecords(records: [Record])
    case setAddRecordFormPresentStatus(isPresent: Bool)
}

struct RecordViewReducer {
    let reducer: Reducer<RecordViewState, RecordViewAction> = Reducer { state, action in
        switch action {
        case let .setAddRecordFormPresentStatus(isPresent):
            state.addRecordFormPresented = isPresent
        case let .setRecords(records):
            state.records = records
        case let .newRecordAdded(record):
            state.addRecordFormPresented = false
            state.records.insert(record, at: 0)
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
