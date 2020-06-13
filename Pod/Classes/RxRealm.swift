//
//  RxRealm extensions
//
//  Copyright (c) 2016 RxSwiftCommunity. All rights reserved.
//  Check the LICENSE file for details
//  Created by Marin Todorov
//

import Foundation
import RealmSwift
import RxSwift

public enum RxRealmError: Error {
    case objectDeleted
    case unknown
}

// MARK: Realm Collections type extensions

/**
 `NotificationEmitter` is a protocol to allow for Realm's collections to be handled in a generic way.
<<<<<<< HEAD
 
 All collections already include a `addNotificationBlock(_:)` method - making them conform to `NotificationEmitter` just makes it easier to add Rx methods to them.
 
 The methods of essence in this protocol are `asObservable(...)`, which allow for observing for changes on Realm's collections.
 */
public protocol NotificationEmitter {
    
=======

 All collections already include a `addNotificationBlock(_:)` method - making them conform to `NotificationEmitter` just makes it easier to add Rx methods to them.

 The methods of essence in this protocol are `asObservable(...)`, which allow for observing for changes on Realm's collections.
 */
public protocol NotificationEmitter {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    associatedtype ElementType: RealmCollectionValue
    
    /**
     Returns a `NotificationToken`, which while retained enables change notifications for the current collection.

     - returns: `NotificationToken` - retain this value to keep notifications being emitted for the current collection.
     */
<<<<<<< HEAD
    func observe(_ block: @escaping (RealmCollectionChange<Self>) -> ()) -> NotificationToken
    
=======
    func observe(on queue: DispatchQueue?, _ block: @escaping (RealmCollectionChange<Self>) -> Void) -> NotificationToken

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    func toArray() -> [ElementType]
    
    func toAnyCollection() -> AnyRealmCollection<ElementType>
}

extension List: NotificationEmitter {
    public func toAnyCollection() -> AnyRealmCollection<Element> {
        return AnyRealmCollection<Element>(self)
    }

    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}

extension AnyRealmCollection: NotificationEmitter {
    public func toAnyCollection() -> AnyRealmCollection<Element> {
        return AnyRealmCollection<ElementType>(self)
    }

    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}

extension Results: NotificationEmitter {
    public func toAnyCollection() -> AnyRealmCollection<Element> {
        return AnyRealmCollection<ElementType>(self)
    }

    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}

extension LinkingObjects: NotificationEmitter {
    public func toAnyCollection() -> AnyRealmCollection<Element> {
        return AnyRealmCollection<ElementType>(self)
    }

    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}

/**
 `RealmChangeset` is a struct that contains the data about a single realm change set.

 It includes the insertions, modifications, and deletions indexes in the data set that the current notification is about.
 */
public struct RealmChangeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]

    /// the indexes in the collection that were inserted
    public let inserted: [Int]

    /// the indexes in the collection that were modified
    public let updated: [Int]
}

<<<<<<< HEAD
public extension ObservableType where E: NotificationEmitter {
    
=======
public extension ObservableType where Element: NotificationEmitter {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    @available(*, deprecated, renamed: "collection(from:synchronousStart:)")
    static func from(_ collection: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Element> {
        return self.collection(from: collection)
    }
    
    /**
     Returns an `Observable<Element>` that emits each time the collection data changes.
     The observable emits an initial value upon subscription.
<<<<<<< HEAD
     
     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting `Observable` should emit its first element synchronously (e.g. better for UI bindings)
     
     - returns: `Observable<E>`, e.g. when called on `Results<Model>` it will return `Observable<Results<Model>>`, on a `List<User>` it will return `Observable<List<User>>`, etc.
     */
    public static func collection(from collection: E, synchronousStart: Bool = true)
        -> Observable<E> {
            
=======

     - parameter from: A Realm collection of type `Element`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting `Observable` should emit its first element synchronously (e.g. better for UI bindings)
     - parameter queue: The serial dispatch queue to receive notification on. If `nil`, notifications are delivered to the current thread.

     - returns: `Observable<Element>`, e.g. when called on `Results<Model>` it will return `Observable<Results<Model>>`, on a `List<User>` it will return `Observable<List<User>>`, etc.
     */
    static func collection(from collection: Element, synchronousStart: Bool = true, on queue: DispatchQueue? = nil)
        -> Observable<Element> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            return Observable.create { observer in
                if synchronousStart {
                    observer.onNext(collection)
                }
<<<<<<< HEAD
                
                let token = collection.observe { changeset in
                    
                    let value: E
                    
                    switch changeset {
                    case .initial(let latestValue):
=======

                let token = collection.observe(on: queue) { changeset in

                    let value: Element

                    switch changeset {
                    case let .initial(latestValue):
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                        guard !synchronousStart else { return }
                        value = latestValue
                        
                    case .update(let latestValue, _, _, _):
                        value = latestValue
<<<<<<< HEAD
                        
                    case .error(let error):
                        observer.onError(error)
                        return
                    }
                    
                    observer.onNext(value)
                }
                
=======

                    case let .error(error):
                        observer.onError(error)
                        return
                    }

                    observer.onNext(value)
                }

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                return Disposables.create {
                    token.invalidate()
                }
            }
    }
    
    @available(*, deprecated, renamed: "array(from:synchronousStart:)")
    static func arrayFrom(_ collection: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<[Element.ElementType]> {
        return array(from: collection)
    }
    
    /**
     Returns an `Observable<Array<Element.Element>>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     The result emits an array containing all objects from the source collection.
<<<<<<< HEAD
     
     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)
     
     - returns: `Observable<Array<E.Element>>`, e.g. when called on `Results<Model>` it will return `Observable<Array<Model>>`, on a `List<User>` it will return `Observable<Array<User>>`, etc.
     */
    public static func array(from collection: E, synchronousStart: Bool = true)
        -> Observable<Array<E.ElementType>> {
            
            return Observable.collection(from: collection, synchronousStart: synchronousStart)
=======

     - parameter from: A Realm collection of type `Element`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)
     - parameter queue: The serial dispatch queue to receive notification on. If `nil`, notifications are delivered to the current thread.

     - returns: `Observable<Array<Element.Element>>`, e.g. when called on `Results<Model>` it will return `Observable<Array<Model>>`, on a `List<User>` it will return `Observable<Array<User>>`, etc.
     */
    static func array(from collection: Element, synchronousStart: Bool = true, on queue: DispatchQueue? = nil)
        -> Observable<[Element.ElementType]> {
            return Observable.collection(from: collection, synchronousStart: synchronousStart, on: queue)
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                .map { $0.toArray() }
    }
    
    @available(*, deprecated, renamed: "changeset(from:synchronousStart:)")
    static func changesetFrom(_ collection: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<(AnyRealmCollection<Element.ElementType>, RealmChangeset?)> {
        return changeset(from: collection)
    }
    
    /**
<<<<<<< HEAD
     Returns an `Observable<(E, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
=======
     Returns an `Observable<(Element, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
     When the observable emits for the first time (if the initial notification is not coalesced with an update) the second tuple value will be `nil`.
     
     Each following emit will include a `RealmChangeset` with the indexes inserted, deleted or modified.

     - parameter from: A Realm collection of type `Element`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)
<<<<<<< HEAD
     
     - returns: `Observable<(AnyRealmCollection<E.Element>, RealmChangeset?)>`
     */
    public static func changeset(from collection: E, synchronousStart: Bool = true)
        -> Observable<(AnyRealmCollection<E.ElementType>, RealmChangeset?)> {
            
=======
     - parameter queue: The serial dispatch queue to receive notification on. If `nil`, notifications are delivered to the current thread.

     - returns: `Observable<(AnyRealmCollection<Element.Element>, RealmChangeset?)>`
     */
    static func changeset(from collection: Element, synchronousStart: Bool = true, on queue: DispatchQueue? = nil)
        -> Observable<(AnyRealmCollection<Element.ElementType>, RealmChangeset?)> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            return Observable.create { observer in
                if synchronousStart {
                    observer.onNext((collection.toAnyCollection(), nil))
                }
<<<<<<< HEAD
                
                let token = collection.toAnyCollection().observe { changeset in
                    
                    switch changeset {
                    case .initial(let value):
=======

                let token = collection.toAnyCollection().observe(on: queue) { changeset in

                    switch changeset {
                    case let .initial(value):
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                        guard !synchronousStart else { return }
                        observer.onNext((value, nil))
                    case let .update(value, deletes, inserts, updates):
                        observer.onNext((value, RealmChangeset(deleted: deletes, inserted: inserts, updated: updates)))
                    case let .error(error):
                        observer.onError(error)
                        return
                    }
<<<<<<< HEAD
                }
                
                return Disposables.create {
                    token.invalidate()
                }
=======
                }

                return Disposables.create {
                    token.invalidate()
                }
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            }
    }
    
    @available(*, deprecated, renamed: "arrayWithChangeset(from:synchronousStart:)")
    static func changesetArrayFrom(_ collection: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<([Element.ElementType], RealmChangeset?)> {
        return arrayWithChangeset(from: collection)
    }
    
    /**
<<<<<<< HEAD
     Returns an `Observable<(Array<E.Element>, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     
=======
     Returns an `Observable<(Array<Element.Element>, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
     This method emits an `Array` containing all the realm collection objects, this means they all live in the memory. If you're using this method to observe large collections you might hit memory warnings.
     
     When the observable emits for the first time (if the initial notification is not coalesced with an update) the second tuple value will be `nil`.
     
     Each following emit will include a `RealmChangeset` with the indexes inserted, deleted or modified.
<<<<<<< HEAD
     
     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)
     
     - returns: `Observable<(Array<E.Element>, RealmChangeset?)>`
     */
    public static func arrayWithChangeset(from collection: E, synchronousStart: Bool = true)
        -> Observable<(Array<E.ElementType>, RealmChangeset?)> {
            
            return Observable.changeset(from: collection)
=======

     - parameter from: A Realm collection of type `Element`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)
     - parameter queue: The serial dispatch queue to receive notification on. If `nil`, notifications are delivered to the current thread.

     - returns: `Observable<(Array<Element.Element>, RealmChangeset?)>`
     */
    static func arrayWithChangeset(from collection: Element, synchronousStart: Bool = true, on queue: DispatchQueue? = nil)
        -> Observable<([Element.ElementType], RealmChangeset?)> {
            return Observable.changeset(from: collection, on: queue)
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                .map { ($0.toArray(), $1) }
    }
}

public extension Observable {
<<<<<<< HEAD
    
=======
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    @available(*, deprecated, renamed: "from(realm:)")
    static func from(_ realm: Realm, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<(Realm, Realm.Notification)> {
        return from(realm: realm)
    }
    
    /**
     Returns an `Observable<(Realm, Realm.Notification)>` that emits each time the Realm emits a notification.
     
     The Observable you will get emits a tuple made out of:
     
     * the realm that emitted the event
     * the notification type: this can be either `.didChange` which occurs after a refresh or a write transaction ends,
     or `.refreshRequired` which happens when a write transaction occurs from a different thread on the same realm file
     
     For more information look up: [Realm.Notification](https://realm.io/docs/swift/latest/api/Enums/Notification.html)

     - parameter realm: A Realm instance
     - returns: `Observable<(Realm, Realm.Notification)>`, which you can subscribe to
     */
<<<<<<< HEAD
    public static func from(realm: Realm) -> Observable<(Realm, Realm.Notification)> {
        
=======
    static func from(realm: Realm) -> Observable<(Realm, Realm.Notification)> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return Observable<(Realm, Realm.Notification)>.create { observer in
            let token = realm.observe { (notification: Realm.Notification, realm: Realm) in
                observer.onNext((realm, notification))
            }
            
            return Disposables.create {
                token.invalidate()
            }
        }
    }
}

// MARK: Realm type extensions

<<<<<<< HEAD
extension Reactive where Base: Realm {
    
    /**
     Returns bindable sink wich adds object sequence to the current Realm
     
     - parameter: update - if set to `true` it will override existing objects with matching primary key
=======
extension Realm: ReactiveCompatible {}

extension Reactive where Base == Realm {
    /**
     Returns bindable sink wich adds object sequence to the current Realm

     - parameter: update - update according to Realm.UpdatePolicy
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public func add<S: Sequence>(update: Realm.UpdatePolicy = .error, onError: ((S?, Error) -> Void)? = nil)
        -> AnyObserver<S> where S.Iterator.Element: Object {
<<<<<<< HEAD
            
=======
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            return RealmObserver(realm: base) { realm, elements, error in
                guard let realm = realm else {
                    onError?(nil, error ?? RxRealmError.unknown)
                    return
<<<<<<< HEAD
                }
                
                do {
                    try realm.write {
                        realm.add(elements, update: update)
                    }
                } catch let e {
                    onError?(elements, e)
                }
=======
                }

                do {
                    try realm.write {
                        realm.add(elements, update: update)
                    }
                } catch let e {
                    onError?(elements, e)
                }
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                }
                .asObserver()
    }
    
    /**
     Returns bindable sink wich adds an object to Realm
<<<<<<< HEAD
     
     - parameter: update - if set to `true` it will override existing objects with matching primary key
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public func add<O: Object>(update: Bool = false,
                               onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {
        
=======

     - parameter: update - update according to Realm.UpdatePolicy
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public func add<O: Object>(update: Realm.UpdatePolicy = .error,
                               onError: ((O?, Error) -> Void)? = nil) -> AnyObserver<O> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return RealmObserver(realm: base) { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }
            
            do {
                try realm.write {
                    realm.add(element, update: update)
                }
            } catch let e {
                onError?(element, e)
            }
            }.asObserver()
    }
    
    /**
     Returns bindable sink wich deletes objects in sequence from Realm.
     
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public func delete<S: Sequence>(onError: ((S?, Error) -> Void)? = nil)
        -> AnyObserver<S> where S.Iterator.Element: Object {
<<<<<<< HEAD
            
=======
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            return RealmObserver(realm: base, binding: { realm, elements, error in
                guard let realm = realm else {
                    onError?(nil, error ?? RxRealmError.unknown)
                    return
<<<<<<< HEAD
                }
                
                do {
                    try realm.write {
                        realm.delete(elements)
                    }
                } catch let e {
                    onError?(elements, e)
                }
=======
                }

                do {
                    try realm.write {
                        realm.delete(elements)
                    }
                } catch let e {
                    onError?(elements, e)
                }
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
            }).asObserver()
    }
    
    /**
     Returns bindable sink wich deletes objects in sequence from Realm.
     
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public func delete<O: Object>(onError: ((O?, Error) -> Void)? = nil) -> AnyObserver<O> {
        return RealmObserver(realm: base, binding: { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }
            
            do {
                try realm.write {
                    realm.delete(element)
                }
            } catch let e {
                onError?(element, e)
            }
        }).asObserver()
    }
}

extension Reactive where Base == Realm {
    /**
     Returns bindable sink wich adds object sequence to a Realm
     
     - parameter: configuration (by default uses `Realm.Configuration.defaultConfiguration`)
     to use to get a Realm for the write operations
     - parameter: update - update according to Realm.UpdatePolicy
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
<<<<<<< HEAD
    public static func add<S: Sequence>(
        configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
        update: Bool = false,
        onError: ((S?, Error)->Void)? = nil) -> AnyObserver<S> where S.Iterator.Element: Object {
        
=======
    public static func add<S: Sequence>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                                        update: Realm.UpdatePolicy = .error,
                                        onError: ((S?, Error) -> Void)? = nil) -> AnyObserver<S> where S.Iterator.Element: Object {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return RealmObserver(configuration: configuration) { realm, elements, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }
            
            do {
                try realm.write {
                    realm.add(elements, update: update)
                }
            } catch let e {
                onError?(elements, e)
            }
            }.asObserver()
    }
    
    /**
     Returns bindable sink which adds an object to a Realm
     
     - parameter: configuration (by default uses `Realm.Configuration.defaultConfiguration`)
     to use to get a Realm for the write operations
     - parameter: update - update according to Realm.UpdatePolicy
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
<<<<<<< HEAD
    public static func add<O: Object>(
        configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
        update: Bool = false,
        onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {
        
=======
    public static func add<O: Object>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                                      update: Realm.UpdatePolicy = .error,
                                      onError: ((O?, Error) -> Void)? = nil) -> AnyObserver<O> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return RealmObserver(configuration: configuration) { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }
            
            do {
                try realm.write {
                    realm.add(element, update: update)
                }
            } catch let e {
                onError?(element, e)
            }
            }.asObserver()
    }
    
    /**
     Returns bindable sink, which deletes objects in sequence from Realm.
     
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
<<<<<<< HEAD
    public static func delete<S: Sequence>(onError: ((S?, Error)->Void)? = nil)
        -> AnyObserver<S>  where S.Iterator.Element: Object {
            
            return AnyObserver { event in
                
=======
    public static func delete<S: Sequence>(onError: ((S?, Error) -> Void)? = nil)
        -> AnyObserver<S> where S.Iterator.Element: Object {
            return AnyObserver { event in

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                guard let elements = event.element,
                    var generator = elements.makeIterator() as S.Iterator?,
                    let first = generator.next(),
                    let realm = first.realm else {
                        onError?(nil, RxRealmError.unknown)
                        return
                }
<<<<<<< HEAD
                
=======

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
                do {
                    try realm.write {
                        realm.delete(elements)
                    }
                } catch let e {
                    onError?(elements, e)
                }
            }
    }
    
    /**
     Returns bindable sink, which deletes object from Realm
     
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
<<<<<<< HEAD
    public static func delete<O: Object>(onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {
        
=======
    public static func delete<O: Object>(onError: ((O?, Error) -> Void)? = nil) -> AnyObserver<O> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return AnyObserver { event in
            
            guard let element = event.element, let realm = element.realm else {
                onError?(nil, RxRealmError.unknown)
                return
            }

            do {
                try realm.write {
                    realm.delete(element)
                }
            } catch let e {
                onError?(element, e)
            }
        }
    }
}

// MARK: Realm Object type extensions

public extension Observable where Element: Object {
<<<<<<< HEAD
    
=======
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    @available(*, deprecated, renamed: "from(object:)")
    static func from(_ object: Element) -> Observable<Element> {
        return from(object: object)
    }
    
    /**
     Returns an `Observable<Object>` that emits each time the object changes. The observable emits an initial value upon subscription.
     
     - parameter object: A Realm Object to observe
     - parameter emitInitialValue: whether the resulting `Observable` should emit its first element synchronously (e.g. better for UI bindings)
     - parameter properties: changes to which properties would triger emitting a .next event
     - parameter tokenReceiver: when a notification token is created, it is passed to the handler ( e.g. for preventing change notifications for the subscription=
     - returns: `Observable<Object>` will emit any time the observed object changes + one initial emit upon subscription
     
     public static func from(object: Element, emitInitialValue: Bool = true,
     properties: [String]? = nil) -> Observable<Element> {
     */
<<<<<<< HEAD
    
    
    public static func from(object: Element, emitInitialValue: Bool = true,
                            properties: [String]? = nil, tokenReceiver: ((NotificationToken) -> Void)? = nil) -> Observable<Element> {
        
=======

    static func from(object: Element, emitInitialValue: Bool = true,
                     properties: [String]? = nil) -> Observable<Element> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return Observable<Element>.create { observer in
            if emitInitialValue {
                observer.onNext(object)
            }
            
            let token = object.observe { change in
                switch change {
                case let .change(_, changedProperties):
                    if let properties = properties, !changedProperties.contains(where: { properties.contains($0.name) }) {
                        // if change property isn't an observed one, just return
                        return
                    }
                    observer.onNext(object)
                case .deleted:
                    observer.onError(RxRealmError.objectDeleted)
                case let .error(error):
                    observer.onError(error)
                }
            }
            
            tokenReceiver?(token)
            
            return Disposables.create {
                token.invalidate()
            }
        }
    }
<<<<<<< HEAD
=======

>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
    /**
     Returns an `Observable<PropertyChange>` that emits the object `PropertyChange`s.

     - parameter object: A Realm Object to observe
     - returns: `Observable<PropertyChange>` will emit any time a change is detected on the object
     */
<<<<<<< HEAD
    
    public static func propertyChanges(object: Element) -> Observable<PropertyChange> {
        
=======

    static func propertyChanges(object: Element) -> Observable<PropertyChange> {
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
        return Observable<PropertyChange>.create { observer in
            let token = object.observe { change in
                switch change {
                case let .change(_, changes):
                    for change in changes {
                        observer.onNext(change)
                    }
                case .deleted:
                    observer.onError(RxRealmError.objectDeleted)
                case let .error(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                token.invalidate()
            }
        }
    }
<<<<<<< HEAD
    
    
=======
>>>>>>> c4dcc49acbf8073a8a6481b571c640bb169650f1
}

