//
//  ProgressViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/25/22.
//

import UIKit
import Charts
import BLTNBoard

class ProgressViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var chartTitleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var exerciseProgressButton: UIButton!
    
    //MARK: - Properties
    let weightRecordsLineChart = LineChartView()
    let workoutRatioPieChart = PieChartView()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpWeightProgressChart()
        setUpWorkoutRatioChart()
    }
        
    //MARK: - IBActions
    @IBAction func menuButtonTapped(_ sender: Any) {}
    @IBAction func exerciseProgressButtonTapped(_ sender: Any) {}
    
    //MARK: - Helper Methods
    func setupView() {
        chartTitleLabel.text = ProgressConstants.weightProgress
        weightRecordsLineChart.delegate = self
        workoutRatioPieChart.delegate = self
        workoutRatioPieChart.isHidden = true
        
        setupChartsButton()
    }
    
    func setUpWorkoutRatioChart() {
        var workoutRatioEntries: [PieChartDataEntry] = []
        
        //make unique workout array
        var workoutTitleArr: [String] = []
        var uniqueWorkoutTitleArr: [String] = []
        var uniqueWorkoutArr: [Workout] = []
        var uniqueWorkoutCountArray: [Int] = []
        var uniqueWorkoutRatioArray: [Double] = []
        var workoutRatioArray: [WorkoutRatio] = []
        
        for workout in WorkoutController.shared.workouts {
            guard let workoutTitle = workout.title else { return }
            workoutTitleArr.append(workoutTitle)
        }
        
        uniqueWorkoutTitleArr = Array(Set(workoutTitleArr))
        
        for workoutTitle in uniqueWorkoutTitleArr {
            if let uniqueWorkout = WorkoutController.shared.workouts.first(where: { $0.title == workoutTitle }) {
                uniqueWorkoutArr.append(uniqueWorkout)
            }
        }
        
        for workoutTitle in uniqueWorkoutTitleArr {
            let uniqueWorkoutCount = WorkoutController.shared.workouts.filter{ $0.title == workoutTitle }.count
            uniqueWorkoutCountArray.append(uniqueWorkoutCount)
        }
        
        for workoutCount in uniqueWorkoutCountArray {
            let workoutRatio = (Double(workoutCount) / Double(WorkoutController.shared.workouts.count)) * 100.0
            let roundedWorkoutRatio = Double(round(workoutRatio * 100)/100)
            uniqueWorkoutRatioArray.append(roundedWorkoutRatio)
        }
        
        for index in 0 ..< uniqueWorkoutTitleArr.count {
            let workoutRatio = WorkoutRatio(title: uniqueWorkoutTitleArr[index], ratio: uniqueWorkoutRatioArray[index])
            workoutRatioArray.append(workoutRatio)
        }
        
        for workoutRatio in workoutRatioArray {
            let entry = PieChartDataEntry(value: workoutRatio.ratio, label: workoutRatio.title, data: workoutRatio)
            workoutRatioEntries.append(entry)
        }
        
        createPieCharts(pieChart: workoutRatioPieChart, entries: workoutRatioEntries)
    }
    
    func setUpWeightProgressChart() {
        var weightRecordEntries: [ChartDataEntry] = []
        var counter = 0.0
        
        for weightsrecord in WeightRecordController.shared.weightRecords {
            let entry = ChartDataEntry(x: counter, y: weightsrecord.weight, data: weightsrecord)
            weightRecordEntries.append(entry)
            
            counter += 1.0
        }
        
        createLineCharts(lineChart: weightRecordsLineChart, entries: weightRecordEntries)
    }
    
    func createPieCharts(pieChart: PieChartView, entries: [PieChartDataEntry]) {
        pieChart.frame = CGRect(x: 0, y: 0,
                                 width: self.view.frame.size.width * 0.95,
                                 height: self.view.frame.size.width * 0.95)
        pieChart.center = view.center
        view.addSubview(pieChart)
        pieChart.entryLabelColor = NSUIColor(named: "black")
        
        let dataSet = PieChartDataSet(entries: entries)
        
//        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.colors = ChartColorTemplates.colorful()
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
    }
    
    func createLineCharts(lineChart: LineChartView, entries: [ChartDataEntry]) {
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.view.frame.size.width * 0.95,
                                 height: self.view.frame.size.width * 0.95)
        lineChart.center = view.center
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawLabelsEnabled = false
        
        view.addSubview(lineChart)
        
        let dataSet = LineChartDataSet(entries: entries)
        
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data = LineChartData(dataSet: dataSet)
        
        lineChart.data = data
    }
    
    func setupChartsButton() {
        var  menuArr: [UIAction] = []
        
        let weightProgress = UIAction(title: ProgressConstants.weightProgress, image: nil) { _ in
            self.chartTitleLabel.text = ProgressConstants.weightProgress
            self.weightRecordsLineChart.isHidden = false
            self.workoutRatioPieChart.isHidden = true
        }
        menuArr.append(weightProgress)
        
        let workoutRatio = UIAction(title: ProgressConstants.workoutRatio, image: nil) { _ in
            self.chartTitleLabel.text = ProgressConstants.workoutRatio
            self.workoutRatioPieChart.isHidden = false
            self.weightRecordsLineChart.isHidden = true
        }
        menuArr.append(workoutRatio)
        
        let menu = UIMenu(title: "Exercise Type Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuArr)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.titleLabel?.numberOfLines = 0
        menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        menuButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

}//End of class

extension ProgressViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        //Weight Progress Chart's Details
        if let weightRecord = entry.data as? WeightRecord {
            
            lazy var boardManager: BLTNItemManager = {
                var item = BLTNPageItem(title: ProgressConstants.weightProgress)
                
                if chartTitleLabel.text == ProgressConstants.weightProgress {
                    guard let weightDate = weightRecord.date
                    else { return BLTNItemManager(rootItem: item) }
                    
                    let newItem = BLTNPageItem(title: ProgressConstants.weightProgress)
                    item = newItem
                    item.descriptionText = "Date: \(weightDate.datesFormatForWorkout())\nWeight: \(weightRecord.weight) lb"
                }
                
                item.requiresCloseButton = false
                return BLTNItemManager(rootItem: item)
            }()
            boardManager.showBulletin(above: self)
        }
        //Workout Ratio Chart Detail
        if let workoutRatio = entry.data as? WorkoutRatio {
            
            lazy var boardManager: BLTNItemManager = {
                var item = BLTNPageItem(title: ProgressConstants.weightProgress)
                if chartTitleLabel.text == ProgressConstants.workoutRatio {
                    //Workout Ratio Chart's Details
                    let newItem = BLTNPageItem(title: ProgressConstants.workoutRatio)
                    item = newItem
                    item.descriptionText = "\(workoutRatio.title) \n\(workoutRatio.ratio)% of All Workouts"
                }
                item.requiresCloseButton = false
                return BLTNItemManager(rootItem: item)
            }()
            boardManager.showBulletin(above: self)
        }
    }
    
}//End of extension

struct WorkoutRatio {
    
    let title: String
    let ratio: Double
    
}//End of struct
