//import SwiftUI
//
//// MARK: – Color Extension for Hex Initialization
//extension Color {
//    /// Initialize a Color from a hex string, e.g. "#FF0000" or "FF0000"
//    init(hex: String) {
//        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
//        var hexInt: UInt64 = 0
//        Scanner(string: hexSanitized).scanHexInt64(&hexInt)
//        let red = Double((hexInt >> 16) & 0xFF) / 255.0
//        let green = Double((hexInt >> 8) & 0xFF) / 255.0
//        let blue = Double(hexInt & 0xFF) / 255.0
//        self.init(red: red, green: green, blue: blue)
//    }
//}
//
//struct SignUp: View {
//    // MARK: – User Input States
//    @Binding var isSignedIn: Bool
//    @Binding var selectedTab: Tab
//    @State private var firstName: String = ""
//    @State private var lastName: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    
//    // MARK: – UI State Flags
//    @State private var isLoading: Bool = false          // Show spinner during network call
//    @State private var showAlert: Bool = false          // Trigger error/success alert
//    @State private var alertMessage: String = ""        // Error/success message text
//    @State private var navigateToHome: Bool = false     // Control navigation on success
//    
//    // MARK: – Password Visibility Toggles
//    @State private var showPassword: Bool = false
//    @State private var showConfirmPassword: Bool = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // MARK: – Background Gradient
//                LinearGradient(
//                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
//                    startPoint: .top, endPoint: .bottom
//                )
//                .edgesIgnoringSafeArea(.all)
//                
//                VStack(spacing: 20) {
//                    // MARK: – Header
//                    VStack {
//                        Text("Welcome")
//                            .font(.title3)
//                            .foregroundColor(.white)
//                            .offset(y: -15)
//                        Text("Whisper")
//                            .font(.custom("Avenir", size: 55))
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                    }
//                    .offset(y: -10)
//                    
//                    // MARK: – Form Section
//                    Section(header:
//                        Text("Enter Details")
//                            .font(.custom("Avenir", size: 18))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .foregroundColor(Color(.systemGray))
//                    ) {
//                        // First Name
//                        TextField("First Name", text: $firstName)
//                            .styledField()
//                            .autocapitalization(.words)
//                            .disableAutocorrection(true)
//                        
//                        // Last Name
//                        TextField("Last Name", text: $lastName)
//                            .styledField()
//                            .autocapitalization(.words)
//                            .disableAutocorrection(true)
//                        
//                        // Email Address
//                        TextField("Email", text: $email)
//                            .styledField()
//                            .keyboardType(.emailAddress)
//                            .autocapitalization(.none)
//                            .disableAutocorrection(true)
//                        
//                        // Password with visibility toggle inside the field
//                        ZStack(alignment: .trailing) {
//                            Group {
//                                if showPassword {
//                                    TextField("Password", text: $password)
//                                } else {
//                                    SecureField("Password", text: $password)
//                                }
//                            }
//                            .styledField(paddingRight: 40)
//
//                            Button(action: { showPassword.toggle() }) {
//                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.trailing, 16)
//                        }
//                        
//                        // Confirm Password with visibility toggle inside the field
//                        ZStack(alignment: .trailing) {
//                            Group {
//                                if showConfirmPassword {
//                                    TextField("Confirm Password", text: $confirmPassword)
//                                } else {
//                                    SecureField("Confirm Password", text: $confirmPassword)
//                                }
//                            }
//                            .styledField(paddingRight: 40)
//
//                            Button(action: { showConfirmPassword.toggle() }) {
//                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.trailing, 16)
//                        }
//                    }
//                    
//                    // MARK: – Sign Up Button / Loading Indicator
//                    if isLoading {
//                        ProgressView()
//                            .padding()
//                    } else {
//                        Button(action: signUp) {
//                            Text("Sign Up")
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(
//                                    LinearGradient(
//                                        gradient: Gradient(colors: [Color(hex: "#F07D00"), Color(hex: "#8A4800")]),
//                                        startPoint: .leading, endPoint: .trailing
//                                    )
//                                )
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                        .offset(y: 10)
//                    }
//                    
//                    // MARK: – Navigation Links
//                    NavigationLink(destination: LogIn()) {
//                        Text("Already have an account? Sign In")
//                            .foregroundColor(.blue)
//                    }
//                    NavigationLink(value: navigateToHome) {
//                        EmptyView()
//                    }
//                }
//                .padding()
//            }
//            // MARK: – Alert Handling
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Sign Up"),
//                    message: Text(alertMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            // MARK: – Successful Navigation
//            .navigationDestination(isPresented: $navigateToHome) {
//                HomeView()
//            }
//        }
//    }
//    
//    // MARK: – Sign Up Logic
//    private func signUp() {
//        do {
//            try validateForm()
//            isLoading = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                isLoading = false
//                alertMessage = "Sign up successful!"
//                showAlert = true
//                navigateToHome = true
//            }
//        } catch {
//            alertMessage = error.localizedDescription
//            showAlert = true
//        }
//    }
//    
//    // MARK: – Form Validation
//    private func validateForm() throws {
//        let nameRegex = "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$"
//        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
//        guard namePredicate.evaluate(with: "\(firstName) \(lastName)") else {
//            throw SignUpError.invalidName
//        }
//        
//        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        guard emailPredicate.evaluate(with: email) else {
//            throw SignUpError.invalidEmail
//        }
//        
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
//        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        guard passwordPredicate.evaluate(with: password) else {
//            throw SignUpError.invalidPassword
//        }
//        
//        guard password == confirmPassword else {
//            throw SignUpError.passwordsDoNotMatch
//        }
//    }
//}
//
//// MARK: – Validation Error Definitions
//enum SignUpError: Error, LocalizedError {
//    case invalidName, invalidEmail, invalidPassword, passwordsDoNotMatch
//    var errorDescription: String? {
//        switch self {
//        case .invalidName: return "Please enter a valid first and last name."
//        case .invalidEmail: return "Please enter a valid email address."
//        case .invalidPassword: return "Password must be at least 8 characters long and contain at least one letter, one number, and one special character."
//        case .passwordsDoNotMatch: return "Passwords do not match."
//        }
//    }
//}
//
//// MARK: – Reusable TextField Styling Modifier
//private extension View {
//    /// Applies common styling for text fields and secure fields
//    func styledField(paddingRight: CGFloat = 10) -> some View {
//        self
//            .padding(.horizontal, 10)
//            .padding(.trailing, paddingRight)
//            .frame(height: 55)
//            .background(Color(.systemGray6))
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
//    }
//}
//
//// MARK: – Preview
//#Preview {
//    SignUp(isSignedIn: .constant(false), selectedTab: .constant(.home))
//}


import SwiftUI

// MARK: – Color Extension for Hex Initialization
extension Color {
    /// Initialize a Color from a hex string, e.g. "#FF0000" or "FF0000"
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        var hexInt: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&hexInt)
        let red = Double((hexInt >> 16) & 0xFF) / 255.0
        let green = Double((hexInt >> 8) & 0xFF) / 255.0
        let blue = Double(hexInt & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


struct SignUp: View {
    // MARK: – User Input States
    @Binding var isSignedIn: Bool
    @Binding var selectedTab: Tab
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // MARK: – UI State Flags
    @State private var isLoading: Bool = false          // Show spinner during network call
    @State private var showAlert: Bool = false          // Trigger error/success alert
    @State private var alertMessage: String = ""        // Error/success message text
    
    // MARK: – Password Visibility Toggles
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: – Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // MARK: – Header
                    VStack {
                        Text("Welcome")
                            .font(.title3)
                            .foregroundColor(.white)
                            .offset(y: -15)
                        Text("Whisper")
                            .font(.custom("Avenir", size: 55))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .offset(y: -10)
                    
                    // MARK: – Form Section
                    Section(header:
                        Text("Enter Details")
                            .font(.custom("Avenir", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(.systemGray))
                    ) {
                        // First Name
                        TextField("First Name", text: $firstName)
                            .styledField()
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        // Last Name
                        TextField("Last Name", text: $lastName)
                            .styledField()
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        // Email Address
                        TextField("Email", text: $email)
                            .styledField()
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        // Password with visibility toggle inside the field
                        ZStack(alignment: .trailing) {
                            Group {
                                if showPassword {
                                    TextField("Password", text: $password)
                                } else {
                                    SecureField("Password", text: $password)
                                }
                            }
                            .styledField(paddingRight: 40)

                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                        
                        // Confirm Password with visibility toggle inside the field
                        ZStack(alignment: .trailing) {
                            Group {
                                if showConfirmPassword {
                                    TextField("Confirm Password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm Password", text: $confirmPassword)
                                }
                            }
                            .styledField(paddingRight: 40)

                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    
                    // MARK: – Sign Up Button / Loading Indicator
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        Button(action: signUp) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#F07D00"), Color(hex: "#8A4800")]),
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .offset(y: 10)
                    }
                    
                    // MARK: – Navigation Link to LogIn (if you have it)
                    NavigationLink(destination: LogIn()) {
                        Text("Already have an account? Sign In")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            // MARK: – Alert Handling
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sign Up"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: – Sign Up Logic with Validation and Navigation
    private func signUp() {
        do {
            try validateForm()
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
                alertMessage = "Sign up successful!"
                showAlert = true
                
                // Navigate after alert dismissed — for simplicity, directly set:
                selectedTab = .home
                isSignedIn = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    // MARK: – Form Validation
    private func validateForm() throws {
        let nameRegex = "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: "\(firstName) \(lastName)") else {
            throw SignUpError.invalidName
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            throw SignUpError.invalidEmail
        }
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        guard passwordPredicate.evaluate(with: password) else {
            throw SignUpError.invalidPassword
        }
        
        guard password == confirmPassword else {
            throw SignUpError.passwordsDoNotMatch
        }
    }
}

// MARK: – Validation Error Definitions
enum SignUpError: Error, LocalizedError {
    case invalidName, invalidEmail, invalidPassword, passwordsDoNotMatch
    var errorDescription: String? {
        switch self {
        case .invalidName: return "Please enter a valid first and last name."
        case .invalidEmail: return "Please enter a valid email address."
        case .invalidPassword: return "Password must be at least 8 characters long and contain at least one letter, one number, and one special character."
        case .passwordsDoNotMatch: return "Passwords do not match."
        }
    }
}

// MARK: – Reusable TextField Styling Modifier
private extension View {
    /// Applies common styling for text fields and secure fields
    func styledField(paddingRight: CGFloat = 10) -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.trailing, paddingRight)
            .frame(height: 55)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

// MARK: – Preview
#Preview {
    SignUp(isSignedIn: .constant(false), selectedTab: .constant(.home))
}
