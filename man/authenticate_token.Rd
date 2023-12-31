% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/send_email.R
\name{authenticate_token}
\alias{authenticate_token}
\title{Authenticate a user using a "device code".}
\usage{
authenticate_token()
}
\description{
Authenticate a user with a "device code", meaning that the
process can occur without direct access to a web-browser. This is helpful if
running the package remotely (eg through docker or the Rstudio server),
because using this function, the user can be authenticated - then every
successive call to 'send_email' will simply refresh the authentication,
until a change in password (at which point, the user will need to
re-authenticate). R issues a code and instructions to log-in.
The log-in only needs to happen once and then issuing the simple command
with no inputs just works
}
\examples{
\dontrun{
authenticate_token()
}
}
\author{
Gianluca Baio
}
\keyword{Tutees}
\keyword{emails}
