#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Correlation and Regression for Fitbit Sample Data"),
  
  # Sidebar with instructions and input values
  sidebarLayout(
    sidebarPanel(
        h2("Introduction:"),
        helpText("This application is designed to help identify correlations
                 between Fitbit predictors. The sample data spans a period of 
                 approximately two months."),
        h3("Instructions:"),
        helpText(HTML(
            "<ol><li>Select predictors using the checkboxes.</li>
            <li>Use the slider to change the duration (days) of the moving 
            average (mav) window.</li>
            <li>Correlation values are provided in the lower diagonal.</li>
            <li>Values and LOESS regression are provided in the upper 
            diagonal.</li>
            </ol>")),
        h2("Controls:"),
        sliderInput("k",
                    "Sliding window size (days):",
                    min = 2,
                    max = 20,
                    value = 7),
        checkboxGroupInput("predictors", "Choose predictors:",
                           c("Weight Change" = "weight.change",
                             "Calories In" = "calories.in.mav",
                             "Calories Burned" = "calories.burned.mav",
                             "Calories Balance" = "calories.bal.mav",
                             "Carbs" = "carbs.mav",
                             "Fat" = "fat.mav",
                             "Fiber" = "fiber.mav",
                             "Sodium" = "sodium.mav",
                             "Sleep" = "sleep.mav",
                             "Sedentary" = "sedentary.mav",
                             "Activity" = "activity.mav",
                             "Steps" = "steps.mav",
                             "Snacks" = "snacks.mav",
                             "Meals" = "meals.mav",
                             "Breakfast" = "breakfast.mav",
                             "Lunch" = "lunch.mav",
                             "Dinner" = "dinner.mav",
                             "Snack: Morning" = "morning.snack.mav",
                             "Snack: Afternoon" = "afternoon.snack.mav",
                             "Snack: After Dinner" = "after.dinner.mav"),
                           selected=c(
                               "weight.change", "calories.in.mav", 
                               "steps.mav")
        )
    ),
    
    # Plot container.
    mainPanel(
        plotOutput("pairsPlot", height=1200, width=1200)
    )
  )
))
