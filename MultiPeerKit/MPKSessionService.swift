//
//  MPKSessionService.swift
//  MultiPeerKit
//
//  Created by David Matura on 11/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

open class MPKSessionService: NSObject {
    
    private(set) var session: MCSession
    
    var myPeerID: MCPeerID {
        return session.myPeerID
    }
    
    var handler: MPKSessionServiceHandler?
    
    public init(displayName: String? = nil, handler: MPKSessionServiceHandler? = nil) {
        let myPeerId = MCPeerID(displayName: displayName ?? UIDevice.current.name)
        session = MCSession(peer: myPeerId)
        
        self.handler = handler
        
        super.init()
        session.delegate = self
    }
    
    open func reconnect(with displayName: String? = nil) {
        let myPeerId = MCPeerID(displayName: displayName ?? UIDevice.current.name)
        session = MCSession(peer: myPeerId)
        session.delegate = self
    }
    
    open func disconnect() {
        session.disconnect()
        session.delegate = nil
    }
    
}

extension MPKSessionService: MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            handler?.connected(to: peerID)
        case .connecting:
            handler?.connecting(to: peerID)
        case .notConnected:
            handler?.disconnected(from: peerID)
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        handler?.receivedData(from: peerID, data: data)
    }
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        handler?.didReceiveCertificate(certificate: certificate, from: peerID, certificateHandler: certificateHandler)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        handler?.didReceiveInputStream(stream: stream, streamName: streamName, from: peerID)
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        handler?.didStartReceivingResource(resourceName: resourceName, from: peerID, with: progress)
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        handler?.didFinishReceivingResource(resourceName: resourceName, from: peerID, at: localURL, withError: error)
    }
    
}
