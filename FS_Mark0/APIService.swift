//
//  APIService.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 06/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    let baseURL = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/"
    let gender = UserDefaults.standard.string(forKey: "userGender")!
    let uid = UserInfo.uid!
    
    // MARK:- HomeScreen
    func fetchHomeScreenData(completionHandler: @escaping (HomeScreenResult) -> ()) {
        let params = ["gender": gender, "uid": uid ]
        let url = "\(baseURL)fsHome"
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let homeScreenResult = try JSONDecoder().decode(HomeScreenResult.self, from: data)
                completionHandler(homeScreenResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    //MARK:- QRScanVC
    
    func fetchQRResponse(locationID: String, surveyID: String, category: String, completionHandler: @escaping (CheckQRResult) -> ()) {
        let params = ["uid": uid, "lid": locationID, "sid":surveyID, "category":category]
        let url = "\(baseURL)CheckQR"
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let checkQRResult = try JSONDecoder().decode(CheckQRResult.self, from: data)
                completionHandler(checkQRResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    func fetchColleges(completionHandler: @escaping ([College]) -> ()) {
        let url = APIEndpoints.collegeListEndpoint
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let fetchCollege = try JSONDecoder().decode([College].self, from: data)
                completionHandler(fetchCollege)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    //MARK:- BrandsTVC(Coupons)
    
    func fetchCoupons(completionHandler: @escaping ([Coupon]) -> ()) {
        let params = ["uid": uid]
        let url = baseURL + "showCoupons"
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let fetchCouponResult = try JSONDecoder().decode([Coupon].self, from: data)
                completionHandler(fetchCouponResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
        }
    }
    
    func couponSurvey(brand: String, couponID: String, completionHandler: @escaping (CouponResult) -> ()) {
        let params = ["uid": uid, "brand": brand, "couponID": couponID]
        let url = baseURL + "sendCouponSurvey"
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let couponResult = try JSONDecoder().decode(CouponResult.self, from: data)
                completionHandler(couponResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
        }
    }
    
    //MARK:- FaqTVC
    
    func fetchFaqs(completionHandler: @escaping ([FAQ]) -> ()) {
        let url = baseURL + "getFAQs"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let faqResult = try JSONDecoder().decode([FAQ].self, from: data)
                completionHandler(faqResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    //MARK:- AlertsVC
    
    func fetchAlerts(completionHandler: @escaping ([Alert]) -> ()) {
        let url = baseURL + "getAlerts"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let alertResult = try JSONDecoder().decode([Alert].self, from: data)
                completionHandler(alertResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
            
        }
    }
    
    //MARK:- AddressTVC
    
    func fetchAddresses(completionHandler: @escaping (AddressResult) -> ()) {
        let url = baseURL + "getAddresses"
        let params = ["uid": uid]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let addressResult = try JSONDecoder().decode(AddressResult.self, from: data)
                completionHandler(addressResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    func createNewOrder(nickName: String, completionHandler: @escaping (Order) -> ()) {
        let url = baseURL + "newOrder"
        let params = ["uid": uid, "addressID": nickName]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let orderResult = try JSONDecoder().decode(Order.self, from: data)
                completionHandler(orderResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }

        }
    }
    
    //MARK:- Loyalty Coupon
    
    func fetchLoyaltyCoupon(brand: String, completionHandler: @escaping (APIService.LoyaltyCouponResult) -> ()) {
        let url = baseURL + "loyaltyCoupons"
        let params = ["uid": uid, "brand": brand]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let loyaltyCouponResult = try JSONDecoder().decode(LoyaltyCouponResult.self, from: data)
                completionHandler(loyaltyCouponResult)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
            
        }

    }
    

    //MARK:- Structs
    
    struct LoyaltyCouponResult: Decodable {
        let brandImgURL: String
        let couponList: [LoyaltyCoupon]?
    }
    
    struct AddressResult: Decodable {
        let addresses: [Address]?
        let isEmpty: Bool
    }
    
    struct CouponResult: Decodable {
        let questions: [Question]?
        let couponCode: String?
    }
    
    struct CheckQRResult: Decodable {
        let dict: Survey?
        let status: String?
    }
    
    struct HomeScreenResult: Decodable {
        let isEmpty: Bool?
        let surveyType: String?
        let survey: Survey?
        let message: String?
    }
    
    struct Survey: Decodable {
        let campaignID: String?
        let imgURL: String?
        let products: [Product]?
        let questions: [Question]?
        let surveyID: String?
        let title: String?
        let subtitle: String?
    }
    
    struct Question: Decodable {
        let option1: String?
        let option2: String?
        let option3: String?
        let option4: String?
        let option5: String?
        let option6: String?
        let option7: String?
        let option8: String?
        let question: String?
        let type: String?

    }
}
