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
  @IBOutlet weak var playerName: UILabel!
  @IBOutlet weak var playerLevel: UILabel!
  @IBOutlet weak var playerPower: UILabel!
  
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
      playerImage.isHidden = true
      
      playerName.text? = player.getModel().name
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
      self.playerRemovedDelegate.playerRemoved(player: self.player!)
      self.dismiss(animated: true, completion: nil)
    }))
    
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  private func runAppearAnimation() {
    let playerCenter = playerImage.center
    playerImage.layer.position = CGPoint(x: -100, y: playerCenter.y)
    playerImage.isHidden = false
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
