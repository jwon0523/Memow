//
//  OnboardingView.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import SwiftUI

private var screenHeight: CGFloat = UIScreen.main.bounds.height
private var screenWidth: CGFloat = UIScreen.main.bounds.width

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            OnboardingContentView(onboardingViewModel: onboardingViewModel)
        }
        .environmentObject(pathModel)
    }
}

// MARK: - 온보딩 컨텐트 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            ContinueBtnView()
        }
        .background(.customBackground)
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(
                Array(onboardingViewModel.onboardingContents.enumerated()),
                id: \.element
            ) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: .infinity)
        .background(.customBackground)
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    @State private var isSelectedBtn: Bool = false
    
    fileprivate init(
        onboardingContent: OnboardingContent
    ) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            HStack {
                ForEach(
                    Array(onboardingContent.tabBarImageFileName.enumerated()),
                    id: \.element) { index, imageFileName in
                        Image(imageFileName)
                    }
            }
            
            Spacer()
                .frame(height: screenHeight / 4)
            
            HStack {
                Spacer()
                    .frame(width: screenWidth / 10)
                
                VStack(alignment: .leading) {
                    Text(onboardingContent.title)
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.customFont)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 12))
                        .foregroundColor(.customFont)
                    
                    Spacer()
                        .frame(height: 80)
                }
                
                
                Spacer()
            }
            
            ForEach(
                Array(onboardingContent.settingBtnContents.enumerated()),
                id: \.element) { index, settingBtnContents in
                    SettingContentBtnCellView(settingBtnContents: settingBtnContents)
                }
            
            Spacer()
        }
    }
}

// MARK: - 컨텐트 버튼 뷰
private struct SettingContentBtnCellView: View {
    private var settingBtnContents: SettingBtn
    
    fileprivate init(
        settingBtnContents: SettingBtn
    ) {
        self.settingBtnContents = settingBtnContents
    }
    
    fileprivate var body: some View {
        HStack {
            SettingContentBtnView(
                title: settingBtnContents.buttonContent[0],
                isSelected: settingBtnContents.isSelectedBtn[0]
            )
            
            Spacer()
                .frame(width: 25)
            
            SettingContentBtnView(
                title: settingBtnContents.buttonContent[1],
                isSelected: settingBtnContents.isSelectedBtn[1]
            )
        }
    }
}

private struct SettingContentBtnView: View {
    private var title: String
    private var isSelected: Bool
    
    fileprivate init(
        title: String,
        isSelected: Bool
    ) {
        self.title = title
        self.isSelected = isSelected
    }
    
    fileprivate var body: some View {
        Button(action: {
            print(title)
        }, label: {
            Text(title)
                .foregroundColor(.customFont)
        })
        .frame(width: 150, height: 50)
        .background(isSelected ? Color.customYellow : Color.customWhite)
        .cornerRadius(15)
        .shadow(radius: 3, y: 2)
    }
}

// MARK: - 계속하기 버튼 뷰
private struct ContinueBtnView: View {
    fileprivate var body: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Continue")
            })
            .frame(width: screenWidth * 0.85, height: 48)
            .background(.customWhite)
            .cornerRadius(20)
            .shadow(radius: 3, y: 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical)
        .background(.customBackground)
    }
}

#Preview {
    OnboardingView()
}
