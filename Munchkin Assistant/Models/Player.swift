//
//  Player.swift
//  Munchkin Assistant
//
//  Created by Erik Tholen on 2018-03-10.
//  Copyright © 2018 Erik Tholen. All rights reserved.
//

import Foundation

class Player {
  var name: String
  private var level: Int
  private var power: Int

  init(name: String, level: Int = 1, power: Int = 1) {
    self.name = name
    self.level = level
    self.power = power
  }

  func goUpALevel() {
    self.level += 1
  }

  func goDownALevel() {
    self.level -= 1
  }

  func getLevel() -> Int {
    return self.level
  }

  func getPower() -> Int {
    return self.power
  }

  func getTotalCombatPower() -> Int {
    return self.level + self.power
  }
}
