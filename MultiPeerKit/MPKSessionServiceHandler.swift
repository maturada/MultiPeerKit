//
//  MPKSessionServiceHandler.swift
//  MultiPeerKit
//
//  Created by David Matura on 11/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol MPKSessionServiceHandler {
    func connecting(to peer: MCPeerID)
    func connected(to peer: MCPeerID)
    func disconnected(from peer: MCPeerID)
    func receivedData(from peer: MCPeerID, data: Data)
    func didReceiveCertificate(certificate: [Any]?, from peer: MCPeerID, certificateHandler: @escaping (Bool) -> Void)
    func didReceiveInputStream(stream: InputStream, streamName: String, from peer: MCPeerID)
    func didStartReceivingResource(resourceName: String, from peer: MCPeerID, with progress: Progress)
    func didFinishReceivingResource(resourceName: String, from peer: MCPeerID, at localURL: URL?, withError error: Error?)
}

extension MPKSessionServiceHandler {
    
    /// Override if needed.
    
    public func didReceiveCertificate(certificate: [Any]?, from peer: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        // Empty implementation.
    }
    
    public func didReceiveInputStream(stream: InputStream, streamName: String, from peer: MCPeerID) {
        // Empty implementation.
    }
    
    public func didStartReceivingResource(resourceName: String, from peer: MCPeerID, with progress: Progress) {
        // Empty implementation.
    }
    
    public func didFinishReceivingResource(resourceName: String, from peer: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Empty implementation.
    }
    
}
