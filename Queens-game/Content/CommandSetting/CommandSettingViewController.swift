//
//  CommandSettingViewController.swift
//  Queens-game
//
//  Created by Takayuki Yamaguchi on 2021-05-12.
//

import UIKit

class CommandSettingViewController: CommonCommandViewController {
  
  let addButton: UIButton = {
    let bt = UIButton()
    bt.configLayout(width: 48, height: 48, bgColor: CustomColor.main, radius: 20)
    bt.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
    bt.tintColor = CustomColor.background
    bt.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    return bt
  } ()
  
  override func viewDidLoad() {
    bottomNavigationBar.addArrangedSubview(addButton)
    headerTitle = "Edit commands"
    super.viewDidLoad()
  }
  
  @objc func addButtonTapped() {
    let nextVC = CommandEditViewController(viewModel: viewModel)
    // Pass no editing command == create item.
    viewModel.updateEditMode()
    present(nextVC, animated: true, completion: { [unowned self] in
      // If you don't set this, buttons on presented view won't respond
      self.searchBar.resignFirstResponder()
    })
  }
  
  override func configBinding() {
    super.configBinding()
    
    // If #item reach max, disable add button.
    viewModel.didReachMaxItemSubject
      .bind(to: addButton.rx.isHidden)
      .disposed(by: viewModel.disposeBag)
    
  }
  
}

extension CommandSettingViewController {
  // If cell is tapped
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let nextVC = CommandEditViewController(viewModel: viewModel)
    // Pass selected command's position(index) to view model.
    viewModel.updateEditMode(index: indexPath.row)
    present(nextVC, animated: true, completion: { [unowned self] in
      // If you don't set this, buttons on presented view won't respond
      self.searchBar.resignFirstResponder()
    })
  }
  
}
