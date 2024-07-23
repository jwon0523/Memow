//
//  OnboardingView.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import SwiftUI

// 화면 전체 너비와 높이 크기를 가지는 변수
private var screenHeight: CGFloat = UIScreen.main.bounds.height
private var screenWidth: CGFloat = UIScreen.main.bounds.width

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var noteListViewModel = NoteListViewModel()
    @StateObject private var notificationManager = NotificationManager.instance
    @EnvironmentObject var messageDataController: MessageDataController
    @EnvironmentObject var noteDataController: NoteDataController
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
            // 작동 확인을 위한 임시 코드
            // 테스트 완료 후 OnboardingContentView 다시 추가
            HomeView()
                .environmentObject(homeViewModel)
                .environmentObject(noteListViewModel)
                .environment(\.managedObjectContext, messageDataController.container.viewContext)
                .environmentObject(notificationManager)
                .navigationDestination(for: PathType.self) { pathType in
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(homeViewModel)
                            .environmentObject(noteListViewModel)
                            .environmentObject(notificationManager)
                            .environment(\.managedObjectContext, messageDataController.container.viewContext)
                    case .noteListView:
                        NoteListView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(homeViewModel)
                            .environmentObject(noteListViewModel)
                            .environmentObject(notificationManager)
                            .environment(\.managedObjectContext, noteDataController.container.viewContext)
                    case let .noteView(isCreateMode, note):
                        NoteView(
                            noteViewModel: isCreateMode
                            ? .init(note: .init(title: "", content: "", date: Date()))
                            : .init(note: note ?? .init(title: "", content: "", date: Date())),
                            isCreateMode: isCreateMode
                        )
                        .navigationBarBackButtonHidden()
                        .environmentObject(noteListViewModel)
                        .environment(\.managedObjectContext, noteDataController.container.viewContext)
                    }
                }
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
        }
        .background(.customBackground)
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    // 탭뷰 디폴트 인덱스 지정을 위한 변수
    @State private var selectedIndex: Int
    // 마지막 온보딩의 인덱스 변수
    private let lastOnboading: Int = 3
    
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
                OnboardingCellView(
                    onboardingContent: onboardingContent,
                    // 마지막 온보딩이라면 계속하기 버튼을 보여줌
                    isShowContinueBtn: index == lastOnboading ? true: false
                )
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(.customBackground)
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    private var isShowContinueBtn: Bool
    
    fileprivate init(
        onboardingContent: OnboardingContent,
        isShowContinueBtn: Bool
    ) {
        self.onboardingContent = onboardingContent
        self.isShowContinueBtn = isShowContinueBtn
    }
    
    fileprivate var body: some View {
        VStack {
            HStack {
                ForEach(
                    Array(onboardingContent.tabBarImageFileName.enumerated()),
                    id: \.element) { _, imageFileName in
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
            
            // Onboarding model에 정의되어 있는 설정 버튼 값을 가져옴
            ForEach(
                Array(onboardingContent.settingBtnContents.enumerated()),
                id: \.element) { index, settingBtnContents in
                    SettingContentBtnCellView(settingBtnContents: settingBtnContents)
                }
            
            Spacer()
            
            // 마지막 온보딩인 경우 계속하기 버튼 보여줌
            if isShowContinueBtn {
                ContinueBtnView()
            }
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
                .foregroundColor(.black)
        })
        .frame(width: 150, height: 50)
        .background(isSelected ? Color.customYellow : Color.customWhite)
        .cornerRadius(15)
        .shadow(radius: 3, y: 2)
    }
}

// MARK: - 계속하기 버튼 뷰
private struct ContinueBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        HStack {
            Button(action: {
                // 계속하기 버튼 클릭시 HomeView로 이동
                pathModel.paths.append(.homeView)
            }, label: {
                Text("Continue")
                    .foregroundColor(.black)
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
    let controller = MessageDataController.preview
    let context = controller.context
    
    let homeViewModel = HomeViewModel()
    let pathModel = PathModel()
    let noteListViewModel = NoteListViewModel()
    
    return OnboardingView()
        .environment(\.managedObjectContext, context)
        .environmentObject(homeViewModel)
        .environmentObject(pathModel)
        .environmentObject(noteListViewModel)
        .environmentObject(controller)
}
