import SwiftUI
import CoreData

struct ProfileListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedProfile: ProfileDatas?

    @FetchRequest(
        entity: ProfileDatas.entity(),
        sortDescriptors: []
    ) var profiles: FetchedResults<ProfileDatas>

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(profiles) { profile in
                    ProfileCardView(profile: profile)
                        .onTapGesture {
                            self.selectedProfile = profile
                        }
                }
            }
            .padding()
        }
        .background(
            RadialGradient(
                gradient: Gradient(colors: [themeManager.currentTheme.backgroundColor, themeManager.currentTheme.secondBackgroundColor]),
                center: .center,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height
            )
            .edgesIgnoringSafeArea(.all)
        )
        .fullScreenCover(item: $selectedProfile) { profile in
            previewProfile(uid: profile.uid ?? UUID())
                .environmentObject(themeManager)
        }
    }
}


struct ProfileCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var profile: ProfileDatas

    var body: some View {
        VStack(spacing: 10) {
            if let imageData = profile.selectedImage,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(themeManager.currentTheme.accentColor, lineWidth: 3)
                    )
                    .shadow(color: themeManager.currentTheme.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(themeManager.currentTheme.accentColor, lineWidth: 3)
                    )
                    .shadow(color: themeManager.currentTheme.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
            }

            Text(profile.name ?? "Unknown")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.currentTheme.foregroundColor)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(themeManager.currentTheme.formColor)
                .shadow(color: themeManager.currentTheme.accentColor.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }
}

