//
//  ApiClientProtocol.swift
//  SWSkeleton
//
//  Created by Korchak Mykhail on 10.01.18.
//  Copyright © 2018 Korchak Mykhail. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa

public protocol ApiClientProtocol {
    associatedtype ErrorHandlerType: ErrorHandlerProtocol
    
    init()
}

public extension ApiClientProtocol {
    
    // MARK: - RxDefaultResponse
    
    func rxExecute(_ request: ApiRequestProtocol) -> Observable<Void> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            
            dataRequest
                .validate(self.validation(request))
                .response(completionHandler: { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: {
                                            observer.on(.next(()))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            })
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    // MARK: - RxCodable
    
    func rxExecute<T: ModelProtocol>(_ request: ApiRequestProtocol) -> Observable<T?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest
                .validate(self.validation(request))
                .responseJSON { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: { (model: T?) in
                                            observer.on(.next(model))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func rxExecute<T: ModelProtocol>(_ request: ApiRequestProtocol) -> Observable<[T]?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            request.dataRequest
                .validate(self.validation(request))
                .responseJSON { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: { (model: [T]?) in
                                            observer.on(.next(model))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    // MARK: - Rx Simple types
    
    func rxExecute(_ request: ApiRequestProtocol) -> Observable<String?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest
                .validate(self.validation(request))
                .responseString { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: { (result: String?) in
                                            observer.on(.next(result))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func rxExecute(_ request: ApiRequestProtocol) -> Observable<Image?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest
                .validate(self.validation(request))
                .responseImage { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: { (result: Image?) in
                                            observer.on(.next(result))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func rxExecute(_ request: ApiRequestProtocol) -> Observable<Data?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest
                .validate(self.validation(request))
                .responseData { (response) in
                    self.handleResponse(response: response,
                                        logResponse: request.logResponseDescription,
                                        success: { (result: Data?) in
                                            observer.on(.next(result))
                                            observer.on(.completed)
                                        }, failure: { (error) in
                                            observer.on(.error(error))
                                        })
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    // MARK: - DefaultResponse
    
    func execute(_ request: ApiRequestProtocol,
                        queue: DispatchQueue? = nil,
                        success: @escaping () -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.dataRequest
            .validate(self.validation(request))
            .response(queue: queue) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }
    
    // MARK: - Codable
    
    func execute<T: ModelProtocol>(_ request: ApiRequestProtocol,
                                          queue: DispatchQueue? = nil,
                                          success: @escaping (_ result: T?) -> Void,
                                          failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.logDescription()
        
        request.dataRequest
            .validate(self.validation(request))
            .responseJSON(queue: queue) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }

    func execute<T: ModelProtocol>(_ request: ApiRequestProtocol,
                                          queue: DispatchQueue? = nil,
                                          success: @escaping (_ result: [T]?) -> Void,
                                          failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.logDescription()
        
        request.dataRequest
            .validate(self.validation(request))
            .responseJSON(queue: queue) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }
    
    // MARK: - Simple types
    
    func execute(_ request: ApiRequestProtocol,
                        queue: DispatchQueue? = nil,
                        encoding: String.Encoding? = nil,
                        success: @escaping (_ result: String?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.logDescription()
        
        request.dataRequest
            .validate(self.validation(request))
            .responseString(queue: queue, encoding: encoding) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }
    
    func execute(_ request: ApiRequestProtocol,
                        imageScale: CGFloat = DataRequest.imageScale,
                        inflateResponseImage: Bool = true,
                        queue: DispatchQueue? = nil,
                        success: @escaping (_ result: Image?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.logDescription()
        
        request.dataRequest
            .validate(self.validation(request))
            .responseImage(imageScale: imageScale,
                           inflateResponseImage: inflateResponseImage,
                           queue: queue) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }
    
    func execute(_ request: ApiRequestProtocol,
                        queue: DispatchQueue? = nil,
                        success: @escaping (_ result: Data?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard self.checkInternetConnection(failure: failure) else { return }
        
        request.logDescription()
        
        request.dataRequest
            .validate(self.validation(request))
            .responseData(queue: queue) { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: success,
                                    failure: failure)
        }
    }
    
    // MARK: - Helper methods
    
    private func logResponse<T>(_ response: DataResponse<T>, logResponse: Bool) {
        guard logResponse else { return }
        Log.verbose.log("-------")
        Log.verbose.log("Response for \(response.request?.url?.path ?? "")")
        Log.verbose.log(response.value ?? "no response")
        Log.verbose.log("-------")
    }
    
    private func logResponse(_ response: DefaultDataResponse, logResponse: Bool) {
        guard logResponse else { return }
        Log.verbose.log("-------")
        Log.verbose.log("Response for \(response.request?.url?.path ?? "")")
        Log.verbose.log("-------")
    }
    
    private func responseValidation<T>(response: DataResponse<T>, logResponse: Bool) -> (isValid: Bool, statusCode: Int) {
        self.logResponse(response, logResponse: logResponse)

        let internetConnection = DataManager.shared
        guard response.response != nil, let statusCode = response.response?.statusCode else {
            return (false, internetConnection.internetConnectionErrorStatusCode)
        }
        guard internetConnection.validStatusCodeRanges.contains(statusCode) else {
            return (false, statusCode)
        }

        return (true, statusCode)
    }
    
    private func responseValidation(response: DefaultDataResponse, logResponse: Bool) -> (isValid: Bool, statusCode: Int) {
        self.logResponse(response, logResponse: logResponse)
        
        let internetConnection = DataManager.shared
        guard response.response != nil, let statusCode = response.response?.statusCode else {
            return (false, internetConnection.internetConnectionErrorStatusCode)
        }
        guard internetConnection.validStatusCodeRanges.contains(statusCode) else {
            return (false, statusCode)
        }
        
        return (true, statusCode)
    }
    
    private func checkInternetConnection(failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) -> Bool {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return false
        }
        
        return true
    }
    
    private func validation(_ request: ApiRequestProtocol) -> (URLRequest?, HTTPURLResponse, Data?) -> Request.ValidationResult {
        let closure: (URLRequest?, HTTPURLResponse, Data?) -> Request.ValidationResult = { urlRequest, response, data in
            guard request.needsValidation else { return .success }
            guard request.validStatusCodeRanges.contains(response.statusCode) else {
                return .failure(ErrorHandlerType.ErrorType(statusCode: response.statusCode))
            }
            
            return .success
        }
        
        return closure
    }
    
    // MARK: - Response handle
    
    private func handleResponse(response: DefaultDataResponse,
                                logResponse: Bool,
                                success: @escaping () -> Void,
                                failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.ErrorType(statusCode: validation.statusCode))
            return
        }
        success()
        
    }
    
    private func handleResponse<T: ModelProtocol>(response: DataResponse<Any>,
                                                  logResponse: Bool,
                                                  success: @escaping (_ result: T?) -> Void,
                                                  failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        self.logResponse(response, logResponse: logResponse)
        switch response.result {
        case .success(let value):
            guard let json = value as? DictionaryAlias else {
                #if DEBUG
                fatalError("Cannot cast response to type [String: Any]")
                #else
                return
                #endif
            }
            let model = T.self.init(JSON: json)
            success(model)
        case .failure(let error):
            guard let statusCode = response.response?.statusCode else {
                failure(ErrorHandlerType.handleError(error))
                return
            }
            failure(ErrorHandlerType.handleError(statusCode: statusCode, response: response))
        }
    }
    
    private func handleResponse<T: ModelProtocol>(response: DataResponse<Any>,
                                                  logResponse: Bool,
                                                  success: @escaping (_ result: [T]?) -> Void,
                                                  failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        self.logResponse(response, logResponse: logResponse)
        switch response.result {
        case .success(let value):
            guard let jsons = value as? ArrayOfDictionaries else {
                let message = "Cannot cast response to type [[String: Any]]"
                #if DEBUG
                fatalError(message)
                #else
                NSLog(message)
                return
                #endif
            }
            let objects: [T] = [T](JSONArray: jsons) ?? []
            success(objects)
        case .failure(let error):
            failure(ErrorHandlerType.handleError(error))
        }
    }
    
    private func handleResponse<T>(response: DataResponse<T>,
                                   logResponse: Bool,
                                   success: @escaping (_ result: T) -> Void,
                                   failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        switch response.result {
        case .success(let value):
            success(value)
        case .failure(let error):
            guard let statusCode = response.response?.statusCode else {
                failure(ErrorHandlerType.handleError(error))
                return
            }
            failure(ErrorHandlerType.handleError(statusCode: statusCode, response: response))
        }
    }
}
