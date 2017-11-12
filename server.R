#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output) {
   
  # Render the pairs plots.    
  output$pairsPlot <- renderPlot({
    k <- input$k
    predictorNames <- input$predictors
    fitbit <- calories.vs.weightloss(csvData, k, predictorNames)
    if (!is.null(fitbit)) {
        pairs(fitbit, 
              upper.panel=panel.smooth,
              lower.panel=panel.cor, 
              pch=20, cex=2, gap=0,
              main="Correlations and Trends")
    }
  })
  
  
  #' Creates the panels for 'pairs' showing the correlation value.
  #'
  #' @param x X predictor.
  #' @param y Y predictor.
  #' @param digits No of digits to display.
  #' @param prefix Prefix, if any.
  #' @param cex.cor The scaling factor.
  #' @param ... 
  #'
  #' @return The text.
  panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) { 
      usr <- par("usr"); on.exit(par(usr)) 
      par(usr = c(0, 1, 0, 1)) 
      r <- abs(cor(x, y)) 
      txt <- format(c(r, 0.123456789), digits = digits)[1] 
      txt <- paste0(prefix, txt) 
      if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt) 
      text(0.5, 0.5, txt, cex = cex.cor * r) 
  } 
  
  #' Calculate moving average.
  #'
  #' @param x Data values.
  #' @param k Size of the moving window.
  #'
  #' @return The moving averages.
  .mav <- function(x, k) {
      rollmean(x, k, align="left", fill=c(NA, NA, NA))
  }
  
  #' Preprocess data for plotting. Calculates moving averages and imputes 
  #' missing values.
  #'
  #' @param data Fitbit data.
  #' @param k Days of the moving average window.
  #' @param predictors An array of selected predictors.
  #'
  #' @return A data frame containing data for plotting.
  calories.vs.weightloss <- function(data, k=7, predictors) {
      avgSleep <- median(data$minutes.asleep, na.rm=T)
      if (length(predictors) > 1) { 
          result <- 
              mutate(data,
                     sleep = ifelse(is.na(minutes.asleep), avgSleep, minutes.asleep),
                     sleep.mav = .mav(sleep, k),
                     wt = rollmedian(data$weight, 5, fill=c(NA, NA, NA)),
                     weight.change = wt - lag(wt, k-1),
                     calories.in.mav = .mav(calories.in, k),
                     calories.burned.mav = .mav(calories.burned, k),
                     calories.bal.mav = calories.in.mav - calories.burned.mav,
                     carbs.mav = .mav(carbs, k),
                     fat.mav = .mav(fat, k),
                     fiber.mav = .mav(fiber, k),
                     sodium.mav = .mav(sodium, k),
                     sedentary.mav = .mav(minutes.sedentary, k),
                     activity.mav = .mav(activity.calories, k),
                     steps.mav = .mav(steps, k),
                     snacks.mav = .mav(snacks, k),
                     meals.mav = .mav(meals, k),
                     breakfast.mav = .mav(ifelse(is.na(breakfast), 0, breakfast), k),
                     lunch.mav = .mav(ifelse(is.na(lunch), 0, lunch), k),
                     dinner.mav = .mav(ifelse(is.na(dinner), 0, dinner), k),
                     morning.snack.mav = .mav(ifelse(is.na(morning.snack), 0, morning.snack), k),
                     afternoon.snack.mav = .mav(ifelse(is.na(afternoon.snack), 0, afternoon.snack), k),
                     after.dinner.mav = .mav(ifelse(is.na(after.dinner), 0, after.dinner), k),
                     anytime.mav = .mav(ifelse(is.na(anytime), 0, anytime), k)
              ) %>%
              select(predictors) %>%
              na.omit(weight.change)
      } else { 
          result <- NULL
      }
      result
  }  
  
})
