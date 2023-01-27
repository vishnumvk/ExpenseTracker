//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/01/23.
//

import UIKit
import SQLite3

class AddExpenseVC: UIViewController {
    
    lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    let testView = UIView(frame: .init(x: 196.5, y: 457.83333333333337, width: 200, height: 200))
    let chart = PieChartView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add Expense"
       
//        view.addSubview(stackView)
//        stackView.pinTo(view: view)
//
//        stackView.alignment = .fill
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
        
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.dataSet = [(-0.2,.black),(-0.3,.systemCyan),(-0.25,.magenta),(-0.25,.brown)]
        view.addSubview(chart)
        chart.backgroundColor = .gray
        chart.pinTo(view: view)
        chart.radius = 100
        let btn = UIBarButtonItem(title: "click", style: .done, target: self, action: #selector(changeData))
        navigationItem.rightBarButtonItem = btn
        
        
        
        let testView = UIView(frame: .init(x: 196.5, y: 457.83333333333337, width: 200, height: 200))
        testView.translatesAutoresizingMaskIntoConstraints = false

        chart.addSubview(testView)
        chart.bringSubviewToFront(testView)
        testView.backgroundColor = .yellow

        testView.centerXAnchor.constraint(equalTo: chart.centerXAnchor).isActive = true
        testView.centerYAnchor.constraint(equalTo: chart.centerYAnchor).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        testView.widthAnchor.constraint(equalToConstant: 70).isActive = true


        
    }
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let testView = UIView(frame: .init(x: 196.5, y: 457.83333333333337, width: 20, height: 20))
//        testView.translatesAutoresizingMaskIntoConstraints = false
//        chart.layoutSubviews()
//        chart.addSubview(testView)
//        testView.backgroundColor = .yellow
//        testView.centerXAnchor.constraint(equalTo: testView.centerXAnchor).isActive = true
//        testView.centerYAnchor.constraint(equalTo: testView.centerYAnchor).isActive = true
//        testView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        testView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//

        print(chart.center)
        print(testView.center)

    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("did layout msg")
//        print(chart.center)
//        print(testView.center)
//    }
    
    
   
    var clicked = true
    @objc func changeData(){
        //        chart.alpha = 0
        //        if clicked {
        //            UIView.animate(withDuration: 2, delay: 0) { [self] in
        //                chart.alpha = 1
        //                chart.radius = 100
        //                chart.dataSet = [(0.25,.yellow),(0.25,.systemCyan),(0.2,.magenta),(0.3,.blue)]
        //            }
        //            clicked = !clicked
        //        }else{
        //
        //            UIView.animate(withDuration: 2, delay: 0) { [self] in
        //                chart.alpha = 1
        //                chart.radius = 150
        //                chart.dataSet = [(-0.2,.black),(-0.3,.systemCyan),(-0.25,.magenta),(-0.25,.brown)]
        //            }
        //            clicked = !clicked
        //        }
        //    }
        
        UIView.animate(withDuration: 2, delay: 0) {
            self.chart.layer.setAffineTransform(self.chart.layer.affineTransform().rotated(by: Double.pi))
            self.chart.radius = 150
        }
    }
    
}



























extension UIView{
    func pinTo(view: UIView){
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        ])
    }
}



//enum SQLiteError: Error {
//    case sqliteError(message: String)
//
//}
//
//class SQLiteHelper {
//    let db: OpaquePointer
//
//    init(databasePath: String) throws {
//        var db: OpaquePointer? = nil
//        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        self.db = db!
//    }
//
//    deinit {
//        sqlite3_close(db)
//    }
//
//
//
//
//    func execute(query: String) throws {
//
//
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        guard sqlite3_step(statement) == SQLITE_DONE else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//    }
//
//
//
//
//
//
//    func insert(table: String, values: [Any]) throws {
//        let questionMarks = Array(repeating: "?", count: values.count).joined(separator: ",")
//        let query = "INSERT INTO \(table) VALUES (\(questionMarks))"
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        bindValues(statement!, values)
//        guard sqlite3_step(statement) == SQLITE_DONE else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//    }
//
//    func select(table: String, columns: [String], whereClause: String? = nil) throws -> [[String: Any]] {
//        let columnsString = columns.joined(separator: ",")
//        var query = "SELECT \(columnsString) FROM \(table)"
//        if let whereClause = whereClause {
//            query += " WHERE \(whereClause)"
//        }
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        var results: [[String: Any]] = []
//        while sqlite3_step(statement) == SQLITE_ROW {
//            var row: [String: Any] = [:]
//            for i in 0..<sqlite3_column_count(statement) {
//                let name = String(cString: sqlite3_column_name(statement, i))
//                switch sqlite3_column_type(statement, i) {
//                case SQLITE_INTEGER:
//                    row[name] = sqlite3_column_int64(statement, i)
//                case SQLITE_FLOAT:
//                    row[name] = sqlite3_column_double(statement, i)
//                case SQLITE_TEXT:
//                    row[name] = String(cString: sqlite3_column_text(statement, i))
//                case SQLITE_BLOB:
//                    if let bytes = sqlite3_column_blob(statement, i) {
//                        let data = Data(bytes: bytes, count: Int(sqlite3_column_bytes(statement, i)))
//                        row[name] = data
//                    }
//                    else {
//                        row[name] = nil
//                    }
//                default:
//                    row[name] = nil
//                }
//            }
//            results.append(row)
//        }
//        return results
//    }
//
//
//    func createTable(table: String, columns: [(name: String, type: String)]) throws {
//        let columnDefinitions = columns.map { "\($0.name) \($0.type)" }.joined(separator: ",")
//        let query = "CREATE TABLE IF NOT EXISTS \(table) (\(columnDefinitions))"
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        guard sqlite3_step(statement) == SQLITE_DONE else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//    }
//
//
//
//    func delete(from table: String, where condition: String) throws {
//        let query = "DELETE FROM \(table) WHERE \(condition)"
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        guard sqlite3_step(statement) == SQLITE_DONE else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//    }
//
//
//
//    func update(table: String, values: [String: Any], where condition: String) throws {
//        let valueAssignments = values.map { "\($0.0) = ?" }.joined(separator: ",")
//        let query = "UPDATE \(table) SET \(valueAssignments) WHERE \(condition)"
//        var statement: OpaquePointer?
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//        defer {
//            sqlite3_finalize(statement)
//        }
//        bindValues(statement!, values.map { $0.1 })
//        guard sqlite3_step(statement) == SQLITE_DONE else {
//            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
//        }
//    }
//
//
//
//
//
//    func bindValues(_ statement: OpaquePointer, _ values: [Any]) {
//        for i in 0..<values.count {
//            let value = values[i]
//            switch value {
//                case let intValue as Int64:
//                    sqlite3_bind_int64(statement, Int32(i + 1), intValue)
//                case let doubleValue as Double:
//                    sqlite3_bind_double(statement, Int32(i + 1), doubleValue)
//                case let stringValue as String:
//                    sqlite3_bind_text(statement, Int32(i + 1), stringValue, -1, nil)
//                case let dataValue as Data:
//                   let _ = dataValue.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
//                        sqlite3_bind_blob(statement, Int32(i + 1), bytes.baseAddress, Int32(dataValue.count), nil)
//                    }
//                default:
//                    fatalError("Unexpected value type")
//            }
//        }
//    }
//
//}





