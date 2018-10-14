//
//  SearchFuncTableViewController.swift
//  signIn
//
//  Created by Lamia Al salloom on 10/13/18.
//  Copyright © 2018 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
class SearchFuncTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    @IBOutlet var findplacestableviewcontroller: UITableView!
    
    
    
    var StringPassed = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var mainViewController:SubTableViewController?
    
    //print(StringPassed)
    // array of places
    var placesArray = [NSDictionary?]()
    var filteredPlaces = [NSDictionary?]()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        searchController.searchResultsUpdater=self //as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        //
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if StringPassed == "Shops"{
            ref.child("Shops").queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
                self.placesArray.append(snapshot.value as? NSDictionary)
                //===========
                
                self.findplacestableviewcontroller.insertRows(at: [IndexPath(row:self.placesArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
                
                
            }){ (error) in print(error.localizedDescription)
                
            }
        }
        if StringPassed == "Restaurants" {
            //=========
            ref.child("Restaurants").queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
                self.placesArray.append(snapshot.value as? NSDictionary)
                //===========
                
                self.findplacestableviewcontroller.insertRows(at: [IndexPath(row:self.placesArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
                
                
            }){ (error) in print(error.localizedDescription)
                
            }
        }
        //=========
        if StringPassed == "Coffee Shops & Bakeries" {
            ref.child("Coffee Shops & Bakeries").queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
                self.placesArray.append(snapshot.value as? NSDictionary)
                //===========
                
                self.findplacestableviewcontroller.insertRows(at: [IndexPath(row:self.placesArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
                
                
            }){ (error) in print(error.localizedDescription)
                
            }
        }else {
            ref.child(StringPassed).queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
                self.placesArray.append(snapshot.value as? NSDictionary)
                //===========
                
                self.findplacestableviewcontroller.insertRows(at: [IndexPath(row:self.placesArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
                
                
            }){ (error) in print(error.localizedDescription)
                
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredPlaces.count
        }
        return self.placesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let place : NSDictionary?
        // Configure the cell...
        if searchController.isActive && searchController.searchBar.text != ""{
            place = filteredPlaces[indexPath.row]
        }
        else {
            place = self.placesArray[indexPath.row]
        }
        cell.textLabel?.text = place?["name"] as? String
        cell.detailTextLabel?.text = place?["Type"] as? String
        return cell
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
   
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(SearchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(SearchText:String){
        self.filteredPlaces = self.placesArray.filter{ place in
            let placename = place! ["name"] as? String
            return(placename?.lowercased().contains(SearchText.lowercased()))!
        }
        tableView.reloadData()
    }
}

