import Foundation
import Combine

// MARK: - Auth Types

enum AuthError: LocalizedError {
    case signInFailed(String)
    case signUpFailed(String)
    case signOutFailed(String)
    case notAuthenticated

    var errorDescription: String? {
        switch self {
        case .signInFailed(let message): "Sign in failed: \(message)"
        case .signUpFailed(let message): "Sign up failed: \(message)"
        case .signOutFailed(let message): "Sign out failed: \(message)"
        case .notAuthenticated: "User is not authenticated"
        }
    }
}

struct AuthUser: Equatable {
    let uid: String
    let email: String
    let displayName: String?
}

struct FriendData: Equatable, Identifiable {
    let uid: String
    let email: String
    let displayName: String
    let isInSession: Bool
    let currentStreak: Int
    let weeklyFocusTime: TimeInterval

    var id: String { uid }
}

// MARK: - Auth Protocol

protocol AuthServiceProtocol: AnyObject {
    var currentUser: AuthUser? { get }
    var isAuthenticated: Bool { get }
    var authStatePublisher: AnyPublisher<AuthUser?, Never> { get }

    func signIn(email: String, password: String) async throws -> AuthUser
    func signUp(email: String, password: String, displayName: String) async throws -> AuthUser
    func signOut() throws
    func resetPassword(email: String) async throws
}

// MARK: - Social Protocol

protocol SocialServiceProtocol: AnyObject {
    func syncSessionStatus(userId: String, isInSession: Bool, sessionStartDate: Date?) async throws
    func updateUserStats(userId: String, totalFocusTime: TimeInterval, totalSessions: Int, currentStreak: Int) async throws
    func addFriend(userId: String, friendEmail: String) async throws -> String
    func removeFriend(userId: String, friendId: String) async throws
    func fetchFriends(userId: String) async throws -> [FriendData]
    func observeFriends(userId: String) -> AsyncStream<[FriendData]>
}

// MARK: - Mock Auth Service

class MockAuthService: AuthServiceProtocol, ObservableObject {
    @Published private(set) var currentUser: AuthUser?

    private let authStateSubject = CurrentValueSubject<AuthUser?, Never>(nil)

    var isAuthenticated: Bool { currentUser != nil }

    var authStatePublisher: AnyPublisher<AuthUser?, Never> {
        authStateSubject.eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        try await Task.sleep(nanoseconds: 500_000_000)

        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.signInFailed("Email and password are required")
        }

        let user = AuthUser(
            uid: UUID().uuidString,
            email: email,
            displayName: email.components(separatedBy: "@").first
        )
        currentUser = user
        authStateSubject.send(user)
        return user
    }

    func signUp(email: String, password: String, displayName: String) async throws -> AuthUser {
        try await Task.sleep(nanoseconds: 500_000_000)

        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.signUpFailed("Email and password are required")
        }
        guard password.count >= 6 else {
            throw AuthError.signUpFailed("Password must be at least 6 characters")
        }

        let user = AuthUser(
            uid: UUID().uuidString,
            email: email,
            displayName: displayName
        )
        currentUser = user
        authStateSubject.send(user)
        return user
    }

    func signOut() throws {
        currentUser = nil
        authStateSubject.send(nil)
    }

    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        guard !email.isEmpty else {
            throw AuthError.signInFailed("Email is required")
        }
    }
}

// MARK: - Mock Social Service

class MockSocialService: SocialServiceProtocol {
    private var friendsStore: [String: [FriendData]] = [:]
    private var sessionStatuses: [String: Bool] = [:]
    private var continuations: [String: AsyncStream<[FriendData]>.Continuation] = []

    func syncSessionStatus(userId: String, isInSession: Bool, sessionStartDate: Date?) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        sessionStatuses[userId] = isInSession
    }

    func updateUserStats(userId: String, totalFocusTime: TimeInterval, totalSessions: Int, currentStreak: Int) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
    }

    func addFriend(userId: String, friendEmail: String) async throws -> String {
        try await Task.sleep(nanoseconds: 300_000_000)

        let friendId = UUID().uuidString
        let friend = FriendData(
            uid: friendId,
            email: friendEmail,
            displayName: friendEmail.components(separatedBy: "@").first ?? friendEmail,
            isInSession: false,
            currentStreak: Int.random(in: 0...30),
            weeklyFocusTime: TimeInterval.random(in: 0...14400)
        )

        var friends = friendsStore[userId, default: []]
        friends.append(friend)
        friendsStore[userId] = friends

        continuations[userId]?.yield(friends)

        return friendId
    }

    func removeFriend(userId: String, friendId: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)

        var friends = friendsStore[userId, default: []]
        friends.removeAll { $0.uid == friendId }
        friendsStore[userId] = friends

        continuations[userId]?.yield(friends)
    }

    func fetchFriends(userId: String) async throws -> [FriendData] {
        try await Task.sleep(nanoseconds: 300_000_000)

        if friendsStore[userId] == nil {
            friendsStore[userId] = [
                FriendData(uid: "mock-1", email: "alice@example.com", displayName: "Alice",
                           isInSession: true, currentStreak: 12, weeklyFocusTime: 7200),
                FriendData(uid: "mock-2", email: "bob@example.com", displayName: "Bob",
                           isInSession: false, currentStreak: 5, weeklyFocusTime: 3600),
            ]
        }

        return friendsStore[userId, default: []]
    }

    func observeFriends(userId: String) -> AsyncStream<[FriendData]> {
        AsyncStream { continuation in
            self.continuations[userId] = continuation
            let current = self.friendsStore[userId, default: []]
            continuation.yield(current)

            continuation.onTermination = { [weak self] _ in
                self?.continuations.removeValue(forKey: userId)
            }
        }
    }
}
