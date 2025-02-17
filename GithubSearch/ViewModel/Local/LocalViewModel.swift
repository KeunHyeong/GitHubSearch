//
//  LocalViewModel.swift
//  RememberTest
//
//  Created by 장근형 on 2/6/25.
//

import Foundation

class LocalViewModel {
    private var allGroupedUsers: [String: [GitHubUser]] = [:]
    @Published var filteredGroupedUsers: [String: [GitHubUser]] = [:]
    
    init() {
        fetchLocalUsers()
    }
    
    func fetchLocalUsers() {
        allGroupedUsers = groupUsersByFirstLetter()
        // 처음에는 전체 로컬 유저를 보여줌
        filteredGroupedUsers = allGroupedUsers
    }
    
    // GitHubUser 배열을 첫 글자 기준으로 그룹화
    private func groupUsersByFirstLetter() -> [String: [GitHubUser]] {
        let users = RealmManager.shared.getAllGitHubUsers()
        var groupedUsers = [String: [GitHubUser]]()
        
        for user in users {
            guard let firstLetter = user.login.first?.lowercased() else { continue }
            if groupedUsers[firstLetter] == nil {
                groupedUsers[firstLetter] = [user]
            } else {
                groupedUsers[firstLetter]?.append(user)
            }
        }
        return groupedUsers
    }
    
    func searchUsers(_ login: String) -> [String: [GitHubUser]] {
        guard !login.isEmpty else {
            return allGroupedUsers
        }
        
        var results = [String: [GitHubUser]]()
        // allGroupedUsers을 기준으로 각 섹션에서 검색
        for sectionKey in allGroupedUsers.keys {
            let filteredUsers = allGroupedUsers[sectionKey]?.filter { user in
                return user.login.lowercased().contains(login.lowercased())
            }
            
            // 필터링된 결과가 있다면 결과에 추가
            if let filteredUsers = filteredUsers, !filteredUsers.isEmpty {
                results[sectionKey] = filteredUsers
            }
        }
        
        return results
    }
    
    func deleteFavoriteUser(_ user: GitHubUser) {
        RealmManager.shared.deleteGitHubUser(user)
    }
}


