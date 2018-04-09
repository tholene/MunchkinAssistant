//
//  PlayerController.swift
//  Munchkin Assistant
//
//  Created by Erik Tholen on 2018-03-10.
//  Copyright © 2018 Erik Tholen. All rights reserved.
//

import UIKit

protocol PlayerDetailDelegate {
  func playerDetailDismissed()
}

protocol PlayerRemovedDelegate {
  func playerRemoved(player: PlayerView)
}

class PlayerController: UIViewController {
  var player: PlayerView!
  
  @IBOutlet weak var playerImage: UIImageView!
  @IBOutlet weak var playerNameField: UITextField!
  @IBOutlet weak var playerLevel: UILabel!
  @IBOutlet weak var playerPower: UILabel!
  @IBOutlet weak var editNameButton: UIButton!
  
  var playerDetailDelegate: PlayerDetailDelegate!
  var playerRemovedDelegate: PlayerRemovedDelegate!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    runAppearAnimation()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    if let player = player {
      self.playerDetailDelegate = player
      
      playerImage.image = player.playerImage.image
      playerImage.layer.opacity = 0
      
      playerNameField.text? = player.getModel().getName()
      playerLevel.text? = String(player.getModel().getLevel())
      playerPower.text? = String(player.getModel().getPower())
    }
  }
  
  // MARK: Button handlers
  @IBAction func donePressed() {
    runDisappearAnimation {
      self.playerDetailDelegate.playerDetailDismissed()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func removePressed() {
    let alert = UIAlertController(title: "Delete player?", message: "Are you sure?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { result in
      self.runDisappearAnimation {
        self.playerRemovedDelegate.playerRemoved(player: self.player!)
        self.dismiss(animated: true, completion: nil)
      }
    }))
    
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  @IBAction func startEditName() {
    if playerNameField.isEnabled {
      endEditName()
    } else {
      playerNameField.isEnabled = true
      playerNameField.becomeFirstResponder()
      editNameButton.setTitle("Done", for: UIControlState.normal)
    }
  }
  
  @IBAction func endEditName() {
    playerNameField.isEnabled = false
    playerNameField.resignFirstResponder()
    player.getModel().setName(playerNameField.text ?? "")
    editNameButton.setTitle("Edit Name", for: UIControlState.normal)
  }
  
  // Level
  @IBAction func decrementLevel() {
    self.player.getModel().goDownALevel()
    self.playerLevel.text? = String(player.getModel().getLevel())
  }
  
  @IBAction func incrementLevel() {
    self.player.getModel().goUpALevel()
    self.playerLevel.text? = String(player.getModel().getLevel())
  }
  
  // Power
  @IBAction func decrementPower() {
    self.player.getModel().removePower()
    self.playerPower.text? = String(player.getModel().getPower())
  }
  
  @IBAction func incrementPower() {
    self.player.getModel().addPower()
    self.playerPower.text? = String(player.getModel().getPower())
  }
  
  private func runAppearAnimation() {
    let playerCenter = playerImage.center
    playerImage.layer.position = CGPoint(x: -100, y: playerCenter.y)
    playerImage.layer.opacity = 1
    UIImageView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.playerImage.center = CGPoint(x: playerCenter.x + 15, y: playerCenter.y)
    }, completion: { finished in
      UIImageView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut,animations: {
        self.playerImage.center = CGPoint(x: playerCenter.x, y: playerCenter.y)
      })
    })
  }
  
  private func runDisappearAnimation(_ completionHandler: @escaping () -> Void) {
    let target = playerImage!
    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      // Go a bit to the right....
      target.center = CGPoint(x: target.center.x + 15, y: target.center.y)
    }, completion: { finished in
      UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        // ... then go all the way to the left!
        target.center = CGPoint(x: -target.superview!.convert(target.center, to: nil).x, y: target.center.y)
      }, completion: { finished in
        completionHandler()
      })
    })
  }
  
}
