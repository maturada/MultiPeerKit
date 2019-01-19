//
//  MPKManager.swift
//  MultiPeerKit
//
//  Created by David Matura on 12/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

open class MPKManager {
    
    enum MPKHandlerType {
        case session
        case advertiser
        case browser
        case all
    }
    
    let sessionService: MPKSessionService
    let advertiserService: MPKAdvertiserService
    let browserService: MPKBrowserService
    
    /// Session handler blocks.
    public var onConnectedBlock: ((_ peer: MCPeerID) -> Void)?
    public var onConnectingBlock: ((_ peer: MCPeerID) -> Void)?
    public var onDisconnectedBlock: ((_ peer: MCPeerID) -> Void)?
    public var onReceivedDataBlock: ((_ peer: MCPeerID, _ data: Data) -> Void)?
    
    /// Advertiser handler blocks.
    public var onDidReceiveInvitationBlock: ((_ peer: MCPeerID) -> Bool)?
    
    /// Browser handler blocks.
    public var onFoundPeerBlock: ((_ peer: MCPeerID, _ info: [String : String]?) -> Void)?
    public var onLostPeerBlock: ((_ peer: MCPeerID) -> Void)?
    
    private var session: MCSession {
        return sessionService.session
    }
    
    public init(displayName: String?) {
        sessionService = MPKSessionService(displayName: displayName)
        advertiserService = MPKAdvertiserService(session: sessionService.session)
        browserService = MPKBrowserService(session: sessionService.session)
        
        sessionService.handler = self
        advertiserService.handler = self
        browserService.handler = self
    }
    
    open func startTransceiving(serviceType: String? = nil, discoveryInfo: [String: String]? = nil) {
        advertiserService.start(serviceType: serviceType, discoveryInfo: discoveryInfo)
        browserService.start(serviceType: serviceType)
    }
    
    open func stopTransceiving() {
        advertiserService.stop()
        browserService.stop()
    }
    
    open func disconnect() {
        advertiserService.stop()
        browserService.stop()
        sessionService.disconnect()
    }
    
    open func sendResource(at url: URL, resourceName: String, to peers: [MCPeerID]? = nil, onCompletion: ((Error?) -> Void)?) -> [Progress?] {
        let peersToSend = peers ?? session.connectedPeers
        
        return peersToSend.compactMap { peer  in
            return session.sendResource(at: url, withName: resourceName, toPeer: peer, withCompletionHandler: onCompletion)
        }
    }
    
    open func sendData(to peers: [MCPeerID]? = nil, data: Data) {
        do {
            try sessionService.session.send(data, toPeers: peers ?? sessionService.session.connectedPeers, with: .reliable)
        }
        catch {
            // Catch error.
        }
    }
    
}

// MARK: - Session handler listeners.

extension MPKManager: MPKSessionServiceHandler {
    
    public func connecting(to peer: MCPeerID) {
        guard let onConnectingBlock = onConnectingBlock else {
            return
        }
        
        DispatchQueue.main.async {
            onConnectingBlock(peer)
        }
    }
    
    public func connected(to peer: MCPeerID) {
        guard let onConnectedBlock = onConnectedBlock else {
            return
        }
        
        DispatchQueue.main.async {
            onConnectedBlock(peer)
        }
    }
    
    public func disconnected(from peer: MCPeerID) {
        guard let onDisconnectedBlock = onDisconnectedBlock else {
            return
        }
        
        DispatchQueue.main.async {
            onDisconnectedBlock(peer)
        }
    }
    
    public func receivedData(from peer: MCPeerID, data: Data) {
        guard let onReceivedDataBlock = onReceivedDataBlock else {
            return
        }
        
        DispatchQueue.main.async {
            onReceivedDataBlock(peer, data)
        }
    }
    
}

// MARK: - Advertiser handler listeners.

extension MPKManager: MPKAdvertiserServiceHandler {
    
    public func didReceiveInvitation(from peer: MCPeerID, with context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let onDidReceiveInvitationBlock = onDidReceiveInvitationBlock else {
            invitationHandler(false, nil)
            return
        }
        
        if onDidReceiveInvitationBlock(peer) {
            invitationHandler(true, session)
        } else {
            invitationHandler(false, nil)
        }
    }
    
}

// MARK: - Browser handler listeners.

extension MPKManager: MPKBrowserServiceHandler {
    
    public func foundPeer(peer: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let onFoundPeerBlock = onFoundPeerBlock else {
            return
        }
        
        onFoundPeerBlock(peer, info)
    }
    
    public func lostPeer(peer: MCPeerID) {
        guard let onLostPeerBlock = onLostPeerBlock else {
            return
        }
        
        onLostPeerBlock(peer)
    }
    
}

