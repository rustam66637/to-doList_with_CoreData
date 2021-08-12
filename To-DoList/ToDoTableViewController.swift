//
//  ToDoTableViewController.swift
//  To-DoList
//
//  Created by wozdabady on 12.08.2021.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {

    var toDoItems: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    //MARK: - Alert with Ok and Cancel
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        /* Создаем alert с кнопками ок и cancel
         */
        let alertControl = UIAlertController(title: "Add Task", message: "add new task", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            let textField = alertControl.textFields?[0]
            self.saveTask(taskToDo: (textField?.text)!)
//            self.toDoItems.insert((textField?.text)!, at: 0)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertControl.addTextField { textField in
            
        }
        // Добавляем кнопки ок и отмена в alert
        for i in [ok, cancel] {
            alertControl.addAction(i)
        }
        present(alertControl, animated: true, completion: nil)
    }
    
    func saveTask(taskToDo: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        taskObject.taskToDo = taskToDo
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("Saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = toDoItems[indexPath.row]
        //выводим текст в cell
        cell.textLabel?.text = task.taskToDo
        
        return cell
    }
}
