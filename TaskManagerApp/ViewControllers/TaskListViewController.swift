//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by Konstantin Korchak on 19.04.2022.
//

import UIKit

protocol TaskListViewDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    
    private let cellId = "task"
    private var tasks = StorageManager.shared.fetchTasks()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.backgroundColor = .white
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Task list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let naviBarAppearance = UINavigationBarAppearance()
        naviBarAppearance.configureWithOpaqueBackground()
        naviBarAppearance.backgroundColor = UIColor(
            red: 90/255,
            green: 255/255,
            blue: 130/255,
            alpha: 0.9
        )
        naviBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        naviBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        
        navigationController?.navigationBar.standardAppearance = naviBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = naviBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskButtonPressed)
        )
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }
    
    @objc private func addTaskButtonPressed() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        present(addTaskVC, animated: true)
    }
}

// MARK: - DelegateSetup
extension TaskListViewController: TaskListViewDelegate {
    func reloadData() {
        tasks = StorageManager.shared.fetchTasks()
        tableView.reloadData()
    }
}

// MARK: - ButtonPressedSetup
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.taskTitle
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
