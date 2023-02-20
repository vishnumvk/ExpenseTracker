//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = UINavigationController(rootViewController: RecordsVC())
        
        if let userActivity = connectionOptions.userActivities.first ?? scene.session.stateRestorationActivity {
                // Restore the user interface from the state restoration activity.
            setupScene(with: userActivity)
            }
        
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        
    }


}

extension SceneDelegate{
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        
        print(#function)
        if let vc = window?.rootViewController as? UINavigationController,
           let aevc = vc.topViewController as? AddExpenseVC{
            aevc.updateUserActivity()
            
        }
        return scene.userActivity
    }
    
    static let MainSceneActivityType = { () -> String in
        // Load the activity type from the Info.plist.
//        let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] as? [String]
//        print(activityTypes)
        return "com.ExpenseTracker.addExpenseRestoreation"
    }
    
    static let presentedAddExpenseKey = "presentedAddExpense"
    static let presentSaveImageToCameraAlertKey = "presentSaveImageToCameraAlert"
    static let amountKey = "amount"
    static let titleKey = "title"
    static let categoryKey = "category"
    static let dateKey = "date"
    static let noteKey = "note"
    static let attachmentsKey = "attachments"
    static let capturedImageKey = "capturedImage"
    
    func setupScene(with userActivity: NSUserActivity){
        if userActivity.activityType == SceneDelegate.MainSceneActivityType(){
            if let presentedAddExpenseVC = userActivity.userInfo?[SceneDelegate.presentedAddExpenseKey] as? Bool{
                if presentedAddExpenseVC{
                    if let navVC = window?.rootViewController as? UINavigationController{
                        let AddExpenseVC = AddExpenseVC()
                        AddExpenseVC.restorationValues = userActivity.userInfo
                        navVC.pushViewController(AddExpenseVC, animated: false)
                        print("state restoration was successful!")
                    }
                }
            }
        }
    }
}
