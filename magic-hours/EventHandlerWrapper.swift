//
//  EventHandlerWrapper.swift
//  magic-hours
//
//  Created by Agata on 17/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
class EventHandlerWrapper<T: AnyObject, U> : Invocable, Disposable
{
	weak var target: T?
	let handler: (T) -> (U) -> ()
	let event: Event<U>
	
	init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
		self.target = target
		self.handler = handler
		self.event = event;
	}
	
	func invoke(data: Any) -> () {
		if let t = target {
			handler(t)(data as! U)
		}
	}
	
	func dispose() {
		event.eventHandlers =
			event.eventHandlers.filter { $0 !== self }
	}
}

public protocol Disposable {
	func dispose()
}
