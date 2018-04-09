//
//  Player.swift
//  Munchkin Assistant
//
//  Created by Erik Tholen on 2018-03-10.
//  Copyright © 2018 Erik Tholen. All rights reserved.
//

import UIKit

let playerImages:[String] = ["cartman", "kenny", "kyle", "stan"]

protocol PlayerSelectedDelegate {
  func didSelectPlayer(player: PlayerView)
}

class PlayerView: UIView {
  var container: UIView!
  
  var playerImage: UIImageView!
  var imageCenterOrigin: CGPoint!
  
  var nameLabel: UILabel!
  var levelLabel: UILabel!
  var combatPowerLabel: UILabel!
  
  var player: Player!
  
  var playerSelectedDelegate: PlayerSelectedDelegate!
  
  init(containerView: UIView, event: UITapGestureRecognizer) {
    let randomIndex = Int(arc4random_uniform(UInt32(playerImages.count)))
    
    // Create image
    let image = UIImageView(image: UIImage(named: "player-\(playerImages[randomIndex])"))
    
    // Create labels
    nameLabel = UILabel()
    levelLabel = UILabel()
    combatPowerLabel = UILabel()
    
    // Set instance vars
    container = containerView
    playerImage = image
    player = Player(name: playerImages[randomIndex].capitalized)
    
    // Setup labels
    nameLabel.text = player.getName()
    nameLabel.font = UIFont(name: "Chalkduster", size: 20)
    nameLabel.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    
    levelLabel.text = String(player.getLevel())
    levelLabel.font = UIFont(name: "Chalkduster", size: 16)
    levelLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    combatPowerLabel.text = String(player.getTotalCombatPower())
    combatPowerLabel.font = UIFont(name: "Chalkduster", size: 20)
    combatPowerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let tappedLocation = event.location(in: containerView)
  
    let imagePadding: CGFloat = 10
    let labelHeight: CGFloat = 25
    let labelWidth: CGFloat = 15
    
    let frameWidth = (image.frame.width + imagePadding) + (labelWidth * 2)
    let frameHeight = (image.frame.height + imagePadding) + (labelHeight)
    let xPos = tappedLocation.x - frameWidth/2
    let yPos = tappedLocation.y - frameHeight/2
    
    let playerFrame = CGRect(
      x: xPos,
      y: yPos,
      width: frameWidth,
      height: frameHeight
    )
    
    // Prevent frame from going out of view bounds
    //playerFrame = getNonIntersectingFrameAt(point: tappedLocation, forFrame: playerFrame, inFrame: containerView.frame)
    
    super.init(frame: playerFrame)
    
    // Debug
    //borderColor = .red
    //borderWidth = 1
    
    // Add to view
    addSubview(image)
    addSubview(nameLabel)
    addSubview(levelLabel)
    addSubview(combatPowerLabel)
  
    containerView.addSubview(self)
    clipsToBounds = false
    setupConstraints()
    
    // Setup image
    playerImage.center = convert(center, from: superview!)
    playerImage.center = CGPoint(x: playerImage.center.x, y: playerImage.center.y + labelHeight/2)
    imageCenterOrigin =  playerImage.center
    
    setupGestureRecognizer()
    isHidden = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: Instance methods
  func getModel() -> Player {
    return self.player
  }
  
  // MARK: Setup functions
  private func setupConstraints() {
    // Add constraints to labels
    let labelTarget = self
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.centerXAnchor.constraint(equalTo: labelTarget.centerXAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: labelTarget.topAnchor, constant: 0).isActive = true
    
    levelLabel.translatesAutoresizingMaskIntoConstraints = false
    levelLabel.centerYAnchor.constraint(equalTo: labelTarget.centerYAnchor).isActive = true
    levelLabel.rightAnchor.constraint(equalTo: labelTarget.leftAnchor, constant: 12).isActive = true
    
    combatPowerLabel.translatesAutoresizingMaskIntoConstraints = false
    combatPowerLabel.centerYAnchor.constraint(equalTo: labelTarget.centerYAnchor).isActive = true
    combatPowerLabel.leftAnchor.constraint(equalTo: labelTarget.rightAnchor, constant: -12).isActive = true
  }
  private func setupGestureRecognizer() {
    let playerTapped = UITapGestureRecognizer(target: self, action: #selector(onPlayerTapped(_:)))
    self.addGestureRecognizer(playerTapped)
    self.isUserInteractionEnabled = true
  }
  
  // MARK: Interaction functions
  @IBAction private func onPlayerTapped(_ sender: UITapGestureRecognizer) {
    playerSelectedDelegate.didSelectPlayer(player: self)
    runGrowShrinkAnimation()
    runDisappearAnimation()
  }
  
  // MARK: - Animations
  // Initial appear animation
  private func runAppearAnimation() {
    // Is applied to entire UIView
    let target = self
    isHidden = false
    // Start of "invisible"...
    target.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    
    // Label prep
    let labels: [UILabel] = [nameLabel, levelLabel, combatPowerLabel]
    for label in labels {
      label.layer.opacity = 1
    }
    // Image prep
    playerImage.center = imageCenterOrigin
    
    UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
      // ...grow past 1:1 quickly...
      target.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
    }, completion: { finished in
      UIView.animate(withDuration: 0.05, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        // ...then go back to 1:1!
        target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
      })
    })
  }
  
  // Grow/Shrink animation
  private func runGrowShrinkAnimation() {
    let target = playerImage!
    UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      // Grow past 1:1...
      target.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
    }, completion: { finished in
      UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        // ... then go back to 1:1!
        target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
      })
    })
  }
  
  // Disappear animation
  private func runDisappearAnimation() {
    // Label animations
    let labels: [UILabel] = [nameLabel, levelLabel, combatPowerLabel]
    UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
      // Hide the labels
      for label in labels {
        label.layer.opacity = 0
      }
    })
    
    // Image animations
    let target = playerImage!
    UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      // Go a bit to the right....
      target.center = CGPoint(x: target.center.x + 15, y: target.center.y)
    }, completion: { finished in
      UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        // ... then go all the way to the left!
        target.center = CGPoint(x: -target.superview!.convert(target.center, to: nil).x, y: target.center.y)
      })
    })
  }
}

extension PlayerView: PlayerDetailDelegate {
  func playerDetailDismissed() {
    self.levelLabel.text? = String(self.player.getLevel())
    self.combatPowerLabel.text? = String(self.player.getTotalCombatPower())
    self.nameLabel.text? = self.player.getName()
    runAppearAnimation()
  }
}
