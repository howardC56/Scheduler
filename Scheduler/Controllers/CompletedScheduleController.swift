//
//  CompletedScheduleController.swift
//  Scheduler
//
//  Created by Alex Paul on 1/18/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class CompletedScheduleController: UIViewController {
    
  private var completedEvents = [Event]() {
    didSet {
        guard let tableView =  tableView else { return }
        tableView.reloadData()
    }
  }
  
public var dataPersistence: DataPersistence<Event>!
private let completedEventsPersistence = DataPersistence<Event>(filename: "completedEvents.plist" )
    
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    loadCompletedItems()
  }
  
  private func loadCompletedItems() {
    do {
        completedEvents = try completedEventsPersistence.loadItems()
    } catch {
        print("error loading completed events")
    }
  }
}

extension CompletedScheduleController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return completedEvents.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
    let event = completedEvents[indexPath.row]
    cell.textLabel?.text = event.name
    cell.detailTextLabel?.text = event.date.description
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // remove from data soruce
      completedEvents.remove(at: indexPath.row)
      
        do {
            try completedEventsPersistence.deleteItem(at: indexPath.row)
        } catch {
            print("error persisting delete")
        }
    }
  }
}

extension CompletedScheduleController: DataPersistenceDelegate {
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        do {
            let event = item as! Event
        try completedEventsPersistence.createItem(event)
        } catch {
            print("error creating item")
        }
    loadCompletedItems()
}
}
