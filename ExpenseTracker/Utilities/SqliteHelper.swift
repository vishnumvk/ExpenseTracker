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
    let db: OpaquePointer
    
    init(databasePath: String) throws {
        var db: OpaquePointer? = nil
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        self.db = db!
    }
    
    deinit {
        sqlite3_close(db)
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

    
    
    
    
    
    func insert(table: String, values: [Any]) throws {
        let questionMarks = Array(repeating: "?", count: values.count).joined(separator: ",")
        let query = "INSERT INTO \(table) VALUES (\(questionMarks))"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.sqliteError(message: String(cString: sqlite3_errmsg(db)))
        }
        defer {
            sqlite3_finalize(statement)
        }
        bindValues(statement!, values)
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

    
    
    func update(table: String, values: [String: Any], where condition: String) throws {
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

    
    
    
    
    func bindValues(_ statement: OpaquePointer, _ values: [Any]) {
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
                default:
                    fatalError("Unexpected value type")
            }
        }
    }
    
}






