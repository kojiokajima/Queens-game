//
//  QueenSelectedViewController.swift
//  Queens-game
//
//  Created by 杉原大貴 on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa

class QueenSelectedViewController: UIViewController, QueensGameViewControllerProtocol {
  
  lazy var backgroundCreator: BackgroundCreator = BackgroundCreatorPlain(parentView: view)

  let disposeBag = DisposeBag()
  let viewModel = QueenSelectedViewModel()

  
  // MARK: - First half views
  
  lazy var countdownStackView = CountdownStackView(
    countdown: self.viewModel.countdownTime
  )

  let screenTitle: H2Label = {
    let lb = H2Label(text: "Selecting the Queen...")
    lb.lineBreakMode = .byWordWrapping
    return lb
  }()

  let skipButton: SubButton = {
    let button = SubButton()
    button.setTitle("Skip", for: .normal)
    button.addTarget(self, action: #selector(skipButtonTapped(_:)), for: .touchUpInside)
    return button
  }()

  lazy var firstHalfStackView: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [
        screenTitle,
        countdownStackView,
        skipButton
      ]
    )
    sv.alignment = .fill
    sv.distribution = .equalSpacing
    return sv
  }()

  
  // MARK: Last half views (After Countdown)

  let afterTitle: H2Label = {
    let lb = H2Label(text: "The Queen is")
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.lineBreakMode = .byWordWrapping
    return lb
  }()
    
  lazy var queenIcon: UIImageView = {
    let icon = IconFactory.createImageView(
      type: .queen,
      height: 152
    )
    return icon
  }()
  
  lazy var noLabel: H2Label = {
    let label = H2Label(text: "No.")
    label.textColor = CustomColor.accent
    label.textAlignment = .right
    return label
  }()
  
  lazy var targetIcon: UIImageView = {
    let icon = IconFactory.createImageView(
      type: .userId(GameManager.shared.queen!.playerId),
      width: 64
    ) as! UserIdIconView
    icon.label.textColor = CustomColor.accent
    return icon
  }()

  lazy var queenName: H2Label = {
    let label = H2Label(text: GameManager.shared.queen!.name)
    label.textAlignment = .center
    label.textColor = CustomColor.accent
    return label
  }()
  
  lazy var hStackView: HorizontalStackView = {
    let sv = HorizontalStackView(
      arrangedSubviews: [self.noLabel, targetIcon]
    )
    sv.distribution = .equalSpacing
    sv.alignment = .center
    sv.spacing = 16
    sv.setContentHuggingPriority(.required, for: .vertical)
    return sv
  }()
    
  lazy var queenBlock: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [self.queenIcon, self.hStackView, self.queenName]
    )
    sv.alignment = .center
    sv.spacing = 32
    sv.setCustomSpacing(24, after: hStackView)
    
    // Set negative padding. This is to crop image.
    sv.isLayoutMarginsRelativeArrangement = true
    sv.directionalLayoutMargins = .init(top: -40, leading: 0, bottom: 0, trailing: 0)

    return sv
  }()
  
  let nextButton: MainButton = {
    let button = MainButton()
    button.setTitle("Next", for: .normal)
    button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var lastHalfStackView: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [self.afterTitle, self.queenBlock, self.nextButton],
      alignment: .center,
      distribution: .equalSpacing
    )
    return sv
  } ()

  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundCreator.configureLayout()
    setupLayout()
    self.viewModel.countdown()
    self.viewModel.rxCountdownTime
      .subscribe(onNext: { [weak self] time in
        self?.countdownStackView.countdownLabel.text = String(time!)
      },
      onCompleted: {
        self.replaceView()
      })
      .disposed(by: disposeBag)
  }

  private func setupLayout() {

    firstHalfStackView.configSuperView(under: view)
    firstHalfStackView.matchParent(
      padding: .init(
        top: Constant.Common.topSpacing,
        left: Constant.Common.leadingSpacing,
        bottom: Constant.Common.bottomSpacing,
        right: Constant.Common.trailingSpacing
      )
    )
  }

  private func setupLayoutAfterCountdown() {
    
    lastHalfStackView.configSuperView(under: super.view)
    lastHalfStackView.matchParent(
      padding: .init(
        top: Constant.Common.topSpacing,
        left: Constant.Common.leadingSpacing,
        bottom: Constant.Common.bottomSpacing,
        right: Constant.Common.trailingSpacing
      )
    )
  }
  
  private func replaceView() {
    self.firstHalfStackView.removeFromSuperview()
    
    // Set up, but make last half views invisible
    lastHalfStackView.alpha = 0
    self.setupLayoutAfterCountdown()
    
    // Fade in the last half views
    UIView.animate(
      withDuration: 1.8,
      delay: 0,
      options: .curveEaseIn,
      animations: { [weak self] in
        self?.lastHalfStackView.alpha = 1
      },
      completion: nil
    )
    
  }
  
  @objc func skipButtonTapped(_ sender: UIButton) {
    self.viewModel.rxCountdownTime.onCompleted()
  }
  
  @objc func nextButtonTapped(_ sender: UIButton) {
    self.goToNext()
  }

  private func goToNext() {
    let nx = CommandSelectionViewController()
    GameManager.shared.pushGameProgress(
      navVC: navigationController,
      currentScreen: self,
      nextScreen: nx
    )
  }
}
