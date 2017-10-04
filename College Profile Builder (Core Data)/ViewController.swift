//
//  ViewController.swift
//  CollegeProfileBuilder
//
//  Created by Wade Sellers on 7/22/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var collegeArray = [College]()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [College] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData()
    {
        do {
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch {
            print("Fido couldn't get the ball")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getData()
            
        }
        tableView.reloadData()
    }
///////////////////////////////////////
        
        let college1 = College(Name: "University of Illinois", Location: "Champaign, IL", NumberOfStudents: "43,000", Image: UIImage(named: "Illinois")!, Webpage: "www.uiuc.edu", Crest: UIImage(named: "IllinoisCrest")!)
        collegeArray.append(college1)
        let college2 = College(Name: "Iowa", Location: "Iowa City, IA", NumberOfStudents: "31,000", Image: UIImage(named: "iowa")!, Webpage: "www.uiowa.edu", Crest: UIImage(named: "IowaCrest")!)
        collegeArray.append(college2)
        let college3 = College(Name: "Harvard", Location: "Cambridge, MA", NumberOfStudents: "21,000", Image: UIImage(named: "Harvard")!, Webpage: "www.harvard.edu", Crest: UIImage(named: "HarvardCrest")!)
        collegeArray.append(college3)
    }

    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collegeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = collegeArray[(indexPath as NSIndexPath).row].name
        cell.detailTextLabel?.text = collegeArray[(indexPath as NSIndexPath).row].location
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! DetailsViewController
        let indexPath = myTableView.indexPathForSelectedRow!
        nvc.selectedCollege = collegeArray[(indexPath as NSIndexPath).row]
    }

    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New College", message: nil, preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Add College Name Here"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Add College Location Here"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Add Number of Students Here"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Add Webpage URL Here"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)

        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let nameTextField = alert.textFields?[0]
            let locationTextField = alert.textFields?[1]
            let numberOfStudentsTextField = alert.textFields?[2]
            let webPageTextField = alert.textFields?[3]
            
            let newCollege = College(Name: nameTextField!.text!, Location: locationTextField!.text!, NumberOfStudents: numberOfStudentsTextField!.text!, Image: UIImage(), Webpage: webPageTextField!.text!, Crest: UIImage())
            self.collegeArray.append(newCollege)
            self.myTableView.reloadData()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let collegexc = College(context: context)
            collegexc.name = nameTextField!.text!
            appDelegate.saveContext()
            
            navigationController?.popViewController(animated: true)
        }

        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func onEditButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            myTableView.isEditing = true
            sender.tag = 1
        }
        else {
            myTableView.isEditing = false
            sender.tag = 0
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            collegeArray.remove(at: (indexPath as NSIndexPath).row)
            myTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let college = collegeArray[(sourceIndexPath as NSIndexPath).row]
        collegeArray.remove(at: (sourceIndexPath as NSIndexPath).row)
        collegeArray.insert(college, at: (destinationIndexPath as NSIndexPath).row)

    }
}

