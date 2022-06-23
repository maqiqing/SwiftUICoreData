//
//  ToDoItem.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import Foundation
import CoreData
import SwiftUI

//任务紧急程度的枚举
enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
    
    var color: Color {
        switch self {
        case .low: return .green
        case .normal: return .orange
        case .high: return .red
        }
    }
}

//ToDoItem遵循ObservableObject协议
public class ToDoItem: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var priorityNum: Int32
    @NSManaged public var isCompleted: Bool
}
extension ToDoItem {
    
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityNum)) ?? .normal
        }
        set {
            self.priorityNum = Int32(newValue.rawValue)
        }
    }
    
}

////ToDoItem遵循ObservableObject协议
//class ToDoItem: ObservableObject, Identifiable {
//    var id = UUID()
//    @Published var name: String = ""
//    @Published var priority: Priority = .high
//    @Published var isCompleted: Bool = false
//
//    //实例化
//    init(name: String, priority: Priority = .normal, isCompleted: Bool = false) {
//        self.name = name
//        self.priority = priority
//        self.isCompleted = isCompleted
//    }
//}

