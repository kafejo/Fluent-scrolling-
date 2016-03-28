//
//  ViewController.swift
//  FluentScrolling
//
//  Created by Aleš Kocur on 28/03/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit
import CoreData
import AERecord

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    private var fetchedResultsController: NSFetchedResultsController!
    private let cellHeightCache = CellHeightCache<ManagedColor>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "ColorTableViewCell", bundle: nil), forCellReuseIdentifier: ColorTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = ColorTableViewCell.preferredEstimatedHeight
        tableView.delegate = self
        tableView.dataSource = self
        
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let request = ManagedColor.createFetchRequest(predicate: nil, sortDescriptors: sortDescriptors)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AERecord.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()
        
        fetchedResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addRandomColor(sender: AnyObject) {
        AERecord.backgroundContext.performBlock {
            let randomColor = ManagedColor.create(context: AERecord.backgroundContext)
            let r = (0.0...255.0).random()
            let g = (0.0...255.0).random()
            let b = (0.0...255.0).random()
            randomColor.r = r
            randomColor.g = g
            randomColor.b = b
        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(ColorTableViewCell.reuseIdentifier, forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ColorTableViewCell else {
            return
        }
        
        guard let managedColor = fetchedResultsController.objectAtIndexPath(indexPath) as? ManagedColor else {
            fatalError("*** Wrong object")
        }
        
        AERecord.backgroundContext.performBlock { 
            let color = managedColor.toColor()
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                cell.willDisplayWithColor(color)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let managedColor = fetchedResultsController.objectAtIndexPath(indexPath) as? ManagedColor else {
            fatalError("*** Wrong object")
        }
        
        if let cachedHeight = cellHeightCache.heightForObject(managedColor) {
            return cachedHeight
        } else {
            let height = ColorTableViewCell.preferredHeightForColor(managedColor.toColor(), width: CGRectGetWidth(tableView.frame))
            cellHeightCache.setHeightForObject(managedColor, height: height)
            return height
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.beginUpdates()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            if let newIndexPath = newIndexPath {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:UITableViewRowAnimation.Fade)
                }
            }
            
        case .Delete:
            if let indexPath = indexPath {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
            
        case .Update:
            if let indexPath = indexPath {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
            
        case .Move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch(type) {
        case .Insert:
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        default:
            break
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.endUpdates()
            
        }
    }
}

extension IntervalType {
    func random() -> Bound {
        let range = (self.end as! Double) - (self.start as! Double)
        let randomValue = (Double(arc4random_uniform(UINT32_MAX)) / Double(UINT32_MAX)) * range + (self.start as! Double)
        return randomValue as! Bound
    }
}
