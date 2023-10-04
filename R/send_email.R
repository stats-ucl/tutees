#' Generic function to write the body of an email message, starting from a
#' template provided in the file 'file'.
#'
#' @param file A string with the path pointing to the text file that contains
#' the text of the email to be sent. The file is parsed through \code{blastula},
#' which uses the function \code{md} (based on \code{glue}) to "glue" the text
#' into a single string to be parsed in html code. For this reason, \code{R} code
#' **must** be included in the syntax \code{\{CODE HERE\}}, for example
#' \code{\{data$name[i]\}} and \code{Rmarkdown}. See the template in the
#' example.
#' "chunks" don't work.
#' @author Gianluca Baio
#' @keywords Tutees emails
#' @export write_email
#' @examples
#' \dontrun{
#' email=write_email(
#'   system.file("templates","example.qmd",package="tutees")
#' )
#' send_email(
#'   email=email,
#'   subject="Just a quick example...",
#'   to="g.baio@ucl.ac.uk"
#' )
#' }
#
write_email=function(file) {
  text=paste(readLines(file),collapse="\n")
  blastula::compose_email(
    body=blastula::md(glue::glue(text)),template=my_template
  )
}

#' Sends an email using a combination of 'blastula' and 'Microsoft365R'
#'
#' @param email An email created using 'blastula', typically the output of a
#' call to the function \code{write_email}
#' @param subject A string of text with the subject in the email
#' @param from A string with the email address from which the message should
#' be sent. Deafaults to the 'Stats Tutor' shared mailbox
#' ("stats.tutor@ucl.ac.uk"). It can be also specified to be the
#' account whose credentials have been authenticated by 'Microsoft365', or
#' another account that has right to send from this authenticated user.
#' @param to A string with the email address of the recipient(s) of the email.
#' Multiple addresses can be included in a vector
#' @param cc A string with the email address of the CC recipient(s) of the
#' email. Multiple addresses can be included in a vector
#' @param bcc A string with the email address of the BCC recipient(s) of the
#' email. Multiple addresses can be included in a vector
#' @param attachment The full path to an attachment file
#' @param \dots Additional options.
#' @author Gianluca Baio
#' @keywords Tutees emails
#' @examples
#' \dontrun{
#' email=write_email(
#'   system.file("templates","example.qmd",package="tutees")
#' )
#' send_email(
#'   email=email,
#'   subject="Just a quick example...",
#'   to="g.baio@ucl.ac.uk",
#'   cc=c("g.baio@ucl.ac.uk","gianluca@statistica.it")
#' )
#' }
#' @export send_email
#'
send_email=function(email,subject,from="stats.tutor@ucl.ac.uk",to,
                    cc=NULL,bcc=NULL,attachment=NULL,...) {

  # First gets the Microsoft Outlook credentials
  # AzureR can save securely the authentication credentials in the folder
  # '~/.local/share/AzureR
  # (only need to do it once and then this step is seemless). If not can
  # decide to authenticate all the time that this function is called
  creds=Microsoft365R::get_business_outlook()

  # This is the personal email address that is authenticated by 'Microsoft365'
  personal_mail=creds$properties$mail
  other_mail=creds$properties$otherMails

  # Creates the email with the body of text
  mail=creds$create_email(email)

  # By default, makes sure the email is sent 'on behalf of' the shared inbox
  if(from=="stats.tutor@ucl.ac.uk") {
    mail=mail$update(
      from = list(
        emailAddress = list(
          address = "stats.tutor@ucl.ac.uk")
      )
    )
  }
  # If the user is trying to send from an email address that has no right to do
  # send emails, then stop and suggest what can be used
  if(!(from %in% c("stats.tutor@ucl.ac.uk",personal_mail,other_mail))) {
    stop(
      glue::glue("You can only send messages from {c(personal_mail,other_mail)}",
                 last = " and ")
    )
  }
  # If 'from=personal_mail' nothing needs to happen and the email will be
  # sent from the default account that has authenticated in 'creds'

  # Adds recipients
  mail$add_recipients(to=to,cc=cc,bcc=bcc)

  # Adds subject
  mail$set_subject(subject)

  # If specified, adds attachment
  if(!is.null(attachment)) {
    mail$add_attachment(attachment)
  }

  # Finally sends the email
  mail$send()
}


#' Authenticate a user using a "device code".
#'
#' @description Authenticate a user with a "device code", meaning that the
#' process can occur without direct access to a web-browser. This is helpful if
#' running the package remotely (eg through docker or the Rstudio server),
#' because using this function, the user can be authenticated - then every
#' successive call to 'send_email' will simply refresh the authentication,
#' until a change in password (at which point, the user will need to
#' re-authenticate). R issues a code and instructions to log-in.
#' The log-in only needs to happen once and then issuing the simple command
#' with no inputs just works
#'
#' @author Gianluca Baio
#' @keywords Tutees emails
#' @examples
#' \dontrun{
#' authenticate_token()
#' }
#' @export authenticate_token
#'
authenticate_token <- function() {
  creds=Microsoft365R::get_business_outlook(auth_type="device_code")
}


#' Template function to send an email with 'blastula' ensuring the formatting
#' is done properly (full width and with limited padding all round the body
#' of the message)
#'
#' @author Gianluca Baio
#' @keywords Tutees emails
#'
my_template <- function(html_body=NULL,
                        html_header=NULL,
                        html_footer=NULL,
                        title=NULL,
                        content_width = "100000px",
                        font_family = "Helvetica, sans-serif") {

  result <- htmltools::renderTags(
    tagList(
      tags$head(
        # derived from https://github.com/TedGoas/Cerberus
        htmltools::includeHTML(system.file(package = "blastula", "cerberus-meta.html")),
        tags$title(title),
        tags$style(HTML(paste0("
body {
  font-family: ", font_family, ";
  font-size: 14px;
}
.content {
  background-color: white;
  width: 100%!important;
}
.container {
  width: 100%!important;
  background-color: white;
  padding: 0!important;
  margin: 0!important;
}
.content .message-block {
  margin-bottom: 0px;
  width: 100%!important;
}
.header .message-block, .footer message-block {
  margin-bottom: 0px;
}
img {
  max-width: 100%;
}
@media only screen and (max-width: 767px) {
  .container {
    width: 100%;
  }
  .articles, .articles tr, .articles td {
    display: block;
    width: 100%;
  }
  .article {
    margin-bottom: 0px;
  }
}
      ")))
      ),
      tags$body(
        style = css(
          background_color = "#f6f6f6",
          font_family = font_family,
          color = "#222",
          margin = "0",
          padding = "0"
        ),
        blastula:::panel(outer_class = "container", outer_align = "center", padding = "0px",
                         width = "100%", max_width = htmltools::validateCssUnit(content_width),

                         if (!is.null(html_header)) {
                           div(class = "header",
                               style = css(
                                 font_family = font_family,
                                 color = "#999999",
                                 font_size = "12px",
                                 font_weight = "normal",
                                 margin = "0 0 24px 0",
                                 text_align = "left"
                               ),
                               html_header
                           )
                         },
                         blastula:::panel(outer_class = "content", padding = "12px", background_color = "white",
                                          html_body
                         ),
                         if (!is.null(html_footer)) {
                           div(class = "footer",
                               style = css(
                                 font_family = font_family,
                                 color = "#999999",
                                 font_size = "12px",
                                 font_weight = "normal",
                                 margin = "24px 0 0 0",
                                 text_align = "center"
                               ),
                               html_footer
                           )
                         }
        )
      )
    )
  )

  HTML(sprintf("<!doctype html>
<html>
  <head>
%s
  </head>
%s
</html>", result$head, result$html))
}


