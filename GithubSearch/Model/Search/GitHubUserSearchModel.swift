//
//  GitHubUserSearchViewmodel.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import Foundation

struct GitHubUser: Codable, Equatable, Hashable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let url: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    let score: Double
    var favorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case login, id, type, score
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
    }
}

struct GitHubResponse: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// LocalGitHubUser -> GitHubUser 변환
extension GitHubUser {
    init(localUser: LocalGitHubUser) {
        self.login = localUser.login
        self.id = localUser.id
        self.nodeID = localUser.nodeId
        self.avatarURL = localUser.avatarUrl
        self.url = localUser.url
        self.htmlURL = localUser.htmlUrl
        self.followersURL = localUser.followersUrl
        self.followingURL = localUser.followingUrl
        self.gistsURL = localUser.gistsUrl
        self.starredURL = localUser.starredUrl
        self.subscriptionsURL = localUser.subscriptionsUrl
        self.organizationsURL = localUser.organizationsUrl
        self.reposURL = localUser.reposUrl
        self.eventsURL = localUser.eventsUrl
        self.receivedEventsURL = localUser.receivedEventsUrl
        self.type = localUser.type
        self.siteAdmin = localUser.siteAdmin
        self.score = localUser.score
        self.favorite = localUser.favorite
    }
}
