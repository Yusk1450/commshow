//
//  OSCRecive.swift
//  Day34
//
//  Created by ichinose-PC on 2025/03/22.
//

import Foundation
import OSCKit

class OSCRecive: ObservableObject, OSCUdpServerDelegate
{
    func server(_ server: OSCUdpServer, didReceivePacket packet: any OSCPacket, fromHost host: String, port: UInt16) {
        print("受け取った")

        if let message = packet as? OSCMessage
        {
            if let markerIDNumber = message.arguments.first as? NSNumber
            {
                print(markerIDNumber)
                SharedData.shared.opacity[markerIDNumber.intValue] -= 0.05
                print(SharedData.shared.opacity[markerIDNumber.intValue])
            }
        }
        
    }
    
    func server(_ server: OSCUdpServer, socketDidCloseWithError error: (any Error)?) {
        
    }
    
    func server(_ server: OSCUdpServer, didReadData data: Data, with error: any Error) {
        
    }
    
    private let oscServer:OSCUdpServer!
    
    
    init()
    {
        
        
        self.oscServer = OSCUdpServer(port: 55555)
        
        
        self.oscServer.delegate = self

        do
        {
            try self.oscServer.startListening()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
   
    
}
