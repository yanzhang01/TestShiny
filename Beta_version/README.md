This Shiny app is made by Yan Zhang. Still in develop-and-test mode. *Not Online Yet.*


# Run the Shiny app of PgenePapers (beta version)
To run the app locally, you need to install R on your computer, and then install the **shiny** package in R.

Run the app in R:

```R
if (!require('shiny')) install.packages("shiny")
shiny::runGitHub("shiny_PgenePapers", "yanzhang01", subdir = "Beta_version")
```
