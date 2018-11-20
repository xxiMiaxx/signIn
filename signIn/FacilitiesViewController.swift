//
//  FacilitiesViewController.swift
//  signIn
//
//  Created by Lamia Al salloom on 11/7/18.
//  Copyright © 2018 Arwa Hamed. All rights reserved.
//

import UIKit

class FacilitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = ["Woman Toilets, Ground Floor, Near gate 7", "Men Toilets, First Floor", "Mosque, Outdise gate 1", "ATM, Gate 2 and 3", "Parking lots, Basment", "Lost and Founds, Gate 5", "Woman prayer room, Ground floor", "Changing rooms, Gate 3, 4 and 5" ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
