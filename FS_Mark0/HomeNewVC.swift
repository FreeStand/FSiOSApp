//
//  HomeNewVC.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 09/09/17.
//  Copyright © 2017 Aryan Sharma. All rights reserved.
//

import UIKit

class HomeNewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "freestandLogoWhite.png")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor.fiBlack
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
            
            cell.contentView.addBottomBorderWithColor(color: UIColor().HexToColor(hexString: "#393939", alpha: 1.0), width: 8.0)
            
            
            return cell
            
        
    }
    

}
