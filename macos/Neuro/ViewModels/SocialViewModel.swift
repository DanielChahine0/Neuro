import SwiftUI
import SwiftData

@MainActor @Observable
final class SocialViewModel {
    var friends: [Friend] = []
    var isLoading = false
    var errorMessage: String?
    var friendEmailToAdd = ""
    var showAddFriend = false

    private let socialService: SocialServiceProtocol
    private let modelContext: ModelContext
    private let userId: String
    private var observeTask: Task<Void, Never>?

    var activeFriends: [Friend] {
        friends.filter(\.isInSession)
    }

    init(socialService: SocialServiceProtocol, modelContext: ModelContext, userId: String) {
        self.socialService = socialService
        self.modelContext = modelContext
        self.userId = userId
    }

    func loadFriends() async {
        isLoading = true
        errorMessage = nil

        do {
            let friendData = try await socialService.fetchFriends(userId: userId)
            syncFriendsToStore(friendData)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func addFriend() async {
        let email = friendEmailToAdd.trimmingCharacters(in: .whitespaces)
        guard !email.isEmpty else {
            errorMessage = "Please enter an email address."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await socialService.addFriend(userId: userId, friendEmail: email)
            friendEmailToAdd = ""
            showAddFriend = false
            await loadFriends()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func removeFriend(_ friend: Friend) async {
        isLoading = true
        errorMessage = nil

        do {
            try await socialService.removeFriend(userId: userId, friendId: friend.id)
            modelContext.delete(friend)
            friends.removeAll { $0.id == friend.id }
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func startObservingFriends() async {
        observeTask?.cancel()

        observeTask = Task {
            let stream = socialService.observeFriends(userId: userId)
            for await friendData in stream {
                guard !Task.isCancelled else { break }
                syncFriendsToStore(friendData)
            }
        }
    }

    func syncMyStatus(isInSession: Bool, sessionStart: Date?) async {
        do {
            try await socialService.syncSessionStatus(
                userId: userId,
                isInSession: isInSession,
                sessionStartDate: sessionStart
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateMyStats(totalTime: TimeInterval, sessions: Int, streak: Int) async {
        do {
            try await socialService.updateUserStats(
                userId: userId,
                totalFocusTime: totalTime,
                totalSessions: sessions,
                currentStreak: streak
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func syncFriendsToStore(_ friendData: [FriendData]) {
        let descriptor = FetchDescriptor<Friend>()
        let existingFriends: [Friend]
        do {
            existingFriends = try modelContext.fetch(descriptor)
        } catch {
            existingFriends = []
        }

        let existingById = Dictionary(uniqueKeysWithValues: existingFriends.map { ($0.id, $0) })

        var updatedFriends: [Friend] = []

        for data in friendData {
            if let existing = existingById[data.uid] {
                existing.email = data.email
                existing.displayName = data.displayName
                existing.isInSession = data.isInSession
                existing.currentStreak = data.currentStreak
                existing.weeklyFocusTime = data.weeklyFocusTime
                existing.lastUpdated = .now
                updatedFriends.append(existing)
            } else {
                let friend = Friend(
                    id: data.uid,
                    email: data.email,
                    displayName: data.displayName,
                    isInSession: data.isInSession,
                    currentStreak: data.currentStreak,
                    weeklyFocusTime: data.weeklyFocusTime
                )
                modelContext.insert(friend)
                updatedFriends.append(friend)
            }
        }

        let activeIds = Set(friendData.map(\.uid))
        for existing in existingFriends where !activeIds.contains(existing.id) {
            modelContext.delete(existing)
        }

        friends = updatedFriends

        do {
            try modelContext.save()
        } catch {
            // Save failed silently
        }
    }

    deinit {
        observeTask?.cancel()
    }
}
