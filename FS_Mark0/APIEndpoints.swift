//
//  APIEndpoints.swift
//  FS_Mark0
//
//  Created by Aryan Sharma on 15/01/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import FirebaseAuth

class APIEndpoints {
    public static var showSurveysEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/ShowSurvey"
    public static var checkQREndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/CheckQR"
    public static var getBrands = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getBrands"
    public static var couponSurveyEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/sendCouponSurvey?uid=" + (Auth.auth().currentUser?.uid)!
    public static var showCouponsEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/showCoupons"
    public static var alertsEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getAlerts"
    public static var homeSurveyEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/homeSurveys"
    public static var faqEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getFAQs"
    public static var addressEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getAddresses?uid=" + (Auth.auth().currentUser?.uid)!
    public static var collegeListEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getColleges"
    public static var newHomeEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/newHome"
    public static var newOrderEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/newOrder"
    public static var getOrdersEndpoint = "https://us-central1-fsmark0-c03e0.cloudfunctions.net/getOrders?uid=" + (Auth.auth().currentUser?.uid)!


}
