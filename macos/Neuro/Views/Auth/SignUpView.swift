import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        @Bindable var vm = authVM

        VStack(spacing: 24) {
            // Logo
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.neuroAccent)

                Text("Create Account")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Join Neuro and start focusing.")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.neuroMuted)
            }

            // Form
            VStack(spacing: 12) {
                TextField("Display Name", text: $vm.displayName)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.name)

                TextField("Email", text: $vm.email)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.emailAddress)

                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.newPassword)

                SecureField("Confirm Password", text: $vm.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.newPassword)

                Text("Password must be at least 6 characters.")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.neuroMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Error
            if let error = authVM.errorMessage {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroDanger)
                    .multilineTextAlignment(.center)
            }

            // Password mismatch warning
            if !authVM.confirmPassword.isEmpty && authVM.password != authVM.confirmPassword {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Passwords do not match")
                        .font(.system(size: 11))
                }
                .foregroundStyle(Color.neuroWarning)
            }

            // Create Account button
            Button {
                Task { await authVM.signUp() }
            } label: {
                HStack(spacing: 6) {
                    if authVM.isLoading {
                        ProgressView()
                            .controlSize(.small)
                    }
                    Text("Create Account")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    authVM.isSignUpValid ? Color.neuroAccent : Color.neuroAccent.opacity(0.4),
                    in: RoundedRectangle(cornerRadius: 8)
                )
            }
            .buttonStyle(.plain)
            .disabled(!authVM.isSignUpValid || authVM.isLoading)

            // Divider
            HStack {
                Rectangle().fill(Color.neuroBorder).frame(height: 1)
                Text("or")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroMuted)
                Rectangle().fill(Color.neuroBorder).frame(height: 1)
            }

            // Sign in link
            Button {
                authVM.showSignUp = false
            } label: {
                Text("Already have an account? ")
                    .foregroundStyle(Color.neuroMuted) +
                Text("Sign In")
                    .foregroundStyle(Color.neuroAccent)
                    .bold()
            }
            .font(.system(size: 12))
            .buttonStyle(.plain)
        }
        .padding(32)
        .frame(width: 320)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel(authService: MockAuthService()))
        .padding(40)
        .background(Color.neuroBackground)
}
