import SwiftUI

struct LogIn: View {
    // State properties to bind to the user inputs
    // These properties will automatically update when the user interacts with the UI components.
    @State private var email = ""               // Holds the email entered by the user
    @State private var password = ""            // Holds the password entered by the user
    @State private var showPassword = false       // Toggle to reveal or hide the password text
    @State private var showError = false          // Flag to show or hide error messages
    @State private var errorMessage = ""        // Holds the error message to display if login fails
    @State private var navigateToHome = false     // Flag to trigger navigation to the HomeView after successful login

    var body: some View {
        // NavigationView allows us to use navigation between views
        NavigationView {
            ZStack {
                // Background Gradient: A gradient that spans the entire background from top to bottom
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)  // Ensure gradient covers the entire screen

                VStack {
                    // App Title: "Whisper"
                    Text("Whisper")
                        .font(.custom("Avenir", size: 80))  // Custom font "Avenir" with a large size
                        .fontWeight(.bold)                  // Bold font weight
                        .foregroundColor(.white)            // White text for contrast
                        .padding(.top, 50)                  // Space from the top
                        .offset(y: 25)                      // Slight downward adjustment

                    Spacer()  // Pushes remaining content downwards

                    // Email input field: Allows the user to enter their email
                    TextField(
                        "Enter your email",
                        text: Binding(
                            get: { self.email },
                            set: { self.email = $0.lowercased() }  // Automatically lowercase the email input
                        )
                    )
                    .padding()                                         // Padding inside the field
                    .background(Color.white.opacity(0.3))             // Semi-transparent background
                    .cornerRadius(8)                                  // Rounded corners
                    .padding(.horizontal, 30)                         // Center horizontally
                    .foregroundColor(.white)                          // White text color
                    .padding(.vertical, 12)                           // Vertical padding
                    .autocapitalization(.none)                        // No autocapitalization for emails

                    // Password input field with visibility toggle inside the field
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .autocapitalization(.none)
                            }
                        }
                        .foregroundColor(.white)                        // White text color

                        // Toggle button to show/hide password
                        Button(action: {
                            showPassword.toggle()                       // Flip the visibility state
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))    // Slightly transparent icon
                        }
                    }
                    .padding()                                         // Padding inside the HStack
                    .background(Color.white.opacity(0.3))             // Background for the entire field
                    .cornerRadius(8)                                  // Rounded corners
                    .padding(.horizontal, 30)                         // Center horizontally
                    .padding(.top, 20)                                // Space from the email field
                    .padding(.vertical, 12)                           // Vertical padding

                    // Display an error message if the credentials are invalid
                    if showError {
                        Text(errorMessage)                           // Show the error message stored in the state
                            .foregroundColor(.red)                  // Red text color
                            .padding(.top, 10)                      // Space from the password field
                    }

                    // Log In button: A button to trigger the login process
                    Button(action: {
                        // Validate the user's email and password
                        if validateCredentials() {
                            // If validation is successful, navigate to the HomeView
                            showError = false
                            navigateToHome = true
                        } else {
                            // If validation fails, display an error message
                            showError = true
                        }
                    }) {
                        Text("Log In")                              // Button title
                            .fontWeight(.semibold)                   // Semi-bold text
                            .frame(maxWidth: .infinity)              // Fill full width
                            .padding()                               // Padding inside the button
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#F07D00"), Color(hex: "#8A4800")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )                                         // Gradient background
                            .foregroundColor(.white)                  // White text color
                            .cornerRadius(8)                          // Rounded corners
                            .padding(.horizontal, 30)                 // Center horizontally
                            .padding(.top, 30)                        // Space from the password field
                    }

                    Spacer()  // Pushes remaining content upwards

                    // Sign Up link: A link to navigate to the sign-up page
                    NavigationLink(destination: SignUp(
                        isSignedIn: .constant(false),
                        selectedTab: .constant(.home)
                    )){
                        Text("Do not have an account? Sign Up")
                            .foregroundColor(.blue)                  // Link color
                            .padding(.bottom, 50)                    // Space at the bottom
                    }
                }
                .navigationBarHidden(true)                        // Hide the navigation bar
                .background(
                    // Hidden NavigationLink that triggers navigation to HomeView
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $navigateToHome,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
            }
        }
    }

    // Function to validate email and password
    private func validateCredentials() -> Bool {
        // Validate the email address using a regular expression
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."  // Set error message
            return false
        }
        
        // Check if the password is empty
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty."            // Set error message
            return false
        }
        
        // Clear error message if validation passes
        errorMessage = ""
        return true
    }

    // Function to validate the email format using a regular expression
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for a valid email format
        let emailRegEx = "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)  // Return whether the email matches the regex
    }
}

#Preview {
    LogIn()
}
