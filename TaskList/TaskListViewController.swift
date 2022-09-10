//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 07.09.2022.
//

import UIKit

class TaskListViewController: UITableViewController {
    private let cellId = "cell"
    private var tasks: [Task] = []

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
}
    // работа над внешним видом navigationBar
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApperanse = UINavigationBarAppearance()
        navBarApperanse.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        //работа с цветом текста
        navBarApperanse.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperanse.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperanse
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperanse
        
        //добавление кнопки в бар
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        navigationController?.navigationBar.tintColor = .white
    }
    @objc private func addNewTask() {
       showAlert()
    }
    
    private func save(taskName: String) {
        StoreManager.shared.create(taskName) { [unowned self] task in
            tasks.append(task)
            tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    
    private func fetchData() {
        StoreManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
    //MARK: UITableViewDataSourse
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: UITableViewDelegate
extension TaskListViewController {
    //edit tasks
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    //delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StoreManager.shared.delete(task)
        }
    }
}
    // MARK: AlertController

extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, complition: (() -> Void)? = nil) {
        let title = task != nil ? "Update task" : "New task"
        let alert = UIAlertController.createAlertController(with: title)
        
        alert.action(task: task) { [unowned self] taskName in
            if let task = task, let complition = complition {
                StoreManager.shared.update(task, newName: taskName)
                complition()
            } else {
                self.save(taskName: taskName)
            }
        }
        present(alert, animated: true)
    }
}


