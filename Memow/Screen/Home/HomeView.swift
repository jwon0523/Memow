//
//  ContentView.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var messageDataController: MessageDataController
    @EnvironmentObject private var noteDataController: NoteDataController
    @State private var isShowingSideMenu: Bool = false
    @State private var sideMenuOffset: CGFloat = -340
    @State private var lastSideMenuOffset: CGFloat = -340

    private let sideMenuWidth: CGFloat = 340

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leftBtnAction: {
                        if !homeViewModel.isEditMessageMode {
                            withAnimation {
                                isShowingSideMenu.toggle()
                            }
                        }
                    },
                    rightBtnAction: {
                        withAnimation {
                            homeViewModel.toggleEditMessageMode()
                        }
                    },
                    leftBtnType: .sideMenuIcon,
                    rightBtnType: homeViewModel.navigationBarRightMode
                )
                
                if homeViewModel.isEditMessageMode {
                    OptionMenuBarView()
                }
                
                ChatListView()
                
                if !homeViewModel.isEditMessageMode {
                    MessageFieldView()
                }
            }
            .offset(x: max(sideMenuOffset + sideMenuWidth, 0))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let totalTranslation = value.translation.width + lastSideMenuOffset
                        if totalTranslation <= 0 && totalTranslation >= -sideMenuWidth {
                            sideMenuOffset = totalTranslation
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if -sideMenuOffset > sideMenuWidth / 2 {
                                isShowingSideMenu = false
                                sideMenuOffset = -sideMenuWidth
                            } else {
                                isShowingSideMenu = true
                                sideMenuOffset = 0
                            }
                        }
                        lastSideMenuOffset = sideMenuOffset
                    }
            )
            .background(Color.backgroundDefault)

            SideMenuView(
                isShowing: $isShowingSideMenu,
                offset: $sideMenuOffset,
                lastOffset: $lastSideMenuOffset
            )
        }
        .onAppear {
            sideMenuOffset = isShowingSideMenu ? 0 : -sideMenuWidth
            lastSideMenuOffset = sideMenuOffset
        }
    }
}

// MARK: - 채팅 리스트 뷰
private struct ChatListView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: MessageEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \MessageEntity.date, ascending: true)
        ],
        animation: .default
    ) private var messages: FetchedResults<MessageEntity>
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { proxy in
                    // 메세지가 작성된 날짜를 보여줌
                    ChatListCellView(messages: Array(messages))
                        .padding(.horizontal)
                        .background(Color.backgroundDefault)
                        .onChange(of: homeViewModel.lastMessageId) { id in
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                        .onAppear {
                            if let id = messages.last?.id {
                                homeViewModel.setLastMessageId(lastMessageId: id)
                            }
                        }
                }
            }
        }
        // 키보드 화면 밖 선택시 키보드 내림
        .onTapGesture {
            UIApplication.shared.keyboardDown()
        }
    }
}

// MARK: - 날짜별 섹션 뷰
private struct ChatListCellView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    private let columns = [GridItem(.flexible())]
    private var messages: [MessageEntity]
    
    fileprivate init(messages: [MessageEntity]) {
        self.messages = messages
    }
    
    fileprivate var body: some View {
        let groupedMessages = homeViewModel.groupMessagesByDate(
            messages: messages.map { $0 }
        )
        LazyVGrid(
            columns: columns,
            spacing: 20
            //            pinnedViews: [.sectionHeaders]
        ) {
            ForEach(
                groupedMessages.sortedKeys(), id: \.self
            ) { dateComponents in
                Section(
                    header: DateSectionHeader(dateComponents: dateComponents)
                ) {
                    ForEach(
                        groupedMessages[dateComponents]!, id: \.id
                    ) { message in
                        MessageBubbleView(message: message)
                    }
                }
            }
        }
    }
}

// MARK: - 날짜 헤더 뷰
private struct DateSectionHeader: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    let dateComponents: DateComponents
    let date: Date = Date()
    
    fileprivate var body: some View {
        // 바인딩 필요
        VStack {
            Text(date.formattedDate(from: dateComponents))
                .customFontStyle(.body)
                .foregroundStyle(.lableDisable)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
        .padding(.bottom, 8)
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - 메세지 버블 뷰
private struct MessageBubbleView: View {
    private var message: MessageEntity
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var notificationManager: NotificationManager
    @State private var messageHeight: CGFloat = 0
    @State private var isShowRightIcon: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var moveLeft: Bool = false
    
    fileprivate init(message: MessageEntity) {
        self.message = message
    }
    
    fileprivate var body: some View {
        HStack {
            if homeViewModel.isEditMessageMode {
                Button(action: {
                    homeViewModel.messageSelectedBoxTapped(message)
                }, label: {
                    if homeViewModel.selectedMessages.contains(message) {
                        Image("SelectedBox")
                    } else {
                        Image("unSelectedBox")
                    }
                })
            }
            
            HStack {
                MessageContentView(
                    message: message,
                    messageHeight: $messageHeight
                )
                .offset(x: dragOffset.width)
                
                if isShowRightIcon && !homeViewModel.isEditMessageMode {
                    MessageBubbleIconView(
                        message: message,
                        messageHeight: $messageHeight,
                        isShowRightIcon: $isShowRightIcon
                    )
                    .offset(x: dragOffset.width)
                    .transition(.move(edge: .trailing))
                    .animation(
                        .easeInOut(duration: 0.2),
                        value: isShowRightIcon
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(Color.backgroundDefault)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let translation = gesture.translation.width
                    
                    // 메시지 버블이 화면을 벗어나지 않도록 제한
                    // 양수로 변경시 오른쪽으로 당겼다가 돌아오는 제스처 가능.
                    if translation < 0 {
                        // 왼쪽으로 스와이프할 때 (아이콘 열기)
                        self.dragOffset.width = max(translation, -30)
                    } else if translation > 0 && isShowRightIcon {
                        // 오른쪽으로 스와이프할 때 (아이콘 닫기)
                        self.dragOffset.width = min(translation, 80)
                    }
                }
                .onEnded { _ in
                    // 왼쪽으로 스와이프하여 아이콘을 열 때
                    if dragOffset.width < -25 {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isShowRightIcon = true
                        }
                    } // 오른쪽으로 스와이프하여 아이콘을 닫을 때
                    else if dragOffset.width > 60 {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isShowRightIcon = false
                        }
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.dragOffset = .zero
                    }
                }
        )
    }
}

// MARK: - 메세지 내용 뷰
private struct MessageContentView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    private var message: MessageEntity
    @Binding private var messageHeight: CGFloat
    
    fileprivate init(
        message: MessageEntity,
        messageHeight: Binding<CGFloat>
    ) {
        self.message = message
        self._messageHeight = messageHeight
    }
    
    fileprivate var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                Spacer()
                
                if message.isAlarmSet {
                    Image("AlarmBadge")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                Text(message.date!.formattedTime)
                    .customFontStyle(.caption)
                    .foregroundColor(.customFont)
            }
            
            Text(message.content!)
                .customFontStyle(.body)
                .foregroundColor(.labelMemo)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.colorPrimary)
                .overlay(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                    }
                )
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    self.messageHeight = height
                }
                .cornerRadius(8)
        }
        .frame(maxWidth: screenWidth * 0.63, alignment: .trailing)
        .opacity(
            homeViewModel.isEditMessageMode &&
            !homeViewModel.selectedMessages.contains(message) ? 0.3 : 1
        )
    }
}

// MARK: - 메시지 아이콘 뷰
private struct MessageBubbleIconView: View {
    private var message: MessageEntity
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var notificationManager: NotificationManager
    @Binding private var messageHeight: CGFloat
    @Binding private var isShowRightIcon: Bool
    private let iconCornerRadiusSize: CGFloat = 8
    
    fileprivate init(
        message: MessageEntity,
        messageHeight: Binding<CGFloat>,
        isShowRightIcon: Binding<Bool>
    ) {
        self.message = message
        self._messageHeight = messageHeight
        self._isShowRightIcon = isShowRightIcon
    }
    
    fileprivate var body: some View {
        HStack(spacing: 10) {
            Button {
                withAnimation {
                    if notificationManager.authorizationStatus == .notDetermined {
                        notificationManager.requestAuthorization()
                    } else if notificationManager.authorizationStatus == .denied {
                        print("Notification permission denied.")
                        self.isShowRightIcon.toggle()
                    } else {
                        homeViewModel.selectedMessageAlarmBtnTapped(for: message)
                        self.isShowRightIcon.toggle()
                    }
                }
            } label: {
                Image("Alarm")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .frame(width: 40 ,height: messageHeight)
                    .background(Color.backgorundBtn)
                    .clipShape(RoundedRectangle(cornerRadius: iconCornerRadiusSize))
            }
            
            Button {
                homeViewModel.messageSelectedBoxTapped(message)
                homeViewModel.messageToNoteSwipingTapped()
                withAnimation {
                    self.isShowRightIcon.toggle()
                }
            } label: {
                Image("AddFile")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .frame(width: 40 ,height: messageHeight)
                    .background(Color.backgorundBtn)
                    .clipShape(RoundedRectangle(cornerRadius: iconCornerRadiusSize))
            }
        }
    }
}

// MARK: - 메세지 입력 뷰
private struct MessageFieldView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var text: String = ""
    @EnvironmentObject private var messageDataController: MessageDataController
    @Environment(\.managedObjectContext) private var viewContext
    
    fileprivate var body: some View {
        HStack(spacing: 10) {
            // TextField를 커스텀한 뷰
            CustomTextField(
                placeholder:
                    Text("What do you need?")
                    .foregroundColor(.customFont),
                text: $text
            )
            
            // 입력 내용이 있을 경우만 전송 버튼 보임.
            if text != "" {
                Button {
                    // 입력된 내용이 없을 경우 전송되지 않음
                    if text != "" {
                        messageDataController.addMessage(
                            homeViewModel: homeViewModel,
                            content: text,
                            context: viewContext
                        )
                        text = ""
                        // 전송 버튼 클릭시 키보드 내림
                        // UIApplication.shared.keyboardDown()
                    }
                } label: {
                    Image("SendMessage")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                }
            }
        }
        .frame(minHeight: 40)
        .background(Color.customTextField)
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - 선택모드시 네비게이션바 아래에 나타나는 옵션뷰
fileprivate struct OptionMenuBarView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var messageDataController: MessageDataController
    @Environment(\.managedObjectContext) private var viewContext
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        homeViewModel.removeBtnTapped(
                            messageDataController: messageDataController,
                            context: viewContext
                        )
                    }
                }, label: {
                    Text("Delete")
                        .customFontStyle(.body)
                        .foregroundColor(.customDelete)
                    Image("Trash")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                
                Spacer()
                
                //            Button(action: {
                //                print("Share")
                //            }, label: {
                //                Text("Share")
                //                    .foregroundColor(.customFont)
                //                Image("Share")
                //                    .resizable()
                //                    .frame(width: 20, height: 20)
                //            })
                
                //            Spacer()
                
                Button(action: {
                    if(!homeViewModel.selectedMessages.isEmpty) {
                        homeViewModel.toggleNoteListModal()
                    }
                }, label: {
                    Text("Connect")
                        .customFontStyle(.body)
                        .foregroundColor(.customFont)
                    Image("Copy")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                
                Spacer()
            }
            .frame(height: 40)
            .background(Color.backgorundBtn)
            .opacity(homeViewModel.selectedMessages.isEmpty ? 0.4 : 1)
            .cornerRadius(16)
        }
        .padding(.all, 16)
        .frame(height: 72)
    }
}

fileprivate struct SelectedAlarmDatePicerView: View {
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var messageDataController: MessageDataController
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedAlarmDate = Date()
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            DatePicker(
                "Select Alarm",
                selection: $selectedAlarmDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .padding()
            
            Button {
                homeViewModel.scheduleNotificationBtnTapped(
                    for: selectedAlarmDate,
                    using: notificationManager
                )
                homeViewModel.toggleMessageIsAlarmSet(
                    using: messageDataController,
                    in: viewContext
                )
            } label: {
                Text("Schedule notification")
                    .customFontStyle(.body)
                    .foregroundStyle(Color.customFont)
            }
            .padding(10)
            .background(Color.backgorundBtn)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            //            Button("Cancel notification") {
            //                notificationManager.cancelNotification()
            //            }
            //            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    let controller = MessageDataController.preview
    let context = controller.context
    let homeViewModel = HomeViewModel()
    let pathModel = PathModel()
    let noteListViewModel = NoteListViewModel()
    let notificationManager = NotificationManager()
    
    return HomeView()
        .environment(\.managedObjectContext, context)
        .environmentObject(homeViewModel)
        .environmentObject(pathModel)
        .environmentObject(noteListViewModel)
        .environmentObject(controller)
        .environmentObject(notificationManager)
}
