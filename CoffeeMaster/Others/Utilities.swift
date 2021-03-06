//
//  Utilities.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import CryptoKit

class Utilities: NSObject {
        
    static func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if length == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    static func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    static func gramToOunce(gram: Double) -> Double {
        return gram * 0.03527396195
    }
    
    static func OunceToGram(ounce: Double) -> Double {
        return ounce / 0.03527396195
    }
    
    static func CelsiusToFahrenheit(celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
    static func FahrenheitToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / (9/5)
    }
    
    static func convertTimestamp(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium

        return formatter.string(from: date as Date)
    }
    
    static func convertTimestampShort(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return formatter.string(from: date as Date)
    }
}
