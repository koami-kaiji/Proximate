import SwiftUI
import CoreData

struct EditProfile: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: ProfileDatas.entity(),
        sortDescriptors: []
    ) var profiles: FetchedResults<ProfileDatas>

    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var showSaveConfirmation = false
    @State private var isAnimating = false

    var profile: ProfileDatas? {
        profiles.first
    }
    
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var birthdate = Date()
    @State private var zodiacSign: String = ""
    @State private var bloodType: String = ""
    @State private var hometown: String = ""
    
    @State private var aboutMe: String = ""
    @State private var hobby: String = ""
    @State private var favoriteFood: String = ""
    @State private var dislikedFood: String = ""
    @State private var strongPoint: String = ""
    @State private var weakPoint: String = ""
    @State private var motto: String = ""
    
    @State private var favoriteArtist: String = ""
    @State private var favoriteMovie: String = ""
    @State private var favoriteBook: String = ""
    @State private var favoriteBrand: String = ""
    @State private var favoritePlace: String = ""
    
    @State private var instagram: String = ""
    @State private var twitter: String = ""
    @State private var facebook: String = ""
    
    @State private var futureGoal: String = ""
    @State private var bucketList: String = ""
    @State private var currentChallenge: String = ""
    
    @State private var messageToFriend: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .center, spacing: 20) {
                            ZStack {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(themeManager.currentTheme.accentColor)
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(themeManager.currentTheme.accentColor, lineWidth: 4)
                                    .frame(width: 110, height: 110)

                            )
                            .shadow(radius: 10)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }

                            VStack(alignment: .center, spacing: 10) {
                                Text("テーマを選択")
                                    .font(.footnote)
                                    .foregroundColor(themeManager.currentTheme.foregroundColor)
                                    .padding(.leading, 16)

                                ThemeCarouselView()
                                    .frame(height: 150)
                            }
                        }
                        
                        SectionView(title: "ProfileDatas") {
                            Group {
                                CustomTextField(label: "名前", text: $name)
                                CustomTextField(label: "ニックネーム", text: $nickname)
                                CustomDatePicker(label: "生年月日", date: $birthdate)
                                CustomTextField(label: "星座", text: $zodiacSign)
                                CustomTextField(label: "血液型", text: $bloodType)
                                CustomTextField(label: "出身地", text: $hometown)
                            }
                        }
                        
                        SectionView(title: "About Me") {
                            Group {
                                CustomTextField(label: "趣味 / 特技", text: $hobby)
                                CustomTextField(label: "好きな食べ物", text: $favoriteFood)
                                CustomTextField(label: "嫌いな食べ物", text: $dislikedFood)
                                CustomTextField(label: "得意なこと", text: $strongPoint)
                                CustomTextField(label: "苦手なこと", text: $weakPoint)
                                CustomTextField(label: "座右の銘 / モットー", text: $motto)
                            }
                        }
                        
                        SectionView(title: "Favorites") {
                            Group {
                                CustomTextField(label: "好きなアーティスト", text: $favoriteArtist)
                                CustomTextField(label: "好きな映画 / ドラマ", text: $favoriteMovie)
                                CustomTextField(label: "好きな本 / 漫画", text: $favoriteBook)
                                CustomTextField(label: "好きなブランド / ファッション", text: $favoriteBrand)
                                CustomTextField(label: "好きな場所（カフェ・公園など）", text: $favoritePlace)
                            }
                        }
                        
                        SectionView(title: "SNS") {
                            Group {
                                CustomTextField(label: "Instagram", text: $instagram)
                                CustomTextField(label: "Twitter", text: $twitter)
                                CustomTextField(label: "Facebook", text: $facebook)
                            }
                        }
                        
                        SectionView(title: "messages") {
                            Group {
                                CustomTextField(label: "メッセージ", text: $messageToFriend)
                            }
                        }
                        
                        Button(action: {
                            saveProfile()
                        }) {
                            Text("SAVE")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeManager.currentTheme.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                    }
                    .padding()
                    .background(themeManager.currentTheme.backgroundColor)
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    .onAppear {
                        if let profile = profile {
                            loadProfileData(profile: profile)
                        }
                        isAnimating = true
                    }
                }

                if showSaveConfirmation {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .transition(.opacity)

                        VStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .foregroundColor(.green)
                                .opacity(showSaveConfirmation ? 1 : 0)
                                .scaleEffect(showSaveConfirmation ? 1 : 0.5)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0), value: showSaveConfirmation)
                                .transition(.opacity)
                            Spacer()
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSaveConfirmation = false
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func loadProfileData(profile: ProfileDatas) {
        name = profile.name ?? ""
        nickname = profile.nickname ?? ""
        birthdate = profile.birthdate ?? Date()
        zodiacSign = profile.zodiacSign ?? ""
        bloodType = profile.bloodType ?? ""
        hometown = profile.hometown ?? ""
        aboutMe = profile.aboutMe ?? ""
        hobby = profile.hobby ?? ""
        favoriteFood = profile.favoriteFood ?? ""
        dislikedFood = profile.dislikedFood ?? ""
        strongPoint = profile.strongPoint ?? ""
        weakPoint = profile.weakPoint ?? ""
        motto = profile.motto ?? ""
        favoriteArtist = profile.favoriteArtist ?? ""
        favoriteMovie = profile.favoriteMovie ?? ""
        favoriteBook = profile.favoriteBook ?? ""
        favoriteBrand = profile.favoriteBrand ?? ""
        favoritePlace = profile.favoritePlace ?? ""
        instagram = profile.instagram ?? ""
        twitter = profile.twitter ?? ""
        facebook = profile.facebook ?? ""
        futureGoal = profile.futureGoal ?? ""
        bucketList = profile.bucketList ?? ""
        currentChallenge = profile.currentChallenge ?? ""
        messageToFriend = profile.messageToFriend ?? ""

        if let imageData = profile.selectedImage {
            selectedImage = UIImage(data: imageData)
        } else {
            selectedImage = nil
        }
    }

    private func saveProfile() {
        let profile: ProfileDatas
        if let existingProfile = profiles.first {
            profile = existingProfile
        } else {
            profile = ProfileDatas(context: viewContext)
            profile.uid = UUID()
        }

        profile.name = name
        profile.nickname = nickname
        profile.birthdate = birthdate
        profile.zodiacSign = zodiacSign
        profile.bloodType = bloodType
        profile.hometown = hometown
        profile.aboutMe = aboutMe
        profile.hobby = hobby
        profile.favoriteFood = favoriteFood
        profile.dislikedFood = dislikedFood
        profile.strongPoint = strongPoint
        profile.weakPoint = weakPoint
        profile.motto = motto
        profile.favoriteArtist = favoriteArtist
        profile.favoriteMovie = favoriteMovie
        profile.favoriteBook = favoriteBook
        profile.favoriteBrand = favoriteBrand
        profile.favoritePlace = favoritePlace
        profile.instagram = instagram
        profile.twitter = twitter
        profile.facebook = facebook
        profile.futureGoal = futureGoal
        profile.bucketList = bucketList
        profile.currentChallenge = currentChallenge
        profile.messageToFriend = messageToFriend

        if let selectedImage = selectedImage {
            profile.selectedImage = selectedImage.pngData()
        } else {
            profile.selectedImage = nil
        }

        profile.updateDate = Date()

        do {
            try viewContext.save()
            withAnimation {
                showSaveConfirmation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSaveConfirmation = false
                }
            }
            print("成功")
        } catch {
            print("失敗: \(error)")
        }
    }

}



struct SectionView<Content: View>: View {

    @EnvironmentObject var themeManager: ThemeManager

    var title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.thin)
                .foregroundColor(themeManager.currentTheme.accentColor)
            
            content()
        }
        .padding()
        .background(themeManager.currentTheme.secondBackgroundColor)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomTextField: View {
    
    @EnvironmentObject var themeManager: ThemeManager

    var label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWeight(.light)
                .foregroundColor(themeManager.currentTheme.foregroundColor)
            TextField("", text: $text)
                .padding()
                .background(themeManager.currentTheme.formColor)
                .foregroundColor(themeManager.currentTheme.formTextColor)
                .cornerRadius(8)
        }
    }
}

struct CustomDatePicker: View {

    @EnvironmentObject var themeManager: ThemeManager

    var label: String
    @Binding var date: Date
    @State private var showDatePicker = false
    
    var body: some View {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter
        }()
        
        ZStack {
            if showDatePicker {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showDatePicker = false
                    }
            }
            
            VStack(alignment: .leading) {
                Text(label)
                    .fontWeight(.light)
                    .foregroundColor(themeManager.currentTheme.foregroundColor)

                TextField("", text: .constant(dateFormatter.string(from: date)))
                    .onTapGesture {
                        showDatePicker = true
                    }
                    .padding()
                    .foregroundColor(themeManager.currentTheme.formTextColor)
                    .background(themeManager.currentTheme.formColor)
                    .cornerRadius(8)

                
                if showDatePicker {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .background(themeManager.currentTheme.accentColor)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
