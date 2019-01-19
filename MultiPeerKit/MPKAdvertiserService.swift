//
//  MPKAdvertiserService.swift
//  MultiPeerKit
//
//  Created by David Matura on 11/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

private let defaultServiceType = "MPK-type"

open class MPKAdvertiserService: NSObject {
    
    private var advertiser: MCNearbyServiceAdvertiser?
    
    let session: MCSession
    var autoConnection: Bool = false
    
    var handler: MPKAdvertiserServiceHandler?
    
    public init(session: MCSession, handler: MPKAdvertiserServiceHandler? = nil) {
        self.session = session
        self.handler = handler
        
        super.init()
    }
    
    open func start(serviceType: String? = nil, discoveryInfo: [String: String]? = nil) {
        advertiser = MCNearbyServiceAdvertiser(peer: session.myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType ?? defaultServiceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    open func stop() {
        advertiser?.delegate = nil
        advertiser?.stopAdvertisingPeer()
    }
    
}

extension MPKAdvertiserService: MCNearbyServiceAdvertiserDelegate {
    
    open func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard autoConnection else {
            handler?.didReceiveInvitation(from: peerID, with: context, invitationHandler: invitationHandler)
            return
        }
        
        invitationHandler(true, session)
        
    }
    
    open func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        handler?.didNotStartAdvertisingPeer(error: error)
    }
    
}
