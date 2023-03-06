//
//  SqliteHelper.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 24/01/23.
//

import Foundation
import SQLite3




enum SQLiteError: Error {
    case sqliteError(message: String)
    
}

class SQLiteHelper {
    private let db: OpaquePointer
    
    init(databasePath: String) throws {
        var db: OpaquePointer? = nil
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        self.db = db!
        guard (try? self.execute(query: "PRAGMA foreign_keys = ON")) != nil else{
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        
        print("db connected!")
    }
    
    deinit {
        sqlite3_close(db)
        print("db closed!")
    }
    
    
    
    
    func execute(query: String) throws {
        
        
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
    }

    
    
    
    
    
    func insert(table: String, values: [String : Any?]) throws {
        let questionMarks = Array(repeating: "?", count: values.count).joined(separator: ",")
        
        
        var coloumNames = [String]()
        var coloumValues = [Any?]()
        values.forEach{
            coloumNames.append($0.key)
            coloumValues.append($0.value)
        }
        
        let query = "INSERT INTO \(table) (\(coloumNames.joined(separator: ","))) VALUES (\(questionMarks))"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        bindValues(statement!, coloumValues)
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
    }
    
    func select(table: String, columns: [String], whereClause: String? = nil) throws -> [[String: Any]] {
        let columnsString = columns.joined(separator: ",")
        var query = "SELECT \(columnsString) FROM \(table)"
        if let whereClause = whereClause {
            query += " WHERE \(whereClause)"
        }
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        var results: [[String: Any]] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String: Any] = [:]
            for i in 0..<sqlite3_column_count(statement) {
                let name = String(cString: sqlite3_column_name(statement, i))
                switch sqlite3_column_type(statement, i) {
                case SQLITE_INTEGER:
                    row[name] = sqlite3_column_int64(statement, i)
                case SQLITE_FLOAT:
                    row[name] = sqlite3_column_double(statement, i)
                case SQLITE_TEXT:
                    row[name] = String(cString: sqlite3_column_text(statement, i))
                case SQLITE_BLOB:
                    if let bytes = sqlite3_column_blob(statement, i) {
                        let data = Data(bytes: bytes, count: Int(sqlite3_column_bytes(statement, i)))
                        row[name] = data
                    }
                    else {
                        row[name] = nil
                    }
                default:
                    row[name] = nil
                }
            }
            results.append(row)
        }
        return results
    }
    
    
    func createTable(table: String, columns: [(name: String, type: String)]) throws {
        let columnDefinitions = columns.map { "\($0.name) \($0.type)" }.joined(separator: ",")
        let query = "CREATE TABLE IF NOT EXISTS \(table) (\(columnDefinitions))"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
    }

    
    
    func delete(from table: String, where condition: String) throws {
        let query = "DELETE FROM \(table) WHERE \(condition)"
        print(query)
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
    }

    
    
    func update(table: String, values: [String: Any?], where condition: String) throws {
        let valueAssignments = values.map { "\($0.0) = ?" }.joined(separator: ",")
        let query = "UPDATE \(table) SET \(valueAssignments) WHERE \(condition)"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        bindValues(statement!, values.map { $0.1 })
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
    }

    
    
    
    
    func bindValues(_ statement: OpaquePointer, _ values: [Any?]) {
        for i in 0..<values.count {
            let value = values[i]
            switch value {
            case let intValue as Int:
                sqlite3_bind_int(statement, Int32(i + 1), Int32(intValue))
            case let doubleValue as Double:
                sqlite3_bind_double(statement, Int32(i + 1), doubleValue)
            case let stringValue as String:
                sqlite3_bind_text(statement, Int32(i + 1), (stringValue as NSString).utf8String, -1, nil)
            case let dataValue as Data:
                let _ = dataValue.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                    sqlite3_bind_blob(statement, Int32(i + 1), bytes.baseAddress, Int32(dataValue.count), nil)
                }
                
            case .none:
                sqlite3_bind_null(statement, Int32(i + 1))
                
            default:
                fatalError("unsupported sqlite type")
                
            }
            
        }
    }
    
    
    func executeSelect(query: String) throws -> [[String: Any]] {

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        var results: [[String: Any]] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String: Any] = [:]
            for i in 0..<sqlite3_column_count(statement) {
                let name = String(cString: sqlite3_column_name(statement, i))
                switch sqlite3_column_type(statement, i) {
                case SQLITE_INTEGER:
                    row[name] = sqlite3_column_int64(statement, i)
                case SQLITE_FLOAT:
                    row[name] = sqlite3_column_double(statement, i)
                case SQLITE_TEXT:
                    row[name] = String(cString: sqlite3_column_text(statement, i))
                case SQLITE_BLOB:
                    if let bytes = sqlite3_column_blob(statement, i) {
                        let data = Data(bytes: bytes, count: Int(sqlite3_column_bytes(statement, i)))
                        row[name] = data
                    }
                    else {
                        row[name] = nil
                    }
                default:
                    row[name] = nil
                }
            }
            results.append(row)
        }
        return results
    }
    
    
    
    
    
    func closeDB(){
        if sqlite3_close(db) == SQLITE_OK {
            print("CLOSED db")
        }
    }
    
}




class DataBase{
    
    static let dbfile = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("ExpenseTracker.sqlite")
    
    
    private init(){
        
    }
    
    static let shared = DataBase()
    
    let sqlHelper = try! SQLiteHelper(databasePath: dbfile.path)
    
    func setUpTables(){
        print(DataBase.dbfile)
        try! sqlHelper.execute(query: "CREATE  TABLE IF NOT EXISTS  Expenses(id TEXT PRIMARY KEY, amount DOUBLE, title TEXT, category TEXT,note TEXT, createdDate DOUBLE);")
        
        try! sqlHelper.execute(query: "CREATE TABLE IF NOT EXISTS  Attachments(id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, expenseId TEXT, FOREIGN KEY(expenseId) REFERENCES Expenses(id));")
        
    }
    
    func closeDB(){
        sqlHelper.closeDB()
    }
    
}



