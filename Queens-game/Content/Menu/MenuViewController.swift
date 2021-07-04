//
//  MenuViewController.swift
//  Queens-game
//
//  Created by 杉原大貴 on 2021/04/27.
//

import UIKit

class MenuViewController: UIViewController {
  
  let viewModel = MenuViewModel()
  
  let screenTitle: H2Label = {
    let lb = H2Label(text: "Menu")
    lb.setContentHuggingPriority(.required, for: .vertical)
    lb.textAlignment = .center
    return lb
  }()
  
  let howToPlayButton: MainButton = {
    let bt = MainButton()
    bt.configRadius(radius: 28)
    bt.setTitle("How to Play", for: .normal)
    bt.addTarget(self, action: #selector(howToPlayTapped(_:)), for: .touchUpInside)
    bt.insertIcon(
      IconFactory.createSystemIcon(
        "questionmark.circle",
        color: CustomColor.background,
        pointSize: 17
      ),
      to: .left
    )
    return bt
  }()
  
  let settingButton: MainButton = {
    let bt = MainButton()
    bt.configRadius(radius: 28)
    bt.setTitle("Settings", for: .normal)
    bt.addTarget(self, action: #selector(settingTapped(_:)), for: .touchUpInside)
    bt.insertIcon(IconFactory.createSystemIcon("gear", color: CustomColor.background, pointSize: 16), to: .left)
    return bt
  }()
  
  let goToTopButton: MainButton = {
    let bt = MainButton()
    bt.configRadius(radius: 28)
    let btTintColor = CustomColor.background.resolvedColor(with: .init(userInterfaceStyle: .light))
    bt.setTitle("Back to Top", for: .normal)
    bt.setTitleColor(btTintColor, for: .normal)
    bt.backgroundColor = CustomColor.accent
    bt.addTarget(self, action: #selector(goToTop(_:)), for: .touchUpInside)
    bt.insertIcon(
      IconFactory.createSystemIcon("suit.heart.fill", color: btTintColor, pointSize: 16),
      to: .left
    )
    return bt
  }()
  
  let privacyPolicyButton: SubButton = {
    let bt = SubButton()
    bt.setTitle("Privacy policy", for: .normal)
    bt.setTitleColor(CustomColor.subText, for: .normal)
    bt.backgroundColor = .clear
    bt.titleLabel?.font = CustomFont.p
    bt.addTarget(self, action: #selector(privacyPolicyTapped(_:)), for: .touchUpInside)
    bt.insertIcon(nil, to: .left)
    return bt
  }()
  
  lazy var stackView: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [
        screenTitle,
        howToPlayButton,
        settingButton,
        goToTopButton,
        privacyPolicyButton
      ],
      spacing: 24,
      alignment: .fill
    )
    sv.setCustomSpacing(16, after: goToTopButton)
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.isLayoutMarginsRelativeArrangement = true
    sv.directionalLayoutMargins = .init(top: 32, leading: 40, bottom: 40, trailing: 40)
    
    sv.backgroundColor = UIColor(patternImage: BackgroundImage.image)
    
    sv.layer.cornerRadius = 16
    sv.layer.borderWidth = 3
    sv.layer.borderColor = traitCollection.userInterfaceStyle == .light ? CustomColor.text.withAlphaComponent(0.8).cgColor : CustomColor.subText.cgColor
    return sv
  }()
  
  let alert = UIAlertController(
    title: "Are you sure you want to quit current game ?",
    message:  "",
    preferredStyle:  UIAlertController.Style.alert
  )
  
  lazy var confirmAction = UIAlertAction(
    title: "Yes",
    style: UIAlertAction.Style.default,
    handler: { [weak self] (action: UIAlertAction!) -> Void in
      
      if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
        
        let loadingView = LoadingView()
        loadingView.alpha = 0
        loadingView.frame = window.frame
        loadingView.label.text = "Quitting..."
        window.addSubview(loadingView)
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseInOut) {
          loadingView.alpha = 1
        } completion: { _ in
          GameManager.shared.loadGameProgress(
            to: .home,
            with: self?.viewModel.navigationController
          )
          
          UIView.animate(withDuration: 0.6, delay: 0, options: .beginFromCurrentState) {
            loadingView.icon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
          } completion: { _ in
            self?.dismiss(animated: false, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
              loadingView.alpha = 0
            } completion: { _ in
              loadingView.removeFromSuperview()
            }
          }
        }
        
      }
      
    }
  )
  
  
  let cancelAction = UIAlertAction(
    title: "No",
    style: UIAlertAction.Style.cancel,
    handler: { (action: UIAlertAction!) -> Void in
      print("No")
    }
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    self.alert.addAction(self.cancelAction)
    self.alert.addAction(self.confirmAction)

  }
  
  deinit {
    print("\(Self.self) is being deinitialized")
  }
  
  // This can detect if you touch outside of the content.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Let user to dismiss when tapping out side
    if touches.first?.view == view{
      dismiss(animated: true, completion: nil)
    }
  }
  
}

extension MenuViewController {
  
  private func configureLayout() {
    view.configBgColor(bgColor: .clear)

    goToTopButton.isHidden = viewModel.isTopMenu
    privacyPolicyButton.isHidden = !viewModel.isTopMenu
    
    stackView.configSuperView(under: view)
    stackView.configSize(width: 296)
    stackView.centerXYin(view)
  }
  
  @objc func goToTop(_ sender: UIButton) {
    present(self.alert, animated: true, completion: nil)
  }
  
  @objc func settingTapped(_ sender: UIButton) {
    let nx = SettingsViewController()
    let navigationController = UINavigationController(rootViewController:nx)
    navigationController.navigationBar.isHidden = true
    present(navigationController, animated: true, completion: nil)
  }
  
  @objc func closeTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func howToPlayTapped(_ sender: UIButton) {
    let nx = WebViewViewController(url: "https://daisugi01.github.io/Queens-game/play-guide")
    present(nx, animated: true, completion: nil)
  }
  
  @objc func privacyPolicyTapped(_ sender: UIButton) {
    let nx = WebViewViewController(url: "https://daisugi01.github.io/Queens-game/privacy-policy")
    present(nx, animated: true, completion: nil)
  }
}


