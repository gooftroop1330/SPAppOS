//
// Created by John C Harrison on 04/2/2020.
// Copyright (c) 2020 Preston Smith. All rights reserved.
//

//
//  WelcomeBanner.swift
//  SPAppOS
//
//  Created by John C Harrison on 04/2/2020.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let bannerID = "ca-app-pub-3940256099942544/2934735716" // Production "ca-app-pub-6460192778031720/4565110285"

        let viewController = UIViewController()
        view.adUnitID = bannerID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct DSPBanner:View{
    var body: some View{
        HStack{
            Spacer()
            BannerVC().frame(width: 320, height: 50, alignment: .center)
            Spacer()
        }
    }
}
