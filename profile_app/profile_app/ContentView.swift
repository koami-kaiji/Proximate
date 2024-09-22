import SwiftUI

struct ContentView: View {
    @StateObject var themeManager = ThemeManager()
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            Group {
                if selectedTab == 0 {
                    ProfileListView()
                } else if selectedTab == 1 {
                    profileExchange()
                } else {
                    EditProfile()
                }
            }
            
            VStack {
                Spacer()

                HStack {
                    TabBarItem(icon: "list.bullet", isSelected: selectedTab == 0)
                        .onTapGesture {
                            selectedTab = 0
                        }

                    Spacer()

                    TabBarItem(icon: "paperplane", isSelected: selectedTab == 1)
                        .onTapGesture {
                            selectedTab = 1
                        }

                    Spacer()

                    TabBarItem(icon: "square.and.pencil", isSelected: selectedTab == 2)
                        .onTapGesture {
                            selectedTab = 2
                        }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(themeManager.currentTheme.accentColor)
                .cornerRadius(30)
                .padding(.horizontal, 40)
            }
        }
        .environmentObject(themeManager)
    }
}


struct TabBarItem: View {
    var icon: String
    var isSelected: Bool
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? themeManager.currentTheme.backgroundColor : themeManager.currentTheme.foregroundColor)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeManager())
    }
}
