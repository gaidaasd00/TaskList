//
//  TaskViewController.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 07.09.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //создание элементов
   private lazy var taskTextField: UITextField = {
        let textF = UITextField()
        textF.borderStyle = .roundedRect
        textF.placeholder = "New Task"
        return textF
    }()
    
    private lazy var saveButton: UIButton = {
       createButton(
        withTitle: "Save Task",
        andColor: UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        ),
        action: UIAction{[unowned self] _ in
            save()
        }
       )
    }()
    
    
    private lazy var cancleButton: UIButton = {
        createButton(
            withTitle: "Cansle",
            andColor: .systemPink,
            action: UIAction{[unowned self] _ in
                dismiss(animated: true)
            }
        )
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews(taskTextField, saveButton, cancleButton)
        setConstrains()
    }
    //вспомогательный метод для того что бы не писать всегда view.Subviw()
    private func setupSubViews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    //метод для констрейнтов
    private func setConstrains() {
        //отключаем настройки констрейнтов через сториборд
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancleButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    //метод для создания кнопок
    private func createButton(withTitle title: String, andColor color: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        buttonConfiguration.baseBackgroundColor = color
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }
    private func save() {
        let task = Task(context: viewContext)
        task.title = taskTextField.text
        viewContext.save()
        dismiss(animated: true)
    }
}
