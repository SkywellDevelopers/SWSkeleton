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
import ObjectMapper
import RxSwift
import RxCocoa

public protocol ApiClientProtocol {
    associatedtype ErrorHandlerType: ErrorHandlerProtocol
    
    init()
}

public extension ApiClientProtocol {
    
    // MARK: - RxObjectMapper
    
    public func rxExecute<T: BaseMappable>(_ request: ApiRequestProtocol) -> Observable<T?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseJSON { (response) in
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
    
    public func rxExecute<T: BaseMappable>(_ request: ApiRequestProtocol) -> Observable<[T]> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseJSON { (response) in
                self.handleResponse(response: response,
                                    logResponse: request.logResponseDescription,
                                    success: { (model: [T]) in
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
    
    // MARK: - RxCodable
    
    public func rxExecute<T: ModelProtocol>(_ request: ApiRequestProtocol) -> Observable<T?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseJSON { (response) in
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
    
    public func rxExecute<T: ModelProtocol>(_ request: ApiRequestProtocol) -> Observable<[T]?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseJSON { (response) in
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
    
    public func rxExecute(_ request: ApiRequestProtocol) -> Observable<String?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseString { (response) in
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
    
    public func rxExecute(_ request: ApiRequestProtocol) -> Observable<Image?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseImage { (response) in
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
    
    public func rxExecute(_ request: ApiRequestProtocol) -> Observable<Data?> {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            return Observable.error(error)
        }
        
        request.logDescription()
        
        return Observable.create { observer in
            let dataRequest = request.dataRequest
            dataRequest.responseData { (response) in
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
    
    // MARK: - Codable
    
    public func execute<T: ModelProtocol>(_ request: ApiRequestProtocol,
                                          queue: DispatchQueue? = nil,
                                          success: @escaping (_ result: T?) -> Void,
                                          failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseJSON(queue: queue) { (response) in
            self.handleResponse(response: response,
                                logResponse: request.logResponseDescription,
                                success: success,
                                failure: failure)
        }
    }

    public func execute<T: ModelProtocol>(_ request: ApiRequestProtocol,
                                          queue: DispatchQueue? = nil,
                                          success: @escaping (_ result: [T]?) -> Void,
                                          failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseJSON(queue: queue) { (response) in
            self.handleResponse(response: response,
                                logResponse: request.logResponseDescription,
                                success: success,
                                failure: failure)
        }
    }

    // MARK: - ObjectMapper

    /// DESC: - Array of objects

    public func execute<T: BaseMappable>(_ request: ApiRequestProtocol,
                                         queue: DispatchQueue? = nil,
                                         success: @escaping (_ result: [T]) -> Void,
                                         failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseJSON(queue: queue) { (response) in
            self.handleResponse(response: response,
                                logResponse: request.logResponseDescription,
                                success: success,
                                failure: failure)
        }
    }

    /// Singe object response

    public func execute<T: BaseMappable>(_ request: ApiRequestProtocol,
                                         queue: DispatchQueue? = nil,
                                         success: @escaping (_ result: T?) -> Void,
                                         failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseJSON(queue: queue) { (response) in
            self.handleResponse(response: response,
                                logResponse: request.logResponseDescription,
                                success: success,
                                failure: failure)
        }
    }
    
    // MARK: - Simple types
    
    public func execute(_ request: ApiRequestProtocol,
                        queue: DispatchQueue? = nil,
                        encoding: String.Encoding? = nil,
                        success: @escaping (_ result: String?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseString(queue: queue, encoding: encoding) { (response) in
            self.handleResponse(response: response,
                                logResponse: request.logResponseDescription,
                                success: success,
                                failure: failure)
        }
    }
    
    public func execute(_ request: ApiRequestProtocol,
                        imageScale: CGFloat = DataRequest.imageScale,
                        inflateResponseImage: Bool = true,
                        queue: DispatchQueue? = nil,
                        success: @escaping (_ result: Image?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseImage(imageScale: imageScale,
                                          inflateResponseImage: inflateResponseImage,
                                          queue: queue) { (response) in
                                            self.handleResponse(response: response,
                                                                logResponse: request.logResponseDescription,
                                                                success: success,
                                                                failure: failure)
        }
    }
    
    public func execute(_ request: ApiRequestProtocol,
                        queue: DispatchQueue? = nil,
                        success: @escaping (_ result: Data?) -> Void,
                        failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        guard DataManager.shared.isInternetAvailable else {
            let error = ErrorHandlerType.ErrorType(statusCode: DataManager.shared.internetConnectionErrorStatusCode)
            failure(error)
            return
        }
        
        request.logDescription()
        
        request.dataRequest.responseData(queue: queue) { (response) in
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
    
    private func responseValidation<T>(response: DataResponse<T>, logResponse: Bool) -> (isValid: Bool, statusCode: Int) {
        self.logResponse(response, logResponse: logResponse)
        
        let internetConnection = DataManager.shared
        guard response.response != nil, let statusCode = response.response?.statusCode else {
            return (false, internetConnection.internetConnectionErrorStatusCode)
        }
        guard internetConnection.validStatusCodeRange ~= statusCode else {
            return (false, statusCode)
        }
        
        return (true, statusCode)
    }
    
    // MARK: - Response handle
    
    private func handleResponse<T: ModelProtocol>(response: DataResponse<Any>,
                                                  logResponse: Bool,
                                                  success: @escaping (_ result: T?) -> Void,
                                                  failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.handleError(statusCode: validation.statusCode, response: response))
            return
        }
        guard let json = response.result.value as? DictionaryAlias else {
            #if DEBUG
                fatalError("Cannot cast response to type [String: Any]")
            #else
                return
            #endif
        }
        let model = T.self.init(JSON: json)
        success(model)
    }
    
    private func handleResponse<T: ModelProtocol>(response: DataResponse<Any>,
                                                  logResponse: Bool,
                                                  success: @escaping (_ result: [T]?) -> Void,
                                                  failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.handleError(statusCode: validation.statusCode, response: response))
            return
        }
        guard let jsons = response.result.value as? ArrayOfDictionaries else {
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
    }
    
    private func handleResponse<T>(response: DataResponse<T>,
                                   logResponse: Bool,
                                   success: @escaping (_ result: T?) -> Void,
                                   failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.handleError(statusCode: validation.statusCode, response: response))
            return
        }
        success(response.result.value)
    }
    
    private func handleResponse<T: BaseMappable>(response: DataResponse<Any>,
                                                 logResponse: Bool,
                                                 success: @escaping (_ result: T?) -> Void,
                                                 failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.handleError(statusCode: validation.statusCode, response: response))
            return
        }
        guard let json = response.result.value as? DictionaryAlias else {
            #if DEBUG
                fatalError("Cannot cast response to type [String: Any]")
            #else
                return
            #endif
        }
        
        let TMappable = T.self as? Mappable.Type
        let model = TMappable?.init(JSON: json, context: nil) as? T
        success(model)
    }
    
    private func handleResponse<T: BaseMappable>(response: DataResponse<Any>,
                                                 logResponse: Bool,
                                                 success: @escaping (_ result: [T]) -> Void,
                                                 failure: @escaping (_ error: ErrorHandlerType.ErrorType) -> Void) {
        let validation = self.responseValidation(response: response, logResponse: logResponse)
        guard validation.isValid == true else {
            failure(ErrorHandlerType.handleError(statusCode: validation.statusCode, response: response))
            return
        }
        guard let jsons = response.result.value as? ArrayOfDictionaries else {
            #if DEBUG
                fatalError("Cannot cast response to type [[String: Any]]")
            #else
                return
            #endif
        }
        
        let TMappable = T.self as? Mappable.Type
        let objects: [T] = jsons.flatMap({ TMappable?.init(JSON: $0, context: nil) as? T })
        success(objects)
    }
}
