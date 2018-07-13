//
//  PopDateViewController.swift
//  GetMeSocial
//
//  Created by Iorweth on 28/06/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

protocol DataPickerViewControllerDelegate : class
{
    func datePickerVCDismissed(_ date : Date?)
}

class PopDateViewController : UIViewController
{
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate : DataPickerViewControllerDelegate?
    
    var currentDate : Date?
    {
        didSet
        {
            updatePickerCurrentDate()
        }
    }
    
    convenience init()
    {
        self.init(nibName: "PopDateViewController", bundle: nil)
    }
    
    private func updatePickerCurrentDate()
    {
        if let _currentDate = self.currentDate
        {
            if let _datePicker = self.datePicker
            {
                _datePicker.date = _currentDate
            }
        }
    }
    
    @IBAction func doneAction(_ sender: AnyObject)
    {
        self.dismiss(animated: true)
        {
            let nsdate = self.datePicker.date
            self.delegate?.datePickerVCDismissed(nsdate)
        }
    }
    
    override func viewDidLoad()
    {
        //Date limits by last 17 years
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.year = -80
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.year = -17
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.datePicker.minimumDate = minDate as Date
        self.datePicker.maximumDate = maxDate as Date
        
        updatePickerCurrentDate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate?.datePickerVCDismissed(nil)
    }
}
