//
//  StatisticViewController.swift
//  PlaneWar
//
//  Created by 罗晗璐 on 2016/11/30.
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = String(score1)
        label2.text = String(score2)
        label3.text = String(score3)
        label4.text = String(score4)
        label5.text = String(score5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToHomeSeg")
        {
            let nav = segue.destination as! UINavigationController
        }
    }
    
}
