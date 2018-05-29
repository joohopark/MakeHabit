//
//  PromissDetailViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 5. 28..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

class PromissDetailViewController: BaseViewController {
  
  //MARK: - Property
  @IBOutlet var tap: UITapGestureRecognizer!
  @IBOutlet weak var goalTitle: UILabel!
  @IBOutlet weak var goalDetailTextField: UITextField!
  @IBOutlet weak var startTitle: UILabel!
  @IBOutlet weak var startTextField: UITextField!
  @IBOutlet weak var endTitle: UILabel!
  @IBOutlet weak var endTextField: UITextField!
  @IBOutlet weak var scheduleTitle: UILabel!
  @IBOutlet weak var scheduleDay: UILabel!
  @IBOutlet weak var scheduleDayDetail: UILabel!
  @IBOutlet weak var alarmTitle: UILabel!
  @IBOutlet weak var alarmTextField: UITextField!
  
  //MARK: - Model
  var picker: UIDatePicker = {
    let picker = UIDatePicker()
    let today = Date()
    picker.minimumDate = today
    picker.datePickerMode = .date
    picker.backgroundColor = UIColor.darkGray
    picker.tintColor = UIColor.white
    let loc = Locale.init(identifier: "ko")
    picker.locale = loc
    return picker
  }()
  
  var timePicker: UIDatePicker = {
    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    let loc = Locale.init(identifier: "ko")
    timePicker.locale = loc
    return timePicker
  }()
  
  var dateFormatter: DateFormatter = {
    let loc = Locale.init(identifier: "ko")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = loc
    return dateFormatter
  }()
  
  var timeFormatter: DateFormatter = {
    let loc = Locale.init(identifier: "ko")
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "a HH:mm"
    timeFormatter.amSymbol = "오전"
    timeFormatter.pmSymbol = "오후"
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    timeFormatter.locale = loc
    return timeFormatter
  }()
  //MARK: - Action
  @IBAction func saveButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    createDatePicker()
  }
}
// MARK: - Extension
extension PromissDetailViewController: UITextFieldDelegate {
  func createDatePicker() {
    // Toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    // Done button
    let done = UIBarButtonItem(title: "done", style: .done, target: nil, action: #selector(doneTouchAction))
    toolbar.setItems([done], animated: false)
    
    // TextField input toolbar/picker
    startTextField.inputAccessoryView = toolbar
    startTextField.inputView = picker
    endTextField.inputAccessoryView = toolbar
    endTextField.inputView = picker
    alarmTextField.inputAccessoryView = toolbar
    alarmTextField.inputView = timePicker
  }
  
  @objc func doneTouchAction() {
    let dateString = dateFormatter.string(from: picker.date)
    let timeString = timeFormatter.string(from: timePicker.date)
    
    self.view.endEditing(true)
  }
}

