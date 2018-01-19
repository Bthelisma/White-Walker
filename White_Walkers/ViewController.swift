//
//  ViewController.swift
//  White_Walkers
//
//  Created by Dojo on 1/18/18.
//  Copyright © 2018 Dojo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var nameOutlet: UITextField!
    var arr = ["Jinal", "Emily"]
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameOutlet.text = ""
        nameOutlet.placeholder = "Name"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMainController(segue: UIStoryboardSegue){
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        cell?.textLabel?.text = "\(arr[indexPath.row])"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

}
