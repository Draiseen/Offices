//
//  ServerManager.swift
//  Offices
//
//  Created by Admin on 18.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import Moya

enum MoyaService {
  case getClients
}

extension MoyaService: TargetType {
  
  var baseURL: URL { return URL(string: "https://project-8716260381830912889.firebaseio.com")! }
  var path: String {
    switch self {
    case .getClients:
      return "/offices.json"
    }
  }
  var method: Moya.Method {
    switch self {
    case .getClients:
      return .get
    }
  }
  var task: Task {
    switch self {
    case .getClients:
      return .requestPlain
    }
  }
  var headers: [String: String]? {
    return nil
  }
  var sampleData: Data {
    return Data()
  }
}

struct Address: Codable {
  let address: String
  let latitude: Double
  let longitude: Double
  let schedule: String
}

struct Institution: Codable {
  let addresses: [Address]
  let id: String
  let imageHref: String
  let longDescription: String
  let name: String
  let rating: Double
  let shortDescription: String
}


class ServerManager {
  
  static let shared: ServerManager = { return ServerManager() }()
  
  private let provider = MoyaProvider<MoyaService>()
  
  func getInstitutions(with successHandler: @escaping ([Institution]) -> (), or errorHandler: @escaping (String) -> ()) {
    provider.request(.getClients) { result in
      switch result {
      case .success(let response):
        print(response)
        do {
          let data = try JSONDecoder().decode([String:Institution].self, from: response.data)
          successHandler(Array(data.values).sorted{ $0.id < $1.id })
        }
        catch let error {
          errorHandler(error.localizedDescription)
        }
      case .failure(let error):
        errorHandler(error.errorDescription ?? "Unknown error")
      }
    }
  }
}

