# HoDemails

This package uses [blastula](https://github.com/rstudio/blastula), [Microsoft365R](https://github.com/Azure/Microsoft365R) and [htmltools](https://cran.r-project.org/web/packages/htmltools/index.html) to streamline the process of sending emails, particularly when the body of the message is the output of some data-wrangling.

Examples include:
1. Send individualised emails to contacts stored in a spreadsheet (e.g. tutees meetings);
2. Send reminders for different issues (e.g. non compliance to mandatory training).

The package contains two functions:
1. `write_email`: this takes as input a file (it could be a [quarto](https://quarto.org) or an Rmarkdown file, with any amount of mark-down formatting) and pre-processes it through the `blastula` package to create the html-formatted body of the email. 
2. `send_email`: this uses the email message created by `write_email` and `Microsoft365R` to send it through the UCL account. The user is authenticated through the `AzureR` package and can specify the subject of the email, recipients and even add attachments.

