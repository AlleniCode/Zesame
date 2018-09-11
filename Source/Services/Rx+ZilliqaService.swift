//
//  Rx+ZilliqaService.swift
//  ZilliqaSDK
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import JSONRPCKit
import APIKit
import Result

private func single<R>(request: @escaping (Result<R, ZilliqaSDK.Error>) -> Void) -> Single<R> {
    return Single.create { single in

        let foo: (Result<R, ZilliqaSDK.Error>) -> Void = { (result: Result<R, ZilliqaSDK.Error>) -> Void in
            
//            switch result {
//            case .failure(let error): single(.error(error))
//            case .success(let model): single(.success(model))
//            }
        }

        request(foo)
        return Disposables.create {}
    }
}

public extension Reactive where Base: (ZilliqaService & AnyObject) {
    func getBalance() -> Single<BalanceResponse> {
        return Single.create { [weak base] single in
            base?.getBalalance() {
                switch $0 {
                case .failure(let error): single(.error(error))
                case .success(let balance): single(.success(balance))
                }
            }
            return Disposables.create {}
        }
    }
}
//
//public extension Reactive where Base: (APIClient & ReactiveCompatible & AnyObject) {
//    func send<Request, Response>(request: Request) -> Single<Response>
//        where
//        Request: JSONRPCKit.Request,
//        Response: Decodable,
//        /* This should hopefully be removed soon  */
//        Request.Response == Dictionary<String, Any>
//    {
//        return Single.create { [weak base] single in
//            base?.send(request: request) { (result: Result<Response, Error>) in
//                switch result {
//                case .failure(let error): single(.error(error))
//                case .success(let model): single(.success(model))
//                }
//            }
//            return Disposables.create {}
//        }
//    }
//}
