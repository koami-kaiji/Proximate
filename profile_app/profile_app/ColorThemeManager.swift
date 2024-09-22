import SwiftUI

struct ColorTheme {
    var backgroundColor: Color
    var secondBackgroundColor: Color
    var foregroundColor: Color
    var formColor: Color
    var formTextColor: Color
    var accentColor: Color
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: ColorTheme

    static let darkTheme = ColorTheme(
        backgroundColor: Color.black,
        secondBackgroundColor: Color(red: 0.1, green: 0.1, blue: 0.1),
        foregroundColor: Color.white,
        formColor: Color(red: 0.2, green: 0.2, blue: 0.2),
        formTextColor: Color.white,
        accentColor: Color.blue
    )

    static let lightTheme = ColorTheme(
        backgroundColor: Color.white,
        secondBackgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95),
        foregroundColor: Color.black,
        formColor: Color.white,
        formTextColor: Color.black,
        accentColor: Color.blue
    )

    static let oceanBlueTheme = ColorTheme(
        backgroundColor: Color(red: 0.0, green: 0.2, blue: 0.4),
        secondBackgroundColor: Color(red: 0.0, green: 0.4, blue: 0.6),
        foregroundColor: Color.white,
        formColor: Color(red: 0.0, green: 0.3, blue: 0.5),
        formTextColor: Color.white,
        accentColor: Color.cyan
    )

    static let sunsetTheme = ColorTheme(
        backgroundColor: Color(red: 0.9, green: 0.5, blue: 0.0),
        secondBackgroundColor: Color(red: 0.9, green: 0.4, blue: 0.0),
        foregroundColor: Color.white,
        formColor: Color(red: 0.8, green: 0.3, blue: 0.0),
        formTextColor: Color(red: 0.2, green: 0.0, blue: 0.0),
        accentColor: Color.yellow
    )

    static let forestGreenTheme = ColorTheme(
        backgroundColor: Color(red: 0.0, green: 0.3, blue: 0.1),
        secondBackgroundColor: Color(red: 0.0, green: 0.4, blue: 0.2),
        foregroundColor: Color.white,
        formColor: Color(red: 0.0, green: 0.5, blue: 0.2),
        formTextColor: Color.white,
        accentColor: Color.green
    )

    static let pastelTheme = ColorTheme(
        backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95),
        secondBackgroundColor: Color(red: 0.9, green: 0.9, blue: 1.0),
        foregroundColor: Color.black,
        formColor: Color(red: 1.0, green: 0.9, blue: 0.9),
        formTextColor: Color.black,
        accentColor: Color.pink
    )

    static let highContrastTheme = ColorTheme(
        backgroundColor: Color.black,
        secondBackgroundColor: Color.white,
        foregroundColor: Color.yellow,
        formColor: Color.black,
        formTextColor: Color.yellow,
        accentColor: Color.red
    )

    static let monochromeTheme = ColorTheme(
        backgroundColor: Color.gray,
        secondBackgroundColor: Color(red: 0.6, green: 0.6, blue: 0.6),
        foregroundColor: Color.white,
        formColor: Color(red: 0.5, green: 0.5, blue: 0.5),
        formTextColor: Color.black,
        accentColor: Color.black
    )

    static let vintageTheme = ColorTheme(
        backgroundColor: Color(red: 0.9, green: 0.85, blue: 0.7),
        secondBackgroundColor: Color(red: 0.8, green: 0.75, blue: 0.6),
        foregroundColor: Color(red: 0.3, green: 0.2, blue: 0.1),
        formColor: Color(red: 0.85, green: 0.8, blue: 0.65),
        formTextColor: Color(red: 0.3, green: 0.2, blue: 0.1),
        accentColor: Color(red: 0.6, green: 0.5, blue: 0.4)
    )

    static let neonTheme = ColorTheme(
        backgroundColor: Color.black,
        secondBackgroundColor: Color(red: 0.05, green: 0.05, blue: 0.05),
        foregroundColor: Color(red: 0.0, green: 1.0, blue: 0.8),
        formColor: Color.black,
        formTextColor: Color(red: 0.0, green: 1.0, blue: 0.8),
        accentColor: Color(red: 1.0, green: 0.0, blue: 0.5)
    )

    init() {
        self.currentTheme = ThemeManager.darkTheme
    }

    func switchTheme(to theme: ColorTheme) {
        self.currentTheme = theme
    }
}


struct ThemeCarouselView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let themes: [(name: String, theme: ColorTheme)] = [
        ("ダーク", ThemeManager.darkTheme),
        ("ライト", ThemeManager.lightTheme),
        ("オーシャン", ThemeManager.oceanBlueTheme),
        ("サンセット", ThemeManager.sunsetTheme),
        ("フォレスト", ThemeManager.forestGreenTheme),
        ("パステル", ThemeManager.pastelTheme),
        ("ネオン", ThemeManager.neonTheme),
        ("ヴィンテージ", ThemeManager.vintageTheme),
        ("ハイコントラスト", ThemeManager.highContrastTheme),
        ("モノクローム", ThemeManager.monochromeTheme)
    ]
    
    var body: some View {
        TabView {
            ForEach(themes, id: \.name) { item in
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [item.theme.backgroundColor, item.theme.accentColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(radius: 5)
                    
                    VStack {
                        Text(item.name)
                            .font(.headline)
                            .foregroundColor(item.theme.foregroundColor)
                            .padding(.bottom, 10)
                        
                        HStack(spacing: 5) {
                            Circle()
                                .fill(item.theme.backgroundColor)
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(item.theme.secondBackgroundColor)
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(item.theme.formColor)
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(item.theme.accentColor)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        themeManager.switchTheme(to: item.theme)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 150)
    }
}
