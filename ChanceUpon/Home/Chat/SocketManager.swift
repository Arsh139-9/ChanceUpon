//
//  SocketManager.swift
//  Blite
//
//  Created by Vivek Dharmani on 30/07/20.
//  Copyright © 2020 Dharmani Apps. All rights reserved.
//

import Foundation
import SocketIO



class SocketManger {
    
    static let shared = SocketManger()
    let manager = SocketManager(socketURL: URL(string: "http://jaohar-uk.herokuapp.com:80")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    init() {
        socket = manager.defaultSocket
    }
   
    
    func connect() {
        socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    func onConnect(handler: @escaping () -> Void) {
        socket.on("connect") { (_, _) in
            handler()
        }
    }
    func handleNewMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        socket.on("newMessage") { (data, ack) in
            print(data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    func handleJoinedMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        socket.on("ChatStatus") { (data, ack) in
            print(data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    func handleUserTyping(handler: @escaping (_ trueIndex: Int) -> Void) {
        socket.on("type") { (data, ack) in
            let trueIndex = data[1] as? Int
            handler(trueIndex!)
        }
    }
    func handleUserStopTyping(handler: @escaping () -> Void) {
        socket.on("userStopTyping") { (_, _) in
            handler()
        }
    }
}
