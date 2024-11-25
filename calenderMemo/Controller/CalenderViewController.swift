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
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCalendar()
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
        
        let calendar = Calendar.current
        let allLetters = realm.objects(Letter.self)
        
        for letter in allLetters {
            if let letterDate = DateFormatterUtils.date(from: letter.createdAt){
                let dateComponents = calendar.dateComponents([.day, .month, .year], from: letterDate)
                dateView.reloadDecorations(forDateComponents: [dateComponents], animated: true)
                print(letter.createdAt)
            }
        }
        
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
        if let selection = dateView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(nil, animated: true)  // 선택 해제
        }
        reloadDateView(date: nil)
    }
    
}

extension CalenderViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // UICalendarView
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        let dateString = DateFormatterUtils.formatDate(date ?? Date(), format: "yyyy-MM-dd")
        let letterAvailable = realm.objects(Letter.self).filter {
            $0.createdAt == dateString
        }
        if !letterAvailable.isEmpty {
            return .customView {
                let label = UILabel()
                label.text = "✍︎"
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
                if let date = calendar.date(from: selectedDate) {
                    detailVC.formattedDate = DateFormatterUtils.formatDate(date)
                }
            }
        }
    }
}

extension String {
    func toDateComponents() -> DateComponents {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            return Calendar.current.dateComponents([.day, .month, .year], from: date)
        }
        return DateComponents()
    }
}
