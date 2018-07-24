//
//  MonacoWebView.swift
//  Fractal
//  Copyright © 2018 Giuseppe Salvo. All rights reserved.
//

import WebKit
import Cocoa

public class MonacoWebView: WKWebView {
    
    private let messageHandler: WKScriptMessageHandler!
    
    override public var isOpaque: Bool {
        return false
    }
    
    required public init(frame: CGRect, messageHandler: WKScriptMessageHandler, handlers: [String]) {
        
        let contentController = WKUserContentController()
        
        let config = WKWebViewConfiguration()
            config.userContentController = contentController
        
        //set the native handlers for the post back of the JS methods
        for handler in handlers {
            contentController.add( messageHandler, name: handler )
        }
        
        self.messageHandler = messageHandler
        super.init(frame: frame, configuration: config)
        
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        // This is a bad thing, but the only one that works
        self.setValue(NSNumber(value: false), forKey: "drawsBackground")
    }
    
    // 100% of the parent view, without margins
    public func setAutoLayout(container:NSView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    }
    
    // MonacoWebView cannot be used from storyboard because it needs a messageHandler
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) -> MonacoWebView cannot be used from storyboard")
    }
    
    public override func mouseUp(with event: NSEvent) {
        self.window?.makeFirstResponder(self)
        super.mouseUp(with: event)
    }
}