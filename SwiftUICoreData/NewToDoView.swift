//
//  NewToDoView.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import SwiftUI

struct NewToDoView: View {
    
    @State var name: String
    @State var priority: Priority
    @Binding var showNewTask: Bool
//    @Binding var todoItems: [ToDoItem]
    
    @ObservedObject var keyboardManager = KeyboardManager()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack {
                TopNavBar(showNewTask: $showNewTask)
                InputNameView(name: $name)
                PrioritySelectView(priority: $priority)
                SaveButton(name: $name, showNewTask: $showNewTask, priority: $priority)
            }
            .padding()
            .background(.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: -keyboardManager.keyboardHeight)
        }.edgesIgnoringSafeArea(.bottom)
        
    }
    
}

struct NewToDoView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoView(name: "", priority: .normal, showNewTask: .constant(true))
            .previewDevice("iPhone 13 Pro")
    }
}

struct TopNavBar: View {
    
    @Binding var showNewTask: Bool
    
    var body: some View {
        
        HStack {
            
            Text("新建事项")
                .font(.system(.title))
                .bold()
            
            Spacer()
            
            Button {
                self.showNewTask = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title)
            }
            
        }
        
    }
    
}


struct InputNameView: View {
    
    @Binding var name: String
    
    var body: some View {
        
        TextField("请输入", text: $name)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.bottom)
        
    }
    
}

// 选择优先级
struct PrioritySelectView: View {
    
    @Binding var priority: Priority
    
    var body: some View {
        
        HStack {
            
            PrioritySelectRow(name: "高", color: priority == .high ? .red : Color(.systemGray4))
                .onTapGesture {
                    self.priority = .high
                }
            PrioritySelectRow(name: "中", color: priority == .normal ? .orange : Color(.systemGray4))
                .onTapGesture {
                    self.priority = .normal
                }
            PrioritySelectRow(name: "低", color: priority == .low ? .green : Color(.systemGray4))
                .onTapGesture {
                    self.priority = .low
                }
            
        }
        
    }
    
}
// 选择优先级

struct PrioritySelectRow: View {
    
    var name: String
    var color: Color
    
    var body: some View {
        
        Text(name)
            .frame(width: 80)
            .font(.system(.headline))
            .padding(10)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
        
    }
    
}

struct SaveButton: View {
    
    @Binding var name: String
    @Binding var showNewTask: Bool
    
    @Binding var priority: Priority

//    @Binding var todoItems: [ToDoItem]
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        Button {
            
            //判断输入框是否为空
            if self.name.trimmingCharacters(in: .whitespaces) == "" {
                
                return
            }
            
            //添加一条新数据
            self.addTask(name: self.name, priority: self.priority)
            
            //关闭弹窗
            self.showNewTask = false
            
            
        } label: {
            Text("保存")
                .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
        }
        .padding([.top, .bottom])
        
    }
    
    //添加新事项方法
    private func addTask(name: String, priority: Priority, isComplete: Bool = false) {
        
        let task = ToDoItem(context: context)
        task.id = UUID()
        task.name = name
        task.priority = priority
        task.isCompleted = isComplete
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
}

// 蒙层
struct MaskView: View {
    
    var bgColor: Color

    var body: some View {
        
        VStack {
            
            Spacer()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
        
    }
    
}
