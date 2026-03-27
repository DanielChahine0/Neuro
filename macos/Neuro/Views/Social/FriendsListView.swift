import SwiftUI

struct FriendsListView: View {
    @Environment(SocialViewModel.self) private var socialVM
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        @Bindable var vm = socialVM

        VStack(spacing: 0) {
            header

            Divider().overlay(Color.neuroBorder)

            if !authVM.isAuthenticated {
                notSignedInState
            } else if socialVM.friends.isEmpty && !socialVM.isLoading {
                emptyState
            } else {
                friendsList
            }
        }
        .background(Color.neuroBackground)
        .sheet(isPresented: $vm.showAddFriend) {
            addFriendSheet
        }
        .task {
            if authVM.isAuthenticated {
                await socialVM.loadFriends()
                await socialVM.startObservingFriends()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Friends")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            if authVM.isAuthenticated {
                Button {
                    socialVM.showAddFriend = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.neuroAccent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Friends List

    private var friendsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Active now section
                if !socialVM.activeFriends.isEmpty {
                    sectionHeader("Active Now", icon: "circle.fill", iconColor: .green)

                    ForEach(socialVM.activeFriends) { friend in
                        friendRow(friend, showActiveIndicator: true)
                    }

                    Divider()
                        .overlay(Color.neuroBorder)
                        .padding(.vertical, 8)
                }

                // All friends
                sectionHeader("All Friends", icon: "person.2.fill", iconColor: Color.neuroAccent)

                ForEach(socialVM.friends) { friend in
                    friendRow(friend, showActiveIndicator: false)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func sectionHeader(_ title: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundStyle(iconColor)
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neuroMuted)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }

    private func friendRow(_ friend: Friend, showActiveIndicator: Bool) -> some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.neuroAccent.opacity(0.2))
                    .frame(width: 36, height: 36)

                Text(String(friend.displayName.prefix(1)).uppercased())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.neuroAccent)

                if friend.isInSession {
                    Circle()
                        .fill(.green)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().strokeBorder(Color.neuroBackground, lineWidth: 2))
                        .offset(x: 13, y: 13)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(friend.email)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroMuted)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                // Streak badge
                if friend.currentStreak > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.orange)
                        Text("\(friend.currentStreak)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.orange)
                    }
                }

                // Weekly focus time
                Text(friend.weeklyFocusTime.formatted())
                    .font(.system(size: 10))
                    .foregroundStyle(Color.neuroMuted)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .contextMenu {
            Button(role: .destructive) {
                Task { await socialVM.removeFriend(friend) }
            } label: {
                Label("Remove Friend", systemImage: "person.badge.minus")
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 32))
                .foregroundStyle(Color.neuroMuted)

            Text("No friends yet")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)

            Text("Add friends to see their progress\nand stay accountable together.")
                .font(.system(size: 12))
                .foregroundStyle(Color.neuroMuted)
                .multilineTextAlignment(.center)

            Button {
                socialVM.showAddFriend = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                    Text("Add Friend")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }

    private var notSignedInState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 32))
                .foregroundStyle(Color.neuroMuted)

            Text("Sign in to connect with friends")
                .font(.system(size: 13))
                .foregroundStyle(Color.neuroMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Add Friend Sheet

    private var addFriendSheet: some View {
        @Bindable var vm = socialVM

        return VStack(spacing: 16) {
            Text("Add Friend")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            TextField("Friend's email address", text: $vm.friendEmailToAdd)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13))

            if let error = socialVM.errorMessage {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroDanger)
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    socialVM.showAddFriend = false
                    socialVM.friendEmailToAdd = ""
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.neuroMuted)

                Button {
                    Task { await socialVM.addFriend() }
                } label: {
                    Text("Send Request")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .disabled(socialVM.friendEmailToAdd.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 320)
        .background(Color.neuroSurface)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FriendsListView()
        .environment(SocialViewModel(
            socialService: MockSocialService(),
            modelContext: try! ModelContainer(for: Friend.self).mainContext,
            userId: "preview"
        ))
        .environment(AuthViewModel(authService: MockAuthService()))
        .frame(width: 360, height: 480)
}
