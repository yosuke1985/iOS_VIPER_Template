//
//  NavigationController.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/20.
//

import UIKit

@IBDesignable
class NavigationController: UINavigationController {
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(rootVC: UIViewController, naviBarClass: AnyClass?, toolbarClass: AnyClass?) {
        self.init(navigationBarClass: naviBarClass, toolbarClass: toolbarClass)
        viewControllers = [rootVC]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
