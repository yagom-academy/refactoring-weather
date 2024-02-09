//
//  CustomDecoder.swift
//  WeatherForecast
//
//  Created by 강동영 on 2/2/24.
//

import Foundation

// 4. 이에 맞춰서 프로토콜도 수정
protocol CustomDecodable {
    var jsonDecoder: JSONDecoder { get }
    func decode<T: Decodable>(_ decodable: T.Type, data from: Data?) throws -> T
}

struct CustomDecoder: CustomDecodable {
    enum DecoderError: Error {
        case dataIsNil
        case catchError(Error)
    }
    
    // 3. 그래서 initializer에서 외부에서 decoder를 받을 수 있게 함
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    let jsonDecoder: JSONDecoder
    
    // 2. 근데 이렇게 하면 또 SOLID의 DIP에 위반되는거 아닌가...?
//    let jsonDecoder: JSONDecoder = JSONDecoder()
    
    func decode<T: Decodable>(_ decodable: T.Type, data from: Data?) throws -> T {
        guard let data = from else { throw DecoderError.dataIsNil }
        do {
            // 1. 이 부분에서 jsonDecoder를 init하면 매번 함수를 실행시킬때마다 jsonDecoder 인스턴스가 생성되니까 차라리 위로 빼놓자
//            let jsonDecoder: JSONDecoder = .init()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoder = try jsonDecoder.decode(decodable.self, from: data)
            return decoder
        } catch {
            throw DecoderError.catchError(error)
        }
    }
}
