//
//  UserProfileViewModel.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation
import SwiftUI

/// ViewModel для управления профилем пользователя
@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var profileState: UserProfile?
    
    private let localDataStore = LocalDataStore.shared
    private var hasLoadedProfile = false
    
    init() {
        loadProfile()
    }
    
    /// Загрузить профиль из локального хранилища
    func loadProfile() {
        if hasLoadedProfile {
            return
        }
        
        profileState = localDataStore.getUserProfileOrDefault()
        hasLoadedProfile = true
    }
    
    /// Принудительно перезагрузить профиль из локального хранилища
    func refreshProfile() {
        profileState = localDataStore.getUserProfileOrDefault()
        hasLoadedProfile = true
    }
    
    /// Обновить профиль
    func updateProfile(_ profile: UserProfile) {
        localDataStore.saveUserProfile(profile)
        profileState = profile
    }
    
    /// Обновить отдельное поле профиля
    func updateProfileField(
        firstName: String? = nil,
        lastName: String? = nil,
        gender: String? = nil,
        birthDate: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        displayName: String? = nil,
        avatarRes: String? = nil
    ) {
        let currentProfile = profileState ?? UserProfile.default()
        let updatedProfile = UserProfile(
            firstName: firstName ?? currentProfile.firstName,
            lastName: lastName ?? currentProfile.lastName,
            gender: gender ?? currentProfile.gender,
            birthDate: birthDate ?? currentProfile.birthDate,
            phone: phone ?? currentProfile.phone,
            email: email ?? currentProfile.email,
            displayName: displayName ?? currentProfile.displayName,
            avatarRes: avatarRes ?? currentProfile.avatarRes
        )
        updateProfile(updatedProfile)
    }
    
    /// Получить текущий профиль или профиль по умолчанию
    func getCurrentProfile() -> UserProfile {
        return profileState ?? UserProfile.default()
    }
}

