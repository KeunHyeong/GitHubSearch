//
//  LocalUserModel.swift
//  RememberTest
//
//  Created by 장근형 on 2/6/25.
//

import Foundation
import RealmSwift

class LocalGitHubUser: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var nodeId: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var htmlUrl: String = ""
    @objc dynamic var followersUrl: String = ""
    @objc dynamic var followingUrl: String = ""
    @objc dynamic var gistsUrl: String = ""
    @objc dynamic var starredUrl: String = ""
    @objc dynamic var subscriptionsUrl: String = ""
    @objc dynamic var organizationsUrl: String = ""
    @objc dynamic var reposUrl: String = ""
    @objc dynamic var eventsUrl: String = ""
    @objc dynamic var receivedEventsUrl: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var userViewType: String = ""
    @objc dynamic var siteAdmin: Bool = false
    @objc dynamic var score: Double = 0.0
    @objc dynamic var favorite: Bool = false //favorite 추가
    override static func primaryKey() -> String? {
        return "id"
    }
}

// GitHubUser -> LocalGitHubUser 변환
extension LocalGitHubUser {
    convenience init(user: GitHubUser) {
        self.init()
        self.login = user.login
        self.id = user.id
        self.nodeId = user.nodeID
        self.avatarUrl = user.avatarURL
        self.url = user.url
        self.htmlUrl = user.htmlURL
        self.followersUrl = user.followersURL
        self.followingUrl = user.followingURL
        self.gistsUrl = user.gistsURL
        self.starredUrl = user.starredURL
        self.subscriptionsUrl = user.subscriptionsURL
        self.organizationsUrl = user.organizationsURL
        self.reposUrl = user.reposURL
        self.eventsUrl = user.eventsURL
        self.receivedEventsUrl = user.receivedEventsURL
        self.type = user.type
        self.siteAdmin = user.siteAdmin
        self.score = user.score
        self.favorite = true
    }
}
