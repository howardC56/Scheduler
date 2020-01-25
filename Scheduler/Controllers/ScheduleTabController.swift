//
//  ScheduleTabController.swift
//  Scheduler
//
//  Created by Howard Chang on 1/24/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ScheduleTabController: UITabBarController {
    private let dataPersistence = DataPersistence<Event>(filename: "schedules.plist")

    private lazy var scheduleNavController: UINavigationController = {
        guard let navController = storyboard?.instantiateViewController(identifier: "ScheduleNavController") as? UINavigationController,
            let schedulesListController = navController.viewControllers.first as? ScheduleListController else { fatalError("could not load nav controller") }
        schedulesListController.dataPersistence = dataPersistence
        return navController
    
    }()
    
    private lazy var completedNavController: UINavigationController = {
        guard let navController = storyboard?.instantiateViewController(identifier: "CompletedNavController") as? UINavigationController,
            let completedController = navController.viewControllers.first as? CompletedScheduleController else { fatalError("could not load completed nav Controller")}
        completedController.dataPersistence = dataPersistence
        completedController.dataPersistence.delegate = completedController
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [scheduleNavController, completedNavController]
    }
    

}
