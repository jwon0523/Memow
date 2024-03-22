//
//  Onboarding.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import Foundation

struct OnboardingContent: Hashable {
    var title: String
    var subTitle: String
    var settingBtnContents: [SettingBtn]
    var tabBarImageFileName: [String]
    
    init(
        title: String,
        subTitle: String,
        tabBarImageFileName: [String],
        settingBtnContents: [SettingBtn]
    ) {
        self.title = title
        self.subTitle = subTitle
        self.tabBarImageFileName = tabBarImageFileName
        self.settingBtnContents = settingBtnContents
    }
}
