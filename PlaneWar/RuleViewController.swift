//
//  RuleViewController.swift
//  PlaneWar
//
//  Created by 刘思佳 on 2016/12/1.
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import UIKit

class RuleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
