//
//  StoryboardConstants.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import Foundation

struct StoryboardConstants {
    
    //Stroyboard ID Related
    static let onboadingStoryboardID = "onboardingStoryboardKey"
    static let workoutSetupStoryboardID = "workoutSetupStoryboardKey"
    static let mainstoryboardID = "mainStroyboardKey"
    static let mainstoryboard = "Main"
    static let onboardingStoryboard = "Onboarding"
    static let workoutSetupStoryboard = "WorkoutSetup"
    static let isOnboardedKey = "isOnboading"
    static let workoutSetupNavController = "workoutSetupNavController"
    static let mainStoryboardTabController = "mainTabController"
    
    //Segue Related
    static let segueToImageSetupVC = "toImageSetupVC"
    static let segueToAccountConfirmationVC = "toAccountConfirmationVC"
    static let segueToExerciseListVC = "toExerciseListVC"
    static let segueToExerciseSetupVC = "toExerciseSetupVC"
    static let segueToSetsVC = "toSetsVC"
    static let segueToExerciseDetails = "toExerciseDetails"
    static let segueToDatesDetailVC = "toDatesDetailVC"
    static let segueToCreateNewWorkoutVCFromHomeVC = "toCreateNewWorkoutVCFromHomeVC"
    static let segueToCreateNewWorkoutVCFromCalendarVC = "toCreateNewWorkoutVCFromCalendarVC"
    static let segueToExerciseListVCFromHomeVC = "toExerciseListVCFromHomeVC"
    static let segueToExerciseListVCFromCalendarVC = "toExerciseListVCFromCalendarVC"
    static let segueToExerciseListVCFromHomeVCToSetUPExistingWorkout = "toExerciseListVCFromHomeVCToSetUPExistingWorkout"
    static let segueToExerciseListVCFromCalendarVCToSetUPExistingWorkout = "toExerciseListVCFromCalendarVCToSetUPExistingWorkout"
    
    //Navigation Controller Related
    static let navPathFromHomeVC = "HomeVC"
    static let navPathFromCalendarVC = "CalendarVC"
    
}//End of struct
