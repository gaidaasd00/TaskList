//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 07.09.2022.
//

import UIKit

class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
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
        let newTaksViewController = TaskViewController()
        present(newTaksViewController, animated: true)
    }
}

