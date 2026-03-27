import SwiftUI
import Combine

@MainActor @Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var displayName = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String?
    var isAuthenticated = false
    var currentUser: AuthUser?
    var showSignUp = false
    var showResetPassword = false

    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    var isSignInValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && password.count >= 6
    }

    var isSignUpValid: Bool {
        isSignInValid
            && !displayName.trimmingCharacters(in: .whitespaces).isEmpty
            && password == confirmPassword
    }

    init(authService: AuthServiceProtocol) {
        self.authService = authService

        authService.authStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }

    func signIn() async {
        guard isSignInValid else {
            errorMessage = "Please enter a valid email and password (6+ characters)."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
            clearForm()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signUp() async {
        guard isSignUpValid else {
            if password != confirmPassword {
                errorMessage = "Passwords do not match."
            } else {
                errorMessage = "Please fill in all fields with a valid password (6+ characters)."
            }
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signUp(
                email: email,
                password: password,
                displayName: displayName
            )
            currentUser = user
            isAuthenticated = true
            clearForm()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
            isAuthenticated = false
            clearForm()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resetPassword() async {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await authService.resetPassword(email: email)
            errorMessage = nil
            showResetPassword = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func clearForm() {
        email = ""
        password = ""
        displayName = ""
        confirmPassword = ""
        errorMessage = nil
    }
}
