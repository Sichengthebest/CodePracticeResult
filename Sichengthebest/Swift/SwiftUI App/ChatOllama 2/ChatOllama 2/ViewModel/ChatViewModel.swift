//
//  ChatViewModel.swift
//  ChatOllama 2
//
//  Created by Sicheng Jiang on 2024-06-15.
//

import SwiftUI
import OllamaKit

class ChatViewModel {
    private let ollamaKit = OllamaKit(baseURL: URL(string: "http://localhost:11434")!)
    
    var reachable = false
    var selectedModel: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedModel") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedModel")
        }
    }
    var availModels: [OKModelResponse.Model] = []
    
    func checkReachable() async {
        reachable = await ollamaKit.reachable()
    }
    func getModels() async {
        do {
            availModels = try await ollamaKit.models().models
        } catch {
            
        }
        
    }
}
