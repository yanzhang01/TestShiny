This Shiny app is made by Yan Zhang. Still in develop-and-test mode. *Not Online Yet.*


# Run the Shiny app of PgenePapers (beta version)
To run the app locally, you need to install R on your computer, and then install the **networkD3**, **DT** and **shiny** packages in R.

Run the app in R:

```R
if(!require('networkD3')) install.packages("networkD3")
if (!require('DT')) install.packages("DT")
if (!require('shiny')) install.packages("shiny")
shiny::runGitHub("shiny_PgenePapers", "yanzhang01", subdir = "Beta_version")
```

Note: Sometimes "Downloading https://..." does not work if your computer is under a very restricted firewall: status was 'Couldn't connect to server'. Then you may switch to another secure network temporarily.
