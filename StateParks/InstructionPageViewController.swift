//
//  InstructionPageViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/14/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class InstructionPageViewController: UIPageViewController {
    
    var pageIndex = 0
    let instructionModel = InstructionModel.shared
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        let firstVC = self.getPgaeViewController(page: pageIndex)!

        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func getPgaeViewController(page: Int) -> UIViewController! {
        let instruction = instructionModel.instructionForPage(page: page)
        let instructionVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
        
        instructionVC.instructionObject = instruction
//        instructionVC.instructionDescription.text = instruction.description
        
        return instructionVC
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InstructionPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        let nextIndex = (viewController as! InstructionViewController).instructionObject!.index + 1

        if (nextIndex > 2) {
            return nil
        } else {
            (pageViewController as! InstructionPageViewController).pageIndex = nextIndex
            return self.getPgaeViewController(page: nextIndex)
        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
                
        let previousIndex = (viewController as! InstructionViewController).instructionObject!.index - 1
                        
        if (previousIndex < 0) {
            return nil
        } else {
            return self.getPgaeViewController(page: previousIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let parentVC = pageViewController.parent as! InstructionContainerViewController
        let index = (pageViewController.viewControllers!.first as! InstructionViewController).instructionObject!.index
        parentVC.updatePage(page: index)
    }
}
