import SwiftUI
import CoreData

struct previewProfile: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.managedObjectContext) private var viewContext
    
    var uid: UUID
    
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var birthdate: Date = Date()
    @State private var updateDate: Date = Date()
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
    
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ZStack{
            ScrollView {
                ZStack(alignment: .top) {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                    ProfileRow(value: formatDate(updateDate))
                        .padding(20)
                    VStack {
                        HStack(alignment: .top) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 120, maxHeight: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.leading, 20)
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ProfileRow(value: name)
                                ProfileRow(value: nickname)
                                ProfileRow(value: formatDate(birthdate))
                                ProfileRow(value: zodiacSign)
                                ProfileRow(value: bloodType)
                                ProfileRow(value: hometown)
                            }
                        }
                        .padding(.top, 48)
                        .padding(.leading, 10)
                        
                        VStack(alignment: .center, spacing: 16) {
                            ProfileRow(value: hobby)
                            ProfileRow(value: favoriteFood)
                            ProfileRow(value: dislikedFood)
                            ProfileRow(value: strongPoint)
                                .padding(.top, 29)
                            ProfileRow(value: weakPoint)
                                .padding(.top, 29)
                            ProfileRow(value: motto)
                                .padding(.top, 29)
                        }
                        .padding(.top, 96)
                        
                        VStack(alignment: .center, spacing: 16) {
                            ProfileRow(value: favoriteArtist)
                                .padding(.top, 28)
                            ProfileRow(value: favoriteMovie)
                                .padding(.top, 28)
                            ProfileRow(value: favoriteBook)
                                .padding(.top, 28)
                            ProfileRow(value: favoriteBrand)
                                .padding(.top, 28)
                            ProfileRow(value: favoritePlace)
                                .padding(.top, 28)
                        }.padding(.top, 98)
                        
                        HStack(spacing: 40) {
                            if !twitter.isEmpty {
                                Button(action: {
                                    openSocialMediaApp(urlScheme: "twitter://user?screen_name=\(twitter)", fallbackURL: "https://twitter.com/\(twitter)")
                                }) {
                                    Image("x-logo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                        .cornerRadius(15)
                                }
                            } else {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .opacity(0)
                            }
                            
                            if !instagram.isEmpty {
                                Button(action: {
                                    openSocialMediaApp(urlScheme: "instagram://user?username=\(instagram)", fallbackURL: "https://www.instagram.com/\(instagram)")
                                }) {
                                    Image("instagram-logo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.purple)
                                        .cornerRadius(15)
                                }
                            } else {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .opacity(0)
                            }
                            
                            if !facebook.isEmpty {
                                Button(action: {
                                    openSocialMediaApp(urlScheme: "fb://profile/\(facebook)", fallbackURL: "https://www.facebook.com/\(facebook)")
                                }) {
                                    Image("facebook-logo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                        .cornerRadius(15)
                                }
                            } else {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .opacity(0)
                            }
                        }
                        .padding(.top, 105)
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            ProfileRow(value: messageToFriend)
                        }.padding(.top, 85)
                    }
                    .padding()
                }
            }
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            fetchProfileData()
        }
    }
    
    private func fetchProfileData() {
        let request: NSFetchRequest<ProfileDatas> = ProfileDatas.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        request.fetchLimit = 1
        
        do {
            let profiles = try viewContext.fetch(request)
            if let profile = profiles.first {
                name = profile.name ?? ""
                nickname = profile.nickname ?? ""
                birthdate = profile.birthdate ?? Date()
                updateDate = profile.updateDate ?? Date()
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
                }
            } else {
                print("No profile found with UID: \(uid)")
            }
        } catch {
            print("Error fetching profile: \(error.localizedDescription)")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func openSocialMediaApp(urlScheme: String, fallbackURL: String) {
        if let appURL = URL(string: urlScheme), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else if let webURL = URL(string: fallbackURL) {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}

struct ProfileRow: View {
    var value: String
    
    var body: some View {
        Text(value)
            .fontWeight(.black)
            .font(.system(.body, design: .monospaced))
            .foregroundColor(.black)
            .background(Color.clear)
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
