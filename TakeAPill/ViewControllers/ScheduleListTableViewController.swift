//
//  ScheduleListTableViewController.swift
//  TakeAPill
//
//  Created by  Dinir on 28.08.2022.
//

import UIKit

class ScheduleListTableViewController: UITableViewController {
    var selectedSchedule: MedicationSchedule?
    var schedules: [MedicationSchedule] = MedicationSchedule.all

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToScheduleListViewContoller(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source
                as? ScheduleSetupViewController,
              let schedule = sourceViewController.schedule else {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            return
        }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            schedules[selectedIndexPath.row] = schedule
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        } else {
            schedules.append(schedule)
            tableView.reloadData()
        }
    }

    @IBSegueAction func addEditSchedule(_ coder: NSCoder, sender: Any?) -> ScheduleSetupViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // Editing Schedule
            let scheduleToEdit = schedules[indexPath.row]
            return ScheduleSetupViewController(coder: coder, schedule: scheduleToEdit)
        } else {
            // Adding Schedule
            return ScheduleSetupViewController(coder: coder, schedule: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationScheduleCell", for: indexPath) as!
        MedicationScheduleTableViewCell
        cell.update(schedule: schedules[indexPath.row])

        return cell
    }
}
