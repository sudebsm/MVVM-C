//
//  MVVM_CTests.swift
//  MVVM-CTests
//
//  Created by Sudeb Sarkar on 02/04/26.
//

import XCTest
@testable import MVVM_C
class MockNetwork: APIProtocol {
    
    var result: Result<Data, Error>?
    
    func fetchUserData<T>(urlStr: String) async throws -> [T] where T : Decodable {
        
        if let res = result {
            switch(res){
            case .success(let data):
                return try JSONDecoder().decode([T].self, from: data)
            case .failure(let error as NetworkError):
                throw NetworkError.badResponse
            case .failure(_):
                throw NetworkError.unknown
            }
        }
        return []
    }
    
    
     
}
final class MVVM_CTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    @MainActor
    func testDataSuccess() async {
        let network: MockNetwork = MockNetwork()
        if let data = try? JSONEncoder().encode([User(name: "Sudeb", id: 1)]) {
            network.result = .success(data)
            
        }
         
            let data: [User] =   try! await network.fetchUserData(urlStr: "")
            XCTAssertEqual(data.count, 1)
         
       
    }
    @MainActor
    func testDataFailed() async {
        let network = MockNetwork()
        network.result = .failure(NetworkError.badResponse)
        do{
            let dataList:[User] = try await network.fetchUserData(urlStr: "")
        }catch(let error){
            XCTAssertNotNil(error)
        }
        
    }

}
