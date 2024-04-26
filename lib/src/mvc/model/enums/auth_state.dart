///[AuthState] is an enum with three distinct possibilities, each serving a specific purpose within the context of user session management
enum AuthState {
  ///`awaiting`: This enumeration value is utilized to signify that the process
  ///of retrieving session information is currently underway. It serves as an
  ///indicator that the application is in the process of determining the user's
  ///authentication status.
  awaiting,

  ///`authenticated`: The authenticated value is a crucial aspect of AuthState,
  ///as it signifies that an active and valid user session is present. This
  ///value is set when the user is successfully authenticated, allowing them
  ///to interact with the application's features and functionalities seamlessly.
  authenticated,

  ///`unauthenticated`: The unauthenticated enumeration value is used to denote
  ///scenarios where there is no active user session. This typically occurs
  ///when the user is not logged in or when their session has expired. It
  ///serves as a marker to indicate that certain actions or views within the
  ///app may be restricted or require authentication.
  unauthenticated,
}
