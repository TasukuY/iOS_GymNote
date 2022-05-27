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
    @IBOutlet weak var weightLiftingProgressButton: UIButton!
    @IBOutlet weak var cardioProgressButton: UIButton!
    @IBOutlet weak var bodyweightTrainingProgressButton: UIButton!
    
    //MARK: - Properties
    let weihgtProgressLineChart = LineChartView()
    let workoutRatioPieChart = PieChartView()
    let weightLiftingProgressBarChart = BarChartView()
    let cardioProgressScatterChart = ScatterChartView()
    let bodyweightTrainingProgressBarChart = BarChartView()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupWeightProgressChart()
        setupWorkoutRatioChart()
    }
        
    //MARK: - IBActions
    @IBAction func menuButtonTapped(_ sender: Any) {}
    @IBAction func exerciseProgressButtonTapped(_ sender: Any) {}
    @IBAction func cardioProgressButtonTapped(_ sender: Any) {}
    @IBAction func bodyweightTrainingProgressButtonTapped(_ sender: Any) {}
    
    //MARK: - Helper Methods
    func setupView() {
        chartTitleLabel.text = ProgressConstants.weightProgress
        weihgtProgressLineChart.delegate = self
        workoutRatioPieChart.delegate = self
        workoutRatioPieChart.isHidden = true
        weightLiftingProgressBarChart.delegate = self
        weightLiftingProgressBarChart.isHidden = true
        cardioProgressScatterChart.delegate = self
        cardioProgressScatterChart.isHidden = true
        bodyweightTrainingProgressBarChart.delegate = self
        bodyweightTrainingProgressBarChart.isHidden = true
        
        setupMenuButton()
        setupWeightLiftingProgressButton()
        setupCardioProgressButton()
        setupBodyweightTrainingProgressButton()
    }
    
    func setupWorkoutRatioChart() {
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
            if let uniqueWorkout = WorkoutController.shared.workouts.first(where: { $0.title == workoutTitle && $0.isFinished}) {
                uniqueWorkoutArr.append(uniqueWorkout)
            }
        }
        
        for workoutTitle in uniqueWorkoutTitleArr {
            let uniqueWorkoutCount = WorkoutController.shared.workouts.filter{ $0.title == workoutTitle && $0.isFinished}.count
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
    
    func setupWeightLiftingProgressChart(exerciseTitle: String) {
        var exerciseProgressEntries = [BarChartDataEntry]()
        let allSpecifiedExercises = ExerciseController.shared.exercises.filter{ $0.title == exerciseTitle && $0.workout!.isFinished }
        var counter = 0.0
        
        for exercise in allSpecifiedExercises {
            var volume = 0.0
            let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
            
            for exerciseSet in sets {
                volume += (exerciseSet.weight * Double(exerciseSet.reps))
            }
            
            let exerciseDataEntry = BarChartDataEntry(x: counter, y: volume, data: exercise)
            exerciseProgressEntries.append(exerciseDataEntry)
            counter += 1.0
        }
        
        createBarCharts(barChart: weightLiftingProgressBarChart, entries: exerciseProgressEntries)
    }
    
    func setupCardioProgressChart(exerciseTitle: String) {
        var exerciseProgressEntries = [ChartDataEntry]()
        let allSpecifiedExercises = ExerciseController.shared.exercises.filter{ $0.title == exerciseTitle && $0.workout!.isFinished }
        
        for exercise in allSpecifiedExercises {
            let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
            
            for exerciseSet in sets {
                let exerciseDataEntry = BarChartDataEntry(x: Double(exerciseSet.duration), y: exerciseSet.distance, data: exerciseSet)
                exerciseProgressEntries.append(exerciseDataEntry)
            }
        }
        
        createScatterCharts(scatterChart: cardioProgressScatterChart, entries: exerciseProgressEntries)
    }
    
    func setupBodyweightTrainingProgressChart(exerciseTitle: String) {
        var exerciseProgressEntries = [BarChartDataEntry]()
        
        let allSpecifiedExercises = ExerciseController.shared.exercises.filter{ $0.title == exerciseTitle && $0.workout!.isFinished }
        var counter = 0.0
        
        for exercise in allSpecifiedExercises {
            var total = 0
            let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
            
            for exerciseSet in sets {
                total += Int(exerciseSet.reps)
            }
            
            let exerciseDataEntry = BarChartDataEntry(x: counter, y: Double(total), data: exercise)
            exerciseProgressEntries.append(exerciseDataEntry)
            counter += 1.0
        }
        
        createBarCharts(barChart: bodyweightTrainingProgressBarChart, entries: exerciseProgressEntries)
    }
    
    func setupWeightProgressChart() {
        var weightRecordEntries: [ChartDataEntry] = []
        var counter = 0.0
        
        for weightsrecord in WeightRecordController.shared.weightRecords {
            let entry = ChartDataEntry(x: counter, y: weightsrecord.weight, data: weightsrecord)
            weightRecordEntries.append(entry)
            
            counter += 1.0
        }
        
        createLineCharts(lineChart: weihgtProgressLineChart, entries: weightRecordEntries)
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
    
    func createBarCharts(barChart: BarChartView, entries: [BarChartDataEntry]) {
        barChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width * 0.95,
                                height: self.view.frame.size.width * 0.95)
        barChart.center = view.center
        view.addSubview(barChart)
        
        let dataSet = BarChartDataSet(entries: entries)
        
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: dataSet)
        
        barChart.data = data
    }
    
    func createScatterCharts(scatterChart: ScatterChartView, entries: [ChartDataEntry]) {
        scatterChart.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width * 0.95,
                                    height: self.view.frame.size.width * 0.95)
        scatterChart.center = view.center
        view.addSubview(scatterChart)
        
        let dataSet = ScatterChartDataSet(entries: entries)
        
        dataSet.colors = ChartColorTemplates.colorful()
        
        let data = ScatterChartData(dataSet: dataSet)
        
        scatterChart.data = data
    }
    
    func setupMenuButton() {
        var  menuArr: [UIAction] = []
        
        let weightProgress = UIAction(title: ProgressConstants.weightProgress, image: nil) { _ in
            self.chartTitleLabel.text = ProgressConstants.weightProgress
            self.weihgtProgressLineChart.isHidden = false
            self.workoutRatioPieChart.isHidden = true
            self.weightLiftingProgressBarChart.isHidden = true
            self.cardioProgressScatterChart.isHidden = true
            self.bodyweightTrainingProgressBarChart.isHidden = true
        }
        menuArr.append(weightProgress)
        
        let workoutRatio = UIAction(title: ProgressConstants.workoutRatio, image: nil) { _ in
            self.chartTitleLabel.text = ProgressConstants.workoutRatio
            self.workoutRatioPieChart.isHidden = false
            self.weihgtProgressLineChart.isHidden = true
            self.weightLiftingProgressBarChart.isHidden = true
            self.cardioProgressScatterChart.isHidden = true
            self.bodyweightTrainingProgressBarChart.isHidden = true
        }
        menuArr.append(workoutRatio)
        
        let menu = UIMenu(title: "Chart Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuArr)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.titleLabel?.numberOfLines = 0
        menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        menuButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

    func setupWeightLiftingProgressButton() {
        var menuArr: [UIAction] = []
        var allCompletedExercises: [Exercise] = []
        var exerciseTitleArr: [String] = []
        var uniqueExerciseTitleArr: [String] = []
        let completedWorkouts = WorkoutController.shared.workouts.filter{ $0.isFinished}
        
        for workout in completedWorkouts {
            let exercisesForSpecificWorkout = ExerciseController.shared.exercises.filter{ $0.workout == workout }
            
            for exercise in exercisesForSpecificWorkout {
                if exercise.exerciseType == ExerciseConstants.exerciseTypeWeightLifting {
                    allCompletedExercises.append(exercise)
                }
            }
        }
        
        for exercise in allCompletedExercises {
            guard let exerciseTitle = exercise.title else { return }
            exerciseTitleArr.append(exerciseTitle)
        }

        uniqueExerciseTitleArr = Array(Set(exerciseTitleArr))
        
        for exerciseTitle in uniqueExerciseTitleArr {
            let exerciseUIAction = UIAction(title: exerciseTitle) { _ in
                self.chartTitleLabel.text = exerciseTitle
                self.setupWeightLiftingProgressChart(exerciseTitle: exerciseTitle)
                self.workoutRatioPieChart.isHidden = true
                self.weihgtProgressLineChart.isHidden = true
                self.cardioProgressScatterChart.isHidden = true
                self.weightLiftingProgressBarChart.isHidden = false
                self.bodyweightTrainingProgressBarChart.isHidden = true
            }
            menuArr.append(exerciseUIAction)
        }
        
        let menu = UIMenu(title: "Weight Lifting", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuArr)
        weightLiftingProgressButton.menu = menu
        weightLiftingProgressButton.showsMenuAsPrimaryAction = true
        weightLiftingProgressButton.titleLabel?.numberOfLines = 0
        weightLiftingProgressButton.titleLabel?.adjustsFontSizeToFitWidth = true
        weightLiftingProgressButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    func setupCardioProgressButton() {
        var menuArr: [UIAction] = []
        var allCompletedExercises: [Exercise] = []
        var exerciseTitleArr: [String] = []
        var uniqueExerciseTitleArr: [String] = []
        let completedWorkouts = WorkoutController.shared.workouts.filter{ $0.isFinished}
        
        for workout in completedWorkouts {
            let exercisesForSpecificWorkout = ExerciseController.shared.exercises.filter{ $0.workout == workout }
            
            for exercise in exercisesForSpecificWorkout {
                if exercise.exerciseType == ExerciseConstants.exerciseTypeCardio {
                    allCompletedExercises.append(exercise)
                }
            }
        }
        
        for exercise in allCompletedExercises {
            guard let exerciseTitle = exercise.title else { return }
            exerciseTitleArr.append(exerciseTitle)
        }

        uniqueExerciseTitleArr = Array(Set(exerciseTitleArr))
        
        for exerciseTitle in uniqueExerciseTitleArr {
            let exerciseUIAction = UIAction(title: exerciseTitle) { _ in
                self.chartTitleLabel.text = exerciseTitle
                self.setupCardioProgressChart(exerciseTitle: exerciseTitle)
                self.workoutRatioPieChart.isHidden = true
                self.weihgtProgressLineChart.isHidden = true
                self.cardioProgressScatterChart.isHidden = false
                self.weightLiftingProgressBarChart.isHidden = true
                self.bodyweightTrainingProgressBarChart.isHidden = true
            }
            menuArr.append(exerciseUIAction)
        }
        
        let menu = UIMenu(title: "Cardio Training", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuArr)
        cardioProgressButton.menu = menu
        cardioProgressButton.showsMenuAsPrimaryAction = true
        cardioProgressButton.titleLabel?.numberOfLines = 0
        cardioProgressButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cardioProgressButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    func setupBodyweightTrainingProgressButton() {
        var menuArr: [UIAction] = []
        var allCompletedExercises: [Exercise] = []
        var exerciseTitleArr: [String] = []
        var uniqueExerciseTitleArr: [String] = []
        let completedWorkouts = WorkoutController.shared.workouts.filter{ $0.isFinished}
        
        for workout in completedWorkouts {
            let exercisesForSpecificWorkout = ExerciseController.shared.exercises.filter{ $0.workout == workout }
            
            for exercise in exercisesForSpecificWorkout {
                if exercise.exerciseType == ExerciseConstants.exerciseTypeBodyWeightTraining {
                    allCompletedExercises.append(exercise)
                }
            }
        }
        
        for exercise in allCompletedExercises {
            guard let exerciseTitle = exercise.title else { return }
            exerciseTitleArr.append(exerciseTitle)
        }

        uniqueExerciseTitleArr = Array(Set(exerciseTitleArr))
        
        for exerciseTitle in uniqueExerciseTitleArr {
            let exerciseUIAction = UIAction(title: exerciseTitle) { _ in
                self.chartTitleLabel.text = exerciseTitle
                //call bodyweightChart setup function here
                self.setupBodyweightTrainingProgressChart(exerciseTitle: exerciseTitle)
                self.workoutRatioPieChart.isHidden = true
                self.weihgtProgressLineChart.isHidden = true
                self.cardioProgressScatterChart.isHidden = true
                self.weightLiftingProgressBarChart.isHidden = true
                self.bodyweightTrainingProgressBarChart.isHidden = false
            }
            menuArr.append(exerciseUIAction)
        }

        let menu = UIMenu(title: "Bodyweight Training", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuArr)
        bodyweightTrainingProgressButton.menu = menu
        bodyweightTrainingProgressButton.showsMenuAsPrimaryAction = true
        bodyweightTrainingProgressButton.titleLabel?.numberOfLines = 0
        bodyweightTrainingProgressButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bodyweightTrainingProgressButton.titleLabel?.lineBreakMode = .byWordWrapping
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
                    item.descriptionText = "\(weightDate.datesFormatForWorkout())\n\n\(weightRecord.weight) lb"
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
                    item.descriptionText = "\(workoutRatio.title)\n\n\(workoutRatio.ratio)% of All Workouts"
                }
                item.requiresCloseButton = false
                return BLTNItemManager(rootItem: item)
            }()
            boardManager.showBulletin(above: self)
        }
        //Exercise Progress Charts for weight lifting and bodyweight training
        if let exercise = entry.data as? Exercise {
            guard let exerciseTitle = exercise.title,
                  let exerciseDate = exercise.workout?.date
            else { return }
            
            //For Weight Lifting BarCharts
            if exercise.exerciseType == ExerciseConstants.exerciseTypeWeightLifting {
                
                var volume = 0.0
                let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
                
                for exerciseSet in sets {
                    volume += (exerciseSet.weight * Double(exerciseSet.reps))
                }
                
                lazy var boardManager: BLTNItemManager = {
                    var item = BLTNPageItem(title: exerciseTitle)
                    if chartTitleLabel.text == exerciseTitle {
                        let newItem = BLTNPageItem(title: exerciseTitle)
                        item = newItem
                        item.descriptionText = "\(exerciseDate.datesFormatForWorkout())\n\nVolume \(volume) lb"
                    }
                    item.requiresCloseButton = false
                    return BLTNItemManager(rootItem: item)
                }()
                boardManager.showBulletin(above: self)
            }
            //For Bodyweight Training LineCharts
            if exercise.exerciseType == ExerciseConstants.exerciseTypeBodyWeightTraining {
                
                var total = 0
                let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
                
                for exerciseSet in sets {
                    total += Int(exerciseSet.reps)
                }
                
                lazy var boardManager: BLTNItemManager = {
                    var item = BLTNPageItem(title: exerciseTitle)
                    if chartTitleLabel.text == exerciseTitle {
                        let newItem = BLTNPageItem(title: exerciseTitle)
                        item = newItem
                        item.descriptionText = "\(exerciseDate.datesFormatForWorkout())\n\nTotal \(total) reps in \(exercise.exerciseSets?.count ?? 0) sets"
                    }
                    item.requiresCloseButton = false
                    return BLTNItemManager(rootItem: item)
                }()
                boardManager.showBulletin(above: self)
            }
        }
        //Exercise Progress Charts for weight lifting and bodyweight training
        if let exerciseSet = entry.data as? ExerciseSet {
            guard let exerciseTitle = exerciseSet.exercise?.title,
                  let workout = exerciseSet.exercise?.workout,
                  let exerciseDate = workout.date
            else { return }
            
            //For Cardio Scattered Chart
            
            lazy var boardManager: BLTNItemManager = {
                var item = BLTNPageItem(title: exerciseTitle)
                if chartTitleLabel.text == exerciseTitle {
                    let newItem = BLTNPageItem(title: exerciseTitle)
                    item = newItem
                    item.descriptionText = "\(exerciseDate.datesFormatForWorkout())\n\n\(exerciseSet.distance) miles in \(exerciseSet.duration) mins"
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
