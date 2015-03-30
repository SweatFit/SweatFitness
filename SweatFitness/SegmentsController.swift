//
//  SegmentsController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/29/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import UIKit

class SegmentsController: NSObject {
    var viewControllers:[UIViewController]?
    var navController:UINavigationController?
    var rootController:UIViewController?
    init(aNavigationController:UINavigationController!, viewControllers:[UIViewController]!, rootViewController:UIViewController!) {
        self.viewControllers = viewControllers
        self.navController = aNavigationController
        self.rootController = rootViewController
    }
    func indexDidChangeForSegmentedControl(aSegmentedControl:UISegmentedControl!) {
        println(aSegmentedControl)
        let index = aSegmentedControl.selectedSegmentIndex
        self.navController!.popToViewController(self.rootController!, animated: false)
        let incomingViewController = self.viewControllers![index]
        //let theViewControllers = [incomingViewController]
        //self.navController!.setViewControllers(theViewControllers, animated: false)
        self.navController!.pushViewController(incomingViewController, animated: false)
        incomingViewController.navigationItem.titleView = aSegmentedControl
    }
}