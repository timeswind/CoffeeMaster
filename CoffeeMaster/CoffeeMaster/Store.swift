//
//  Store.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

protocol Effect {
    associatedtype Action
    func mapToAction() -> AnyPublisher<Action, Never>
}

struct Reducer<State, Action> {
    let reduce: (inout State, Action) -> Void
}

final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let appReducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, appReducer: Reducer<State, Action>) {
        self.state = initialState
        self.appReducer = appReducer
    }

    func send(_ action: Action) {
        appReducer.reduce(&state, action)
    }

    func send<E: Effect>(_ effect: E) where E.Action == Action {
        effect
            .mapToAction()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
