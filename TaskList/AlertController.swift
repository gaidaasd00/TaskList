//
//  AlertController.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 10.09.2022.
//

import UIKit

extension UIAlertController {
    static func createAlertController(with title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you wont to do?", preferredStyle: .alert)
    }
    func action(task: Task?, complition: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newValue = self?.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            complition(newValue)
        }
        let cencleAction = UIAlertAction(title: "Cancle", style: .destructive)
        
        addAction(saveAction)
        addAction(cencleAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
            
        }
    }
}
