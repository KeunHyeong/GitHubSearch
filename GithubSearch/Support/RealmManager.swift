import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    // GitHubUser 데이터를 LocalGitHubUser로 변환하여 저장
    func saveFavoriteGitHubUser(_ user: GitHubUser) {
        let localUser = LocalGitHubUser(user: user)
        do {
            try realm.write {
                realm.add(localUser, update: .modified)
            }
        } catch {
            print("Error saving GitHubResponse to Realm: \(error)")
        }
    }
    
    // 저장된 LocalGitHubUser 데이터를 GitHubUser로 변환하여 반환
    func getAllGitHubUsers() -> [GitHubUser] {
        let localUsers = realm.objects(LocalGitHubUser.self)
        return localUsers.map { GitHubUser(localUser: $0) }
    }
    
    // GitHubUser 삭제
    func deleteGitHubUser(_ user: GitHubUser) {
        if let localUser = realm.objects(LocalGitHubUser.self).filter("id == %@", user.id).first {
            do {
                try realm.write {
                    realm.delete(localUser)
                }
            } catch {
                print("Error deleting GitHubUser from Realm: \(error)")
            }
        }
    }
}
