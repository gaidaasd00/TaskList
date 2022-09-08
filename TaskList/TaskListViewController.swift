//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 07.09.2022.
//

import UIKit

class TaskListViewController: UITableViewController {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let cellId = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
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
        alertController(with: "New Task", andMessage: "What do you wont to do?")
    }
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    private func alertController(with title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            save(task)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style:.destructive)
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    private func save(_ taskName: String) {
        //создание экземпляра модели
        let task = Task(context: viewContext)
        //изменение модели
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        // сохранение в постоянное хранилеще
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}


