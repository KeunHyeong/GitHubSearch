//
//  GitHubUserSearchViewModel.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//
import Combine
import Foundation
import RealmSwift

class SearchViewModel {
    @Published var users: [GitHubUser] = []
    
    //사용자 이름으로 api 콜하는 함수
    func searchGitHubUsers(_ name: String) {
        Task {
            do {
                let users = try await SearchClient.getGithubUsers(name)
                self.users = await filterUsers(users)
            } catch {
                print("SearchClient error")
            }
        }
    }
    
    //API화면의 아이템들 중 이미 realm에 저장된 사용자의 favorite버튼을 true로 바꿔주기 위한 함수
    private func filterUsers(_ users: [GitHubUser]) async -> [GitHubUser] {
        var users = users
        
        let allGroupedUsers: [GitHubUser] = await MainActor.run {
            RealmManager.shared.getAllGitHubUsers()
        }
        
        guard !allGroupedUsers.isEmpty else{
            return users
        }
        
        for realmUser in allGroupedUsers where realmUser.favorite {
            if let index = users.firstIndex(where: { $0.id == realmUser.id }) {
                users[index].favorite = true
            }
        }
        
        return users
    }
    
    func saveFavoriteUser(_ user: GitHubUser) {
        RealmManager.shared.saveFavoriteGitHubUser(user)
    }
    
    func deleteFavoriteUser(_ user: GitHubUser) {
        RealmManager.shared.deleteGitHubUser(user)
    }
    
    func cancel() {
        self.users = []
    }
}
