//
//  AddTaskViewController.swift
//  TaskManagerApp
//
//  Created by Konstantin Korchak on 19.04.2022.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: TaskListViewDelegate!
    
    private lazy var navBar: UINavigationBar = {
        navBarSetup()
    }()
    
    private lazy var addTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task text"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var customNavigationItem: UINavigationItem = {
        naviItemSetup()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(navBar, addTextField)
        setupConstraints()
        addTextField.delegate = self
    }
    
// MARK: - SubviewSetup
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        addTextField.translatesAutoresizingMaskIntoConstraints = false
        let frameWirth = view.frame.width
        NSLayoutConstraint.activate([
            addTextField.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 13),
            addTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTextField.widthAnchor.constraint(equalToConstant: frameWirth * 0.8)
        ])
    }
    
    private func navBarSetup() -> UINavigationBar {
        let navBar = UINavigationBar(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: 44
        ))
        navBar.setItems([customNavigationItem], animated: false)
        
        return navBar
    }
    
    private func naviItemSetup() -> UINavigationItem {
        let navigationItem = UINavigationItem(title: "Add your task")
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonPressed)
        )
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
        cancelButton.tintColor = .red
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = cancelButton
        
        return navigationItem
    }
    
// MARK: - ButtonPressedSetup
    
    @objc private func doneButtonPressed() {
        guard let addTextFieldText = addTextField.text else { return }
        StorageManager.shared.saveNewTaskContext(addTextFieldText)
        delegate.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
}

// MARK: - DoneButtonSetup

extension AddTaskViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else { return false }
        
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            customNavigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            customNavigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        return true
    }
}

