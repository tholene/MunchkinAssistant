//
//  ViewController.swift
//  Munchkin Assistant
//
//  Created by Erik Tholen on 2018-03-10.
//  Copyright © 2018 Erik Tholen. All rights reserved.
//

import UIKit

class TableController: UIViewController {
  
  @IBOutlet weak var tableLabel: UILabel!
  
  // Table position views
  @IBOutlet weak var playArea: UIView!
  @IBOutlet weak var aboveTable: UIView!
  @IBOutlet weak var rightOfTable: UIView!
  @IBOutlet weak var belowTable: UIView!
  @IBOutlet weak var leftOfTable: UIView!
  
  var players: [PlayerView] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let playerController = segue.destination as? PlayerController {
      playerController.player = sender as? PlayerView
      playerController.playerRemovedDelegate = self
    }
  }
  
  // MARK: - Table Taps
  @IBAction func onTapInPlayArea(_ sender: UITapGestureRecognizer) {
    let playerAreas = [aboveTable, rightOfTable, belowTable, leftOfTable]
    let point = sender.location(in: playArea)
    let didTapInValidArea = playerAreas.map { area in area!.frame.contains(point) }.contains(true)
    if didTapInValidArea {
      let areaTappedIn = playerAreas.filter { area in area!.frame.contains(point) }[0]!
      let playersInArea = getPlayersInArea(areaTappedIn).count
      
      if playersInArea < 3 {
        self.addPlayer(view: self.playArea, event: sender)
        
        if playersInArea == 2 {
          areaTappedIn.borderColor = UIColor.init(white: 1, alpha: 0)
        }
      }
    }
  }
  
  
  private func addPlayer(view: UIView, event: UITapGestureRecognizer) {
    let player = PlayerView(containerView: view, event: event)
    player.playerSelectedDelegate = self
    
    view.addSubview(player)
    
    players.append(player)
    
    self.didSelectPlayer(player: player)
  }
  
  private func getPlayersInArea(_ view: UIView) -> [PlayerView] {
    var players:[PlayerView] = []
    for subView in playArea.subviews {
      if let playerView = subView as? PlayerView {
        if view.frame.contains(playerView.center) {
          players.append(playerView)
        }
      }
    }
    return players
  }
  
  private func getAreaOfPlayer(_ player: PlayerView) -> UIView {
    let playerAreas = [aboveTable, rightOfTable, belowTable, leftOfTable]
    return playerAreas.filter { area in area!.frame.contains(player.center) }[0]!
  }
}

extension TableController: PlayerSelectedDelegate {
  func didSelectPlayer(player: PlayerView) {
    performSegue(withIdentifier: "showPlayer", sender: player)
  }
}

extension TableController: PlayerRemovedDelegate {
  func playerRemoved(player: PlayerView) {
    let areaOfPlayer = getAreaOfPlayer(player)
    if let index = players.index(of: player) {
      player.removeFromSuperview()
      players.remove(at: index)
      
      if getPlayersInArea(areaOfPlayer).count < 3 {
        let enabledColor = UIColor.init(red: 0.498941, green: 0.383765, blue: 0.245981, alpha: 1)
        areaOfPlayer.borderColor = enabledColor
      }
    }
  }
}
