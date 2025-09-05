library(httr2)
endpoint <- "http://api.statbank.dk/v1/data"

variables <- list(list(code = "BOPOMR", values = I("*")),
                  list(code = "HFUDD", values = c("H10", "H20", "H30", "H40", "H50", "H60", "H70", "H80", "H90")),
                  list(code = "Tid", values = I(2024))
              )

our_body <- list(table = "HFUDD11", lang = "da", format = "CSV", variables = variables)



resp <- request(endpoint) |>
  req_body_json(our_body) |>
  req_perform()

csv_text <- resp_body_string(resp)


df <- read.csv2(text = csv_text)
df <- df |>mutate(BOPOMR = tolower(BOPOMR))

plotDK::municipality |> head()

library(plotDK)
library(dplyr)
library(ggplot2)
df |> 
  group_by(BOPOMR) |> 
  mutate(totbefolk = sum(INDHOLD)) |> 
  mutate(andel = INDHOLD/totbefolk) |> 
  filter(HFUDD == "H10 Grundskole") |> 
plotDK::plotDK(id = "BOPOMR", value = "andel", interactive = FALSE)  +
  scale_fill_gradient(low = "blue",
                      high = "red")
