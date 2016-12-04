//
//  HomeViewController.swift
//  PlaneWar
//
//  Created by 罗晗璐 on 2016/11/30.
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
           }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToGameSeg")
        {
            let nav = segue.destination as! UINavigationController
        }
        else if(segue.identifier == "loginToStatisticSeg")
        {
            let nav = segue.destination as! UINavigationController
        }
        else if(segue.identifier == "loginToRuleSeg")
        {
            let nav = segue.destination as! UINavigationController
        }
        
    }
    
}
