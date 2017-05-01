//
//  StoreVC.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 4/30/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import UIKit

class StoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [Items] = []
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        items = setUpShop()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath)
        
        let item: Items
        item = self.items[indexPath.row]
        
        cell.textLabel?.text = "Item: \(item.name!)  Cost: \(item.goldValue) Gold"
        cell.imageView?.image = UIImage(named: item.imageName!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do something
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Once the button is pressed it closes out the store view
    @IBAction func backToMapButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
