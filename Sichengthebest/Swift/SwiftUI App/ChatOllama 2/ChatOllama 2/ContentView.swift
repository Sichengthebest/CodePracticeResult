//
//  ContentView.swift
//  ChatOllama 2
//
//  Created by Sicheng Jiang on 2024-06-15.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var cvm = ChatViewModel()
    @State var mvm = MessageViewModel()
    @AppStorage("selectedModel") var selectedModel = ""
    @Environment(\.modelContext) private var modelContext
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var message = ""
    @Query private var chat: [Dialogue]

    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: $message)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .onSubmit {
                        sendMessage()
                    }
            }
            HStack {
                Picker("Model", selection: $cvm.selectedModel) {
                    Text("Select a model")
                    ForEach(cvm.availModels, id: \.self.name) {
                        Text($0.name)
                    }
                }
                .onReceive(timer) { _ in
                    Task {
                        await cvm.checkReachable()
                        await cvm.getModels()
                    }
                }
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(chat[index])
//            }
//        }
//    }
    
    func sendMessage() {
        message = ""
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Dialogue.self, inMemory: true)
        .frame(width: 500,height: 200)
}
