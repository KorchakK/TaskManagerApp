//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by Konstantin Korchak on 19.04.2022.
//

import UIKit

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
        showAlert("New task")
    }
    
    private func saveTask(_ text: String) {
        StorageManager.shared.saveNewTaskContext(text)
        tasks = StorageManager.shared.fetchTasks()
        
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
    
    // MARK: - AlertControllerSetup
    private func showAlert(_ title: String) {
        let alert = UIAlertController(
            title: title,
            message: "What do you want to do",
            preferredStyle: .alert
        )
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textTask = alert.textFields?.first?.text, !textTask.isEmpty else { return }
            self.saveTask(textTask)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New task"
        }
        
        present(alert, animated: true)
    }
}

// MARK: - TableSetup
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            StorageManager.shared.deleteTaskContext(self.tasks[indexPath.row])
            self.tasks = StorageManager.shared.fetchTasks()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
