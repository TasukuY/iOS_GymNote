//
//  ProgressViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/25/22.
//

import UIKit
import Charts

class ProgressViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var chartsButton: UIBarButtonItem!
    
    //MARK: - Properties
    var weightProgressLineChart = LineChartView()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        weightProgressLineChart.frame = CGRect(x: 0, y: 0,
                                   width: self.view.frame.size.width,
                                   height: self.view.frame.size.width)
        weightProgressLineChart.center = view.center
        view.addSubview(weightProgressLineChart)
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        
        dataSet.colors = ChartColorTemplates.material()
        
        let data = LineChartData(dataSet: dataSet)
        
        weightProgressLineChart.data = data
    }
    
    //MARK: - Helper Methods
    func setupView() {
        weightProgressLineChart.delegate = self
    }
    
    //MARK: - IBActions
    @IBAction func chartsButtonTapped(_ sender: Any) {
    }
    
}//End of class

extension ProgressViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Entry Value x(\(entry.x)), y(\(entry.y)) Got Selected")
        print(highlight.description)
    }
}
