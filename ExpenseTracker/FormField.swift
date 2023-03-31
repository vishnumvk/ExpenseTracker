//
//  FormField.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 24/03/23.
//

import UIKit


protocol FormField: AnyObject {

    var key: String { get }
    var height: CGFloat { get }

    func register(for tableView: UITableView)
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension FormField {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}





class DetailFieldData{
    
    init(fieldTitle: String, fieldValue: String) {
        self.fieldTitle = fieldTitle
        self.fieldValue = fieldValue
    }
    
    
    var fieldTitle: String
    var fieldValue: String
    
}


class DetailField{
    
    var data: DetailFieldData
    var key: String
    
    init(key: String, data: DetailFieldData){
        self.key = key
        self.data = data
    }
    
}

extension DetailField: FormField{
    var height: CGFloat {
        UITableView.automaticDimension
    }
    
    func register(for tableView: UITableView) {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseID)
    }
    
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseID, for: indexPath) as! DetailTableViewCell
            
        cell.configure(with: (title: data.fieldTitle, detail: data.fieldValue))
        
        return cell
                                             
    }
    
    
    
    
}





class AttachmentsFieldData{
    
    init(fieldTitle: String, data: [Data]) {
        self.fieldTitle = fieldTitle
        self.data = data
    }
    
    
    var fieldTitle: String
    var data: [Data]
    
}



protocol AttachmentsConfigurationHandler: AnyObject{
    
    func viewFor(field: AttachmentsField) -> UIView?
    
    func updateAttachmentsData(field: AttachmentsField, data: [Data])
}



class AttachmentsField{
    
    var data: AttachmentsFieldData
    var key: String
    
    weak var configurationHandler: AttachmentsConfigurationHandler?
    
    init(key: String, data: AttachmentsFieldData){
        self.key = key
        self.data = data
    }
    
}

extension AttachmentsField: FormField{
    var height: CGFloat {
        370
    }
    
    func register(for tableView: UITableView) {
        tableView.register(AttachmentsCell.self, forCellReuseIdentifier: AttachmentsCell.reuseID)
    }
    
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsCell.reuseID, for: indexPath) as! AttachmentsCell
        configurationHandler?.updateAttachmentsData(field: self, data: data.data)
        cell.setTitle(title: data.fieldTitle)
        if let view = configurationHandler?.viewFor(field: self){
            cell.attachmentsView = view
        }
        
        return cell
                                             
    }
    
    
    
    
}
