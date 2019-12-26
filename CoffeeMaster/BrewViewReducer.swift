//
//  BrewViewReducer.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum BrewViewAction {
    case newBrewGuideAdded(brewGuide: BrewGuide)
    case setMyBrewGuides(guides: [BrewGuide])
    case setDefaultBrewGuides(guides: [BrewGuide])
    case setDefaultBrewMethods(methods: [BrewMethod])
}

struct BrewViewReducer {
    let reducer: Reducer<BrewViewState,  BrewViewAction> = Reducer { state, action in
        switch action {
        case let.newBrewGuideAdded(brewGuide):
            state.myBrewGuides.insert(brewGuide, at: 0)
        case let .setMyBrewGuides(guides):
            state.myBrewGuides = guides
        case let .setDefaultBrewGuides(guides):
            state.defaultBrewGuides = guides
        case let .setDefaultBrewMethods(methods):
            state.defaultBrewMethods = methods
        }
    }
}

enum BrewViewAsyncAction: Effect {
    case getMyBrewGuides(query: String)
    case createBrewGuide(brewGuide: BrewGuide)

    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .getMyBrewGuides(query):
            return dependencies.webDatabaseQueryService
                .getMyBrewGuides(query: query)
            .replaceError(with: [])
                .map { let brewViewAction: BrewViewAction = .setMyBrewGuides(guides: $0)
                    return AppAction.brewview(action: brewViewAction) }
            .eraseToAnyPublisher()
        case let .createBrewGuide(brewGuide):
            return dependencies.webDatabaseQueryService
            .createBrewGuide(brewGuide: brewGuide)
                .replaceError(with: nil)
                .map {
                    if ($0 != nil) {
                        let brewViewAction: BrewViewAction = .newBrewGuideAdded(brewGuide: $0!)
                        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
                        return AppAction.brewview(action: brewViewAction)
                    } else {
                        return AppAction.emptyAction(action: .nilAction(nil: true))
                    }
            }
            .eraseToAnyPublisher()
        }
    }
}


let brewViewReducer = BrewViewReducer()
