import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        @Bindable var vm = authVM

        VStack(spacing: 24) {
            // Logo
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.neuroAccent)

                Text("Neuro")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Stay focused. Build better habits.")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.neuroMuted)
            }

            // Form
            VStack(spacing: 12) {
                TextField("Email", text: $vm.email)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.emailAddress)

                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13))
                    .textContentType(.password)
            }

            // Error
            if let error = authVM.errorMessage {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroDanger)
                    .multilineTextAlignment(.center)
            }

            // Sign In button
            Button {
                Task { await authVM.signIn() }
            } label: {
                HStack(spacing: 6) {
                    if authVM.isLoading {
                        ProgressView()
                            .controlSize(.small)
                    }
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    authVM.isSignInValid ? Color.neuroAccent : Color.neuroAccent.opacity(0.4),
                    in: RoundedRectangle(cornerRadius: 8)
                )
            }
            .buttonStyle(.plain)
            .disabled(!authVM.isSignInValid || authVM.isLoading)

            // Forgot password
            Button {
                authVM.showResetPassword = true
            } label: {
                Text("Forgot Password?")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.neuroAccent)
            }
            .buttonStyle(.plain)

            // Divider
            HStack {
                Rectangle().fill(Color.neuroBorder).frame(height: 1)
                Text("or")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroMuted)
                Rectangle().fill(Color.neuroBorder).frame(height: 1)
            }

            // Sign up link
            Button {
                authVM.showSignUp = true
            } label: {
                Text("Don't have an account? ")
                    .foregroundStyle(Color.neuroMuted) +
                Text("Sign Up")
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
        .sheet(isPresented: $vm.showResetPassword) {
            resetPasswordSheet
        }
    }

    private var resetPasswordSheet: some View {
        @Bindable var vm = authVM

        return VStack(spacing: 16) {
            Text("Reset Password")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Text("Enter your email and we'll send you a reset link.")
                .font(.system(size: 12))
                .foregroundStyle(Color.neuroMuted)
                .multilineTextAlignment(.center)

            TextField("Email", text: $vm.email)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13))

            if let error = authVM.errorMessage {
                Text(error)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroDanger)
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    authVM.showResetPassword = false
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.neuroMuted)

                Button {
                    Task { await authVM.resetPassword() }
                } label: {
                    Text("Send Reset Link")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .disabled(authVM.isLoading)
            }
        }
        .padding(24)
        .frame(width: 300)
        .background(Color.neuroSurface)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel(authService: MockAuthService()))
        .padding(40)
        .background(Color.neuroBackground)
}
