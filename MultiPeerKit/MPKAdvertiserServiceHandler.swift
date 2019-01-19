//
//  MPKAdvertiserServiceHandler.swift
//  MultiPeerKit
//
//  Created by David Matura on 11/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol MPKAdvertiserServiceHandler {
    func didReceiveInvitation(from peer: MCPeerID, with context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    func didNotStartAdvertisingPeer(error: Error)
}

extension MPKAdvertiserServiceHandler {
    
    public func didReceiveInvitation(from peer: MCPeerID, with context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // This is a empty implementation to allow this method to be optional.
    }
    
    public func didNotStartAdvertisingPeer(error: Error) {
        // This is a empty implementation to allow this method to be optional.
    }
    
}
