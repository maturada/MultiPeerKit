//
//  MPKBrowserServiceHandler.swift
//  MultiPeerKit
//
//  Created by David Matura on 12/07/2018.
//  Copyright © 2018 David Matura. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol MPKBrowserServiceHandler: class {
    func foundPeer(peer: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func lostPeer(peer: MCPeerID)
}
