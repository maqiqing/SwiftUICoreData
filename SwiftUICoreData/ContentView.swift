//
//  ContentView.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //去掉Listb背景颜色
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
//    @State var todoItems: [ToDoItem] = []
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: ToDoItem.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    var todoItems: FetchedResults<ToDoItem>
    
    @State var showNewTask = false
    @State private var offset: CGFloat = .zero //使用.animation防止报错，iOS15的特性
    
    var body: some View {
        
        ZStack {
            
            VStack {
                TopBarMenu(showNewTask: $showNewTask)
//                TodoListView(todoItems: $todoItems)
                List {
                    ForEach(todoItems) { todoItem in
                        TodoListRow(todoItem: todoItem)
                    }.onDelete(perform: deleteTask)
                }
            }
            
            if todoItems.count == 0 {
                NoDataView()
            }
            
            if showNewTask {
                
                MaskView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        self.showNewTask = false
                    }
                
                NewToDoView(name: "", priority: .normal, showNewTask: $showNewTask)
                    .transition(.move(edge: .bottom))
                    .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 10), value: offset)
                
            }
            
        }
        
        
    }
    
    
    private func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = todoItems[index]
            context.delete(itemToDelete)
        }
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 Pro")
    }
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
}


//顶部导航栏
struct TopBarMenu: View {
    
    @Binding var showNewTask: Bool
    
    var body: some View {
        
        HStack {
            Text("待办事项")
                .font(.system(size: 40, weight: .black))
            Spacer()
            Button {
                // 打开弹窗
                self.showNewTask = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle).foregroundColor(.blue)
            }
        }
        .padding()
    }
    
}

//缺省图
struct NoDataView: View {
    var body: some View {
        
        Image("noData")
            .frame(width: 200, height: 200)
//            .resizable()
            .scaledToFit()
        
    }
}

// 列表
struct TodoListView: View {
    
    @Binding var todoItems: [ToDoItem]
    
    var body: some View {
        
        List {
            ForEach(todoItems) { item in
                TodoListRow(todoItem: item)
            }
        }
        
    }
    
}


// 列表内容
struct TodoListRow: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var todoItem: ToDoItem
    
    var body: some View {
        
        Toggle(isOn: self.$todoItem.isCompleted) {
            HStack {
                
                Text(self.todoItem.name)
                    .strikethrough(self.todoItem.isCompleted, color: .black)
                    .bold()
                    .animation(.default)
                
                Spacer()
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(self.todoItem.priority.color)

            }
        }.toggleStyle(CheckboxStyle())
            .onReceive(todoItem.objectWillChange) { _ in
                if self.context.hasChanges {
                    try? self.context.save()
                }
            }
        
    }
    
}

// checkbox复选框样式
struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        return HStack {
            
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
            
        }
        
        
    }
    
    
    
}

