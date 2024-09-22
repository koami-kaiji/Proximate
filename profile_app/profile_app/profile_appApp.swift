import SwiftUI

@main
struct profile_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    insertDummyData(context: persistenceController.container.viewContext)
                }
        }
    }
}


import CoreData
import UIKit

func insertDummyData(context: NSManagedObjectContext) {
    let request: NSFetchRequest<ProfileDatas> = ProfileDatas.fetchRequest()
    request.fetchLimit = 1
    
    do {
        let count = try context.count(for: request)
        
        if count <= 1 {
            for i in 1...10 {
                let profile = ProfileDatas(context: context)
                profile.uid = UUID()
                profile.name = "User \(i)"
                profile.nickname = "Nickname \(i)"
                profile.birthdate = Date()
                profile.zodiacSign = "Sign \(i)"
                profile.bloodType = ["A", "B", "O", "AB"].randomElement()!
                profile.hometown = "Hometown \(i)"
                profile.aboutMe = "This is a sample about me for User \(i)."
                profile.hobby = ["Reading", "Sports", "Music", "Cooking"].randomElement()!
                profile.favoriteFood = ["Pizza", "Sushi", "Burger", "Pasta"].randomElement()!
                profile.dislikedFood = ["Onions", "Broccoli", "Spinach"].randomElement()!
                profile.strongPoint = "Strength \(i)"
                profile.weakPoint = "Weakness \(i)"
                profile.motto = "Motto \(i)"
                profile.favoriteArtist = ["Artist A", "Artist B", "Artist C"].randomElement()!
                profile.favoriteMovie = ["Movie X", "Movie Y", "Movie Z"].randomElement()!
                profile.favoriteBook = ["Book A", "Book B", "Book C"].randomElement()!
                profile.favoriteBrand = ["Brand A", "Brand B", "Brand C"].randomElement()!
                profile.favoritePlace = ["Park A", "Beach B", "Mountain C"].randomElement()!
                profile.instagram = "@user\(i)"
                profile.twitter = "@nickname\(i)"
                profile.facebook = "facebook.com/user\(i)"
                profile.futureGoal = "Goal \(i)"
                profile.bucketList = "Bucket List Item \(i)"
                profile.currentChallenge = "Challenge \(i)"
                profile.messageToFriend = "Message to Friend \(i)"
                profile.updateDate = Date()

                if let image = UIImage(systemName: "person.circle") {
                    if let imageData = image.pngData() {
                        profile.selectedImage = imageData
                    }
                }
            }
            
            try context.save()
        }
    } catch {

    }
}
