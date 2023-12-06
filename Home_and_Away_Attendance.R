library(shiny)
library(tidyverse)
library(reshape2)
attendance <- read.csv("attendance.csv")
games <- read.csv("games.csv")
standings <- read.csv("standings.csv")
attendance2 <- attendance %>% unite(team, c(team, team_name), sep = " ", remove = FALSE) %>% select(-team_name)
games2 <- games %>% select(-tie, -day, -date, -time, -away_team, -winner, -home_team_name, -home_team_city, -away_team_name, -away_team_city) %>% rename("team" = "home_team")
standings2 <- standings %>% unite(team, c(team, team_name), sep = " ", remove = FALSE) %>% select(-sb_winner, -team_name)
as <- merge(attendance2, standings2, by = c("team", "year"))

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Team Statistics Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("team", "Select Team", choices = unique(as$team)),
      sliderInput("year_range", "Select Year Range",
                  min = min(as$year), max = max(as$year),
                  value = c(min(as$year), max(as$year)), step = 1),
      selectInput("stat_input", "Select Stat", choices = colnames(as)[-c(1:3)])
    ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Plots", plotOutput("boxplot"), plotOutput("bar_chart"), plotOutput("scatterplot")),
        tabPanel("Documentation", 
        HTML("<h1>Instructions</h1>
<p>
The following are instructions of how to use the app. First, pick an NFL team of interest. Then select a year range from 2000 to 2019. Then select a team statistic that you would find interest in seeing its relation to wins and total attendance for the year. Then the graphs can be viewed and interpreted on the right side of the page. Documentation is found on this page.
</p>
<h1>Introduction</h1>
<p>
This app uses the nfl-stadium-attendance-dataset, which can be downloaded from Kaggle.com. This dataset contains three csv files: attendance.csv, standings.csv, and games.csv. However, only the attendance and games files were utilized for this app. Both data frames were reassigned a shorter name in order to make it easier to call each dataset. The respective new names are: attendance and standings.
</p>
<p>
The attendance dataset contains 10,846 observations and eight variables: team, team_name, year, total, home, away, week, and weekly_attendance. The team variable refers to the City of the football team, while team_name referes to the name of the football organization. year is the season year. total is the total attendance across the 17 week season for the team where there is no game one week for each team. Each NFL team gets one bye week a season, which is a week where the that team does not play a game. home is the total home attendance for the year and away is the total away attendance recorded for the season. week refers to the week number of the season, i.e, week 5 is recorded as 5 in the table. Lastly, the weekly attendance refers to the average weekly attendance.
</p>
<p>
The standings dataset is comprised of 638 observations and fifteen variables, which are: team, team_name, year, wins, loss, points_for, points_against, point_differential, margin_of_victory, strength_of_schedule, simple_rating, offensive_ranking, defensive_ranking, playoffs, and sb_winner. The team, team_name, and year are the same variables as in the attendance dataset. Wins is the number of games won and loss is the amount of games lost by a team in a season. Both columns range from a minimum of zero to a maximum of sixteen, but must add to be sixteen. points_for is the number of points scored by a team, whereas points_against is the number of points a team allowed the opposing team. margin_of_victory is a score given to a team indicating how much that team won or lost by. The margin_of_victory is calculated by taking the points scored by a team and subtracting the number of poins allowed, then taking this calculation and dividing it by the number of games played in the season. The resulting score is either a positive or negative number with a positive score indicating a winning record and a negative score indicating a lossing record. strength_of_schedule is the average quality of opponents as measured by the simple rating system. simple_rating refers to the team quality relative to average (0.0) as measured by the simple rating system. strength_of_schedule is calculated by taking the margin_of_victory value and adding the strength_of_schedule. offensive_ranking is the team offense quality relative to (0.0) as measured by the simple rating system. defensive_ranking is the team defense quality relative to (0.0) as measured by the simple rating system. playoffs is a character class indicating whether or not the team made the playoffs. sb_winner indicates whether or not the team won the Superbowl.
</p>
<h1>Motivation</h1>
<p>
The motivation for creating this app was to allow viewers to answer was whether or not a team's record, either winning or lossing, affected that team's yearly attendance. Another objective of the app was to see if any variables led to trends positively or negatively affecting a NFL team's yearly game attendance. The last goal of this app was to give the users freedom to check different variables, for example: margin_of_victory or offensive_ranking, against game attendance. Put differently, are different variable better or worse at predicting a team's attendance. As part of creating this app, another goal was to make sure the app was inclusive. One way the app was designed to be more inclusive was to make it color-blind-friendly. To do so, the app was created using color-bling-friendly palettes. The app was made using viridis, which is designed specifically to help improve the readability of the graphs for viewers with common forms of color blindness and or deficiency. Another objective was to make the app user-friendly. In order to do this, a slider was used for selecting the exact date range for the year and a drop-down menu was created making it easy for users to select a specific variable.
</p>
<h1>Explanation</h1>
<p>
For the app, the input was kept as simple as possible. This allows for more moving parts as far as the visualizations go. Directions on how to use the app were already given in the instructions, but this section will explain why these choices were made. The question of interest is does the success of a team have an affect on the weekly attendance for that team. The app allows the user to make these assessments by showing a bar chart with the wins and losses of the selected team for each year. Then directly above this graph is a boxplot that allows the user to view the range of attendance numbers along with the average weekly attendance number for each year as specified by the line within the boxplot. This allows the user to directly link success in win totals to the attendance numbers for each year. Additionally, the last graph allows the user to dive further into the data by viewing a statistic such as margin of victory, offensive rating, or strength of schedule to help understand what might have affected that team's performance. This app allows for the user to answer the question and also allows for further understanding of team's success. As it will be seen, the findings from the visualizations will go much further than the original question.
</p>
<h1>Conclusions</h1>
<p>
There is so much to explore with these visualizations due to the amount of NFL teams, years, and vast array of statistics. However, only a few examples will be looked at and analyzed. The first team that pops up no matter what is the Arizona Cardinals. Immediately, your eye is drawn to the disparity in weekly attendance before 2006. After looking at the win totals there is not anything special or different in win totals from those years to explain the disparity. That leads to the question, well why are those year's attendance totals so much lower than the rest? And after a quick search of Arizona's stadium history, you will find the Cardinals moved into their new home stadium, State Farm Field, in 2006, leading to an increase in attendance numbers due to the increase in capacity and fan excitment. 
</p>
<p>
Now what about a team we know was successful over these years? Like the New England Patriots. The Patriots were known for being a winning organization in the 2000s and 2010s. After selecting them and looking around, we notice in 2007 they didn't lose a game. This lead to their weekly attendance numbers increasing slightly the next year, however, they were successful before so there wasn't much variation for them. The third graph's use of the stat selected can help us understand why they were successful. It can be seen that defensive ranking, offensive ranking, and points for were all prevelant to their win total. There were plenty of teams whose weekly attendance was affected due to a poor season. Take the Miami Dolphins for example who went 1-15 in 2007. The next year their attendance numbers fell even though they finished 11-5; a successful year. Statistical analysis should be done to determine if there was statistical evidence attendance dipped from 2007 to 2008, and should be conducted before any conclusions are made on the affect of win total on weekly attendance the following year. However, visually, there is a decrease. There are many other teams out there with the team story, they have a really bad or really good year, and the year after's attendance numbers are affected no matter the success of the current year. Some examples of these are the Lions and Chiefs who had bad years and their attendance was affected the year after. 
</p>
<p>
The Steelers are also an interesting team to look at. They had a long string of seasons where they did not finish below .500. It can be seen that this winning stability also brought stability to the weekly attendance numbers. There are plenty of conclusions and questions that can be drawn/proposed from looking at these visualizations, but inevitibly the visualization does a good job of allowing the user to explore how the success of a team impacts their attendance numbers.
</p>
<h1>Citations</h1>
<p>
Kaggle Citation:
Kapadnis, Sujay (Contributer). (2023). NFL Stadium Attendance Dataset (Version 1). Retrieved from https://www.kaggle.com/datasets/sujaykapadnis/nfl-stadium-attendance-dataset 

Data Source:
https://www.pro-football-reference.com/years.htm
</p>
"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on user inputs
  filtered_data <- reactive({
    as %>%
      filter(team == input$team,
             between(year, input$year_range[1], input$year_range[2]))
  })
  
  # Render boxplot
  output$boxplot <- renderPlot({
    ggplot(filtered_data(), aes(x = factor(year), y = weekly_attendance)) +
      geom_boxplot() +
      labs(x = "Year", y = "Weekly Attendance", title = "Boxplots of Weekly Attendance by Year") +
      theme_minimal()
  })
  
  # Render bar chart
  output$bar_chart <- renderPlot({
    # Reshape the data to have separate columns for wins and losses
    bar_data <- filtered_data() %>%
      group_by(year) %>%
      summarize(wins = wins, loss = loss)
    
    # Melt the data to long format for plotting
    bar_data_long <- melt(bar_data, id.vars = "year")
    
    # Plotting
    ggplot(bar_data_long, aes(x = factor(year), y = value, fill = variable)) +
      geom_col(position = "dodge") +
      labs(x = "Year", y = "Count", title = "Wins and Losses by Year", fill = "Outcome") +
      scale_fill_manual(values = c("wins" = "darkviolet", "loss" = "lightblue"),
                        labels = c("Wins", "Loss")) +
      theme_minimal()
  })
  
  # Render scatterplot
  output$scatterplot <- renderPlot({
    ggplot(filtered_data(), aes(x = wins, y = total, color = .data[[input$stat_input]])) +
      geom_point() +
      labs(x = "Wins", y = "Total Attendance for Year", title = "Wins by Year Total Attendance", color = input$stat_input) +
      scale_color_viridis_c() +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)