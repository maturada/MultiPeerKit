# MultiPeerKit
Multipeer connectivity library.

MPKManager handles everything for you through the completion blocks & listeners/handlers.
Setup handlers and blocks and that's all you need to do.

```Swift

let manager = MPKManager(displayName: "DisplayName") /// Se your display name.
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

**MPKBrowserService** searches for other devices near by, easy to setup only when need to.

## Setup

*pod 'MultiPeerKit', :git => 'https://github.com/maturada/MultiPeerKit'*

*import MultiPeerKit*
