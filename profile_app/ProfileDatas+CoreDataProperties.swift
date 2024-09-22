//
//  ProfileDatas+CoreDataProperties.swift
//  profile_app
//
//  Created by Sato on 2024/09/22.
//
//

import Foundation
import CoreData


extension ProfileDatas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileDatas> {
        return NSFetchRequest<ProfileDatas>(entityName: "ProfileDatas")
    }

    @NSManaged public var aboutMe: String?
    @NSManaged public var birthdate: Date?
    @NSManaged public var bloodType: String?
    @NSManaged public var bucketList: String?
    @NSManaged public var currentChallenge: String?
    @NSManaged public var dislikedFood: String?
    @NSManaged public var facebook: String?
    @NSManaged public var favoriteArtist: String?
    @NSManaged public var favoriteBook: String?
    @NSManaged public var favoriteBrand: String?
    @NSManaged public var favoriteFood: String?
    @NSManaged public var favoriteMovie: String?
    @NSManaged public var favoritePlace: String?
    @NSManaged public var futureGoal: String?
    @NSManaged public var hobby: String?
    @NSManaged public var hometown: String?
    @NSManaged public var instagram: String?
    @NSManaged public var isImagePickerPresented: Bool
    @NSManaged public var messageToFriend: String?
    @NSManaged public var motto: String?
    @NSManaged public var name: String?
    @NSManaged public var nickname: String?
    @NSManaged public var selectedImage: Data?
    @NSManaged public var strongPoint: String?
    @NSManaged public var twitter: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var weakPoint: String?
    @NSManaged public var zodiacSign: String?
    @NSManaged public var updateDate: Date?

}

extension ProfileDatas : Identifiable {

}
