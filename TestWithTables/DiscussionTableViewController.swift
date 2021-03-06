//
//  DiscussionTableViewController.swift
//  TestWithTables
//
//  Created by Laura Post on 12/15/17.
//  Copyright © 2017 Laura Post. All rights reserved.
//

import UIKit
import os.log

class DiscussionTableViewController: UITableViewController {
    
    //MARK: Properties
    var discussions = [Discussion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved discussions, otherwise load sample data
        if let savedDiscussions = loadDiscussions() {
            discussions += savedDiscussions
        }
        else {
            //Load sample data
            loadSampleDiscussions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DiscussionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DiscussionTableViewCell else {
            fatalError("The cell is not an instance of DiscussionTableViewCell")
        }
        //Fetches the appropriate discussion for the data source layout
        let discussion = discussions[indexPath.row]
        
        cell.nameLabel.text = discussion.name
        
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            discussions.remove(at: indexPath.row)
            saveDiscussions()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    //MARK: - Navigation
  /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        }
   */
    
    //MARK: Private Methods
    private func loadSampleDiscussions() {
        let discussion1 = Discussion(name: "Discussion 1")
        let discussion2 = Discussion(name: "Discussion 2")
        let discussion3 = Discussion(name: "Discussion 3")
        
        discussions += [discussion1, discussion2, discussion3]
    }
    private func saveDiscussions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(discussions, toFile: Discussion.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Discussions Successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save discussions...", log: OSLog.default, type: .error)
        }
    }
    private func loadDiscussions() -> [Discussion]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Discussion.ArchiveURL.path) as? [Discussion]
    }
    
    //MARK: Actions
    @IBAction func unwindToDiscussionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let discussion = sourceViewController.discussion {
            
            // Add a new discussion
            let newIndexPath = IndexPath(row: discussions.count, section: 0)
            discussions.append(discussion)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
           
            //Save the discussions
            saveDiscussions()
        }
    }
}
