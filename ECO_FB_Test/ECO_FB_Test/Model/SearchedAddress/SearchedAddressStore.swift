//
//  AddressSearchStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

@MainActor
@Observable
final class SearchedAddressStore {
    static let shared: SearchedAddressStore = SearchedAddressStore()
    
    private init() {}
    
    func getAddresses(query: String) async throws -> SearchedAddress {
        let restAPIKey: String = Bundle.main.infoDictionary?["RestKey"] as! String
        let header: String = "KakaoAK \(restAPIKey)"
        let urlString: String = "https://dapi.kakao.com/v2/local/search/address.json"
        
        guard var url = URL(string: urlString) else { throw HTTPError.notFound }
        
        url.append(queryItems: [URLQueryItem(name: "query", value: query)])
        
        var request: URLRequest = URLRequest(url: url)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badRequest }
            
            if (400...599).contains(httpResponse.statusCode) {
                throw getHTTPError(httpResponse.statusCode)
            }
            
            let result = try JSONDecoder().decode(SearchedAddress.self, from: data)
            
            return result
        } catch {
            throw error
        }
    }
    
    private func getHTTPError(_ statusCode: Int) -> HTTPError {
        switch statusCode {
        case 400:
            return HTTPError.badRequest
        case 401:
            return HTTPError.unauthorized
        case 403:
            return HTTPError.forbidden
        case 404:
            return HTTPError.notFound
        case 405:
            return HTTPError.methodNotAllowed
        case 408:
            return HTTPError.requestTimeout
        case 409:
            return HTTPError.conflict
        case 410:
            return HTTPError.gone
        case 412:
            return HTTPError.preconditionFailed
        case 413:
            return HTTPError.payloadTooLarge
        case 415:
            return HTTPError.unsupportedMediaType
        case 429:
            return HTTPError.tooManyRequests
        case 500:
            return HTTPError.internalServerError
        case 501:
            return HTTPError.notImplemented
        case 502:
            return HTTPError.badGateway
        case 503:
            return HTTPError.serviceUnavailable
        case 504:
            return HTTPError.gatewayTimeout
        default:
            return HTTPError.notFound
        }
    }
}
