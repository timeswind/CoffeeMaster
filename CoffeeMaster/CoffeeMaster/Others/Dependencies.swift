//
//  Dependencies.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

struct Dependencies {
    var githubService: GithubService
}

let dependencies = Dependencies(githubService: GithubService())
