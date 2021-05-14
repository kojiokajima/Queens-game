//
//  MenuViewController.swift
//  Queens-game
//
//  Created by 杉原大貴 on 2021/04/27.
//

import UIKit

class MenuViewController: UIViewController {

  let screenTitle: H2Label = {
    let lb = H2Label(text: "Menu")
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.lineBreakMode = .byWordWrapping
    lb.numberOfLines = 0
    lb.setContentHuggingPriority(.required, for: .vertical)
    return lb
  }()

  let closeButton: UIButton = {
    let bt = UIButton()
    bt.translatesAutoresizingMaskIntoConstraints = false
    bt.setTitle("Close", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.titleLabel?.font = CustomFont.p
    bt.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
    return bt
  }()

  
  let howToPlayButton: MainButton = {
    let bt = MainButton()
    bt.setTitle("How to Palay", for: .normal)
    bt.addTarget(self, action: #selector(howToPlayTapped(_:)), for: .touchUpInside)
    return bt
  }()
  
  let settingButton: MainButton = {
    let bt = MainButton()
    bt.setTitle("Settings", for: .normal)
    bt.addTarget(self, action: #selector(settingTapped(_:)), for: .touchUpInside)
    return bt
  }()
  
  let goToTopButton: MainButton = {
    let bt = MainButton()
    bt.setTitle("Go to Top", for: .normal)
    bt.addTarget(self, action: #selector(goToTop(_:)), for: .touchUpInside)
    return bt
  }()

  let privacyPolicyButton: SubButton = {
    let bt = SubButton()
    bt.setTitle("Privacy policy", for: .normal)
    bt.titleLabel?.font = CustomFont.p
    bt.addTarget(self, action: #selector(privacyPolicyTapped(_:)), for: .touchUpInside)
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
      ]
    )
    sv.alignment = .fill
    sv.distribution = .equalSpacing
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }

}

extension MenuViewController {

  private func setupLayout() {
    view.configBgColor(bgColor: CustomColor.background)

    view.addSubview(stackView)
    stackView.topAnchor.constraint(
      equalTo: view.topAnchor,
      constant: Constant.Common.topSpacing
    ).isActive = true
    stackView.bottomAnchor.constraint(
      equalTo: view.bottomAnchor,
      constant: Constant.Common.bottomSpacing
    ).isActive = true
    stackView.leadingAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.leadingAnchor,
      constant: Constant.Common.leadingSpacing
    ).isActive = true
    stackView.trailingAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.trailingAnchor,
      constant:  Constant.Common.trailingSpacing
    ).isActive = true

  }

  @objc func goToTop(_ sender: UIButton) {
    let nx = ExitAlertViewController()
    present(nx, animated: true, completion: nil)
  }

  @objc func settingTapped(_ sender: UIButton) {
    let nx = SettingsViewController()
    let navigationController = UINavigationController(rootViewController:nx)
    present(navigationController, animated: true, completion: nil)
  }

  @objc func closeTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  @objc func howToPlayTapped(_ sender: UIButton) {
    let nx = RuleBookViewController()
    present(nx, animated: true, completion: nil)
  }

  @objc func privacyPolicyTapped(_ sender: UIButton) {

  }
}
