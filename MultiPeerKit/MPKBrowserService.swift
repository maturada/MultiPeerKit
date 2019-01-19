//
//  MPKBrowserService.swift
//  MultiPeerKit
//
//  Created by David Matura on 12/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

private let defaultServiceType = "MPK-type"

open class MPKBrowserService: NSObject {
    
    private var browser: MCNearbyServiceBrowser?
    
    let session: MCSession
    
    var invitationTimeOut: TimeInterval = 20
    var foundPeers = [MCPeerID]()
    var handler: MPKBrowserServiceHandler?
    
    public init(session: MCSession, handler: MPKBrowserServiceHandler? = nil) {
        self.session = session
        self.handler = handler

        super.init()
    }
    
    open func start(serviceType: String? = nil) {
        browser = MCNearbyServiceBrowser(peer: session.myPeerID, serviceType: serviceType ?? defaultServiceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    open func stop() {
        browser?.delegate = nil
        browser?.stopBrowsingForPeers()
        foundPeers = []
    }
    
}

extension MPKBrowserService: MCNearbyServiceBrowserDelegate {
    
    open func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard foundPeers.contains(peerID) == false else {
            return
        }
        
        foundPeers.append(peerID)
        
        handler?.foundPeer(peer: peerID, withDiscoveryInfo: info)
    }
    
    open func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = foundPeers.index(of: peerID) else {
            return
        }
        
        foundPeers.remove(at: index)
        
        handler?.lostPeer(peer: peerID)
    }
    
}
