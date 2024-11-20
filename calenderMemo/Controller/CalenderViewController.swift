//
//  ViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/8/24.
//

import UIKit
import RealmSwift

class CalenderViewController: UIViewController {
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var selectedDate: DateComponents? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    fileprivate func applyConstraints() {
        view.addSubview(dateView)
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
        resetSelectedDate()
    }
    
    func resetSelectedDate() {
        selectedDate = nil
        if let selection = dateView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(nil, animated: true)  // 선택 해제
        }
        reloadDateView(date: nil)
    }
    
}

extension CalenderViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // UICalendarView
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "✅"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    // 달력에서 날짜 선택했을 경우
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        reloadDateView(date: Calendar.current.date(from: dateComponents!))
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" , let detailVC = segue.destination as? DetailTableViewController{
            if let selectedDate = selectedDate {
                let calendar = Calendar.current
                detailVC.selectedDate = calendar.date(from: selectedDate)
            }
        }
    }
}
