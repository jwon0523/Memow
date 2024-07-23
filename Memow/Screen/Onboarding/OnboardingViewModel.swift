//
//  OnboardingViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init(
        onboardingContents: [OnboardingContent] = [
            .init(
                title: "환영합니다\n지금부터 기본적인 설명을\n도와드릴게요",
                subTitle: "",
                tabBarImageFileName: ["OnboardingTabBar.fill", "OnboardingTabBar", "OnboardingTabBar", "OnboardingTabBar"],
                settingBtnContents: [
                    SettingBtn(
                        buttonContent: ["",""],
                        isSelectedBtn: [true, false]
                    )
                ]
            ),
            .init(
                title: "우선\n항상 메모하시는 공간의\n분위기는 어떻게 할까요?",
                subTitle: "설정은 언제든지 변경 가능해요",
                tabBarImageFileName: ["OnboardingTabBar.fill", "OnboardingTabBar.fill", "OnboardingTabBar", "OnboardingTabBar"],
                settingBtnContents: [
                    SettingBtn(
                        buttonContent: ["가볍고, 밝게", "차분하고 어둡게"],
                        isSelectedBtn: [true, false]
                    )
                ]
            ),
            .init(
                title: "간단하게 메모한 것을\n노트로 이동한 후\n기존 메모는 어떻게 할까요?",
                subTitle: "설정은 언제든지 변경 가능해요",
                tabBarImageFileName: ["OnboardingTabBar.fill", "OnboardingTabBar.fill", "OnboardingTabBar.fill", "OnboardingTabBar"],
                settingBtnContents: [
                    SettingBtn(
                        buttonContent: ["깔끔하게 지울게요", "기록인데, 남길게요"],
                        isSelectedBtn: [true, false]
                    )
                ]
            ),
            .init(
                title: "마지막 설정이에요.\n하루에 한번씩 생각 정리를 위해\n알람을 보내드릴까요?",
                subTitle: "설정은 언제든지 변경 가능해요",
                tabBarImageFileName: ["OnboardingTabBar.fill", "OnboardingTabBar.fill", "OnboardingTabBar.fill", "OnboardingTabBar.fill"],
                settingBtnContents: [
                    SettingBtn(
                        buttonContent: ["", ""],
                        isSelectedBtn: [true, false]
                    )
                ]
            ),
        ]
    ) {
        self.onboardingContents = onboardingContents
    }
}
