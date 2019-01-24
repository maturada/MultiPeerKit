# MultiPeerKit
![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)

MPKManager handles everything for you through the completion blocks & listeners/handlers.
Setup handlers and blocks and that's all you need to do.

```Swift

let manager = MPKManager(displayName: "DisplayName") /// Set your display name.
manager.startTransceiving()
        
// Display all devices found in your area in your list.
manager.onFoundPeerBlock = { peer, info in
            
  self.peersName.append(peer.displayName)
  self.tableView.reloadData()
}

// Receive invitations and send data.
manager.onDidReceiveInvitationBlock = { peer in
            
  if let dataMessage = "Hey, thanks for your invitations".data(using: .utf8) {
    // Send data to specific peers or all to your connected ones.            
    manager.sendData(to: [peer], data: dataMessage) 
  }

  self.connectedPeer = peer
  return true // Accepting invitations.
}


// And more.... 
// onConnected, onConnecting ...
```

Instanciate your own **MPKManager** with your display name and start transmitting or receiving data.
Easy to connect your devices together through MPK kit, send or receive data like messages, images or just simple texts.
 
Advertiser, Browser and other services can be used separately along with the rest.

**MPKAdvertiseService** sends informations as your display name to notify devices in your area.

```Swift
public protocol MPKAdvertiserServiceHandler {
     // Delegates informations about received invitations or advertising issues. 
    func didReceiveInvitation(from peer: MCPeerID, with context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    func didNotStartAdvertisingPeer(error: Error)
}
```

**MPKBrowserService** searches for other devices near by, easy to setup only when need to.

```Swift
public protocol MPKBrowserServiceHandler: class {
     // Delegates lost/found peers in your area.
    func foundPeer(peer: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func lostPeer(peer: MCPeerID)
}
```

## How to use?

```Ruby
pod 'MultiPeerKit', :git => 'https://github.com/maturada/MultiPeerKit'
```

```Ruby
import MultiPeerKit
```
