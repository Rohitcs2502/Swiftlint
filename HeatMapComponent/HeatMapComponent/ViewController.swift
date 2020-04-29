//
//  ViewController.swift
//  HeatMapComponent
//
//  Created by Rohit Kumar Agarwalla on 16/04/20.
//  Copyright © 2020 Rohit Kumar Agarwalla. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var lineChartWindow: InteractiveHMViewController?
    var temp: String?
    // This is for test commit
    let graphDataSet = [
        ["mpn": "MPN 1", "soldTo": "Sold To 1", "deltaToTWOs": 1],
        ["mpn": "MPN 2", "soldTo": "Sold To 1", "deltaToTWOs": 1],
        ["mpn": "MPN 3", "soldTo": "Sold To 1", "deltaToTWOs": 1],
        ["mpn": "MPN 4", "soldTo": "Sold To 1", "deltaToTWOs": 1],
        ["mpn": "MPN 1", "soldTo": "Sold To 2", "deltaToTWOs": 1],
        ["mpn": "MPN 1", "soldTo": "Sold To 1", "deltaToTWOs": 2],
        ["mpn": "MPN 2", "soldTo": "Sold To 2", "deltaToTWOs": 2],
        ["mpn": "MPN 1", "soldTo": "Sold To 2", "deltaToTWOs": 2],
        ["mpn": "MPN 3", "soldTo": "Sold To 2", "deltaToTWOs": 2],
        ["mpn": "MPN 1", "soldTo": "Sold To 1", "deltaToTWOs": 3],
        ["mpn": "MPN 2", "soldTo": "Sold To 2", "deltaToTWOs": 3],
        ["mpn": "MPN 1", "soldTo": "Sold To 2", "deltaToTWOs": 3],
        ["mpn": "MPN 1", "soldTo": "Sold To 1", "deltaToTWOs": -1],
        ["mpn": "MPN 2", "soldTo": "Sold To 2", "deltaToTWOs": -1],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openLineChart(sender: Any) {
//        lineChartWindow = InteractiveHMViewController(windowNibName: "InteractiveHMViewController", owner: self)
        temp = "test Data"
        Swift.print("Testing for test data \(temp!)")
        lineChartWindow = InteractiveHMViewController(windowNibName: "InteractiveHMViewController")
        lineChartWindow?.graphDataset.removeAll(keepingCapacity: false)
        lineChartWindow?.graphDataset.append(contentsOf: self.graphDataSet)
        lineChartWindow?.showWindow(self.view.window?.windowController)
    }
}

