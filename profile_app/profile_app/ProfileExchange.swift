import SwiftUI
import Combine

struct profileExchange: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var peerManager = PeerManager()
    @State private var isTransferringData = false
    @State private var transferProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [themeManager.currentTheme.foregroundColor, themeManager.currentTheme.backgroundColor]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 1.0))
            
            VStack {
                if isTransferringData {
                    transferAnimation()
                } else {
                    List {
                        ForEach(peerManager.availablePeers, id: \.self) { peer in
                            peerRow(peer: peer)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                }
            }
        }
    }
    
    func peerRow(peer: String) -> some View {
        HStack {
            Text(peer)
                .foregroundColor(themeManager.currentTheme.formTextColor)
            Spacer()
            if peerManager.connectedPeers.contains(peer) {
                Text("Connected")
                    .foregroundColor(themeManager.currentTheme.accentColor)
                    .padding(8)
                    .background(themeManager.currentTheme.secondBackgroundColor)
                    .cornerRadius(8)
            } else {
                Button(action: {
                    peerManager.connectToPeer(peer)
                    startDataTransfer()
                }) {
                    Text("Connect")
                        .foregroundColor(themeManager.currentTheme.formTextColor)
                        .padding(8)
                        .background(themeManager.currentTheme.accentColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(themeManager.currentTheme.secondBackgroundColor)
        .cornerRadius(12)
        .shadow(radius: 5)
        .scaleEffect(1.05)
        .animation(.easeInOut)
    }
    
    func transferAnimation() -> some View {
        VStack {
            Text("データを交換中...")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: transferProgress)
                    .stroke(Color.white, lineWidth: 8)
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 2.0), value: transferProgress)
                
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: isTransferringData ? 360 : 0))
                    .animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false))
            }
            
        }
        .onAppear {
            startTransferProgress()
        }
    }
    
    func startTransferProgress() {
        transferProgress = 0.0
        withAnimation(.linear(duration: 3.0)) {
            transferProgress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isTransferringData = false
        }
    }
    
    func startDataTransfer() {
        isTransferringData = true
        startTransferProgress()
    }
}


class PeerManager: ObservableObject {
    @Published var availablePeers: [String] = []
    @Published var connectedPeers: [String] = []
    
    init() {
        availablePeers = ["User 1", "User 2", "User 3"]
    }
    
    func connectToPeer(_ peer: String) {
        if !connectedPeers.contains(peer) {
            connectedPeers.append(peer)
        }
    }
}
