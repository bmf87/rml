
# ---------------------  << UI >> ------------------------

ui <- fluidPage(
  # Include custom CSS
  tags$head(
    tags$style(HTML('
                    h1.bslib-page-title { font-weight: bold; }
              '))
  ),
  #theme = bslib::bs_theme(bootswatch = "darkly"),  
  useShinyjs(),
  page_sidebar(
    title = "Diabetes Analysis",  
    sidebar = sidebar(
        tags$div(HTML("Health Inputs:"), 
                  style = "font-weight: bold; font-size: 1.25em;"),
        hr(),
        sliderInput(inputId = "Age",
          "Select Age",
          min = 18,
          max = 80,
          value = 20
        ),
        sliderInput(inputId = "BMI",
          "Select BMI",
          min = 0,
          max = 80,
          value = 25
        ),
        hr(),
        radioButtons(inputId = "HighBP",
          "Blood Pressure:",
          c("Normal", "High"),
          selected = "Normal",
          inline = TRUE
        ),
        radioButtons(inputId = "HighChol",
          "Cholesterol:",
          c("Normal", "High"),
          selected = "Normal",
          inline = TRUE
        ),
        hr(),
        fixedRow(
          column(6, align = "center", offset = 3,
                 actionButton("reset", "Reset")
          )
        ),
      ), # close sidebar
      singleton(tags$head(tags$script(src='utils.js'))),
      mainPanel(
        navset_card_pill(id = "navigation",
          nav_panel(title = "Intro", value = "intro",
                    markdown(
                      glue::glue(.trim = FALSE,
                      "##### **Diabetes Mellitus:** 
                      Diabetes Mellitus (DM) comes from the Greek word *diabetes*, meaning to pass through and the Latin word *mellitus* meaning sweet. 
                      DM refers to a group of diseases that affect how your body uses blood sugar or glucose. While glucose is a source
                      of energy for cells in the human body, for those suffering from diabetes an insufficient amounts of insulin permits excess amounts
                      of glucose in the bloodstream. When not appropriately managed, this can cause serious long-term complications like nerve damage, kidney damage, 
                      heart and blood vessel disease, and even eye and foot damage.
                      
                      ##### **Type 2 Diabetes:**
                      Type 2 diabetes can develop at any age, but it is *very* common in people older than 40. The data set analyzed here shows a strong correlation between age and diabetes. 
                      Almost 40 million people in the United States today have diabetes. 90-95% of those diabetes cases are Type 2. Experts predict worldwide diabetes cases are on the rise and could 
                      increase by 100 million people by 2030. Healthy lifestyle choices can help avert a major health crisis. You will see in the analysis section that age and other health factors like 
                      Body Mass Index (BMI) can drastically increase your chances of developing diabetes.
                      
                      ##### **[Conditional Probability](https://www.britannica.com/science/conditional-probability):**"
                      )
                    ),
                    tags$div(HTML("<a id=\"xtogglePlots\" href=\"javascript:togglePlots('xtogglePlots');\">Hide Plots</a>"),
                             style = "font-weight: bold; font-size: 1.05em;"),
                    tags$div(id = "agePDistribution",
                    fixedRow(
                      column(10, align = "center", plotOutput("dbAgePDistribution"))
                    ),
                    fixedRow(tags$div(
                      HTML("Note: the BRFSS data uses a 13-level age category with 5-year ranges"),
                          style = "font-style: italic; font-weight: bold; font-size: 0.85em;"),
                    )), # close agePDistribution
                    tags$div(id = "BMIPDistribution", 
                    fixedRow(
                      column(10, align = "center", plotOutput("dbBMIPDistribution"))
                    ),
                    fixedRow(tags$div(
                      HTML("Note: A BMI of 30.0 or higher falls within the obseity range"),
                        style = "font-style: italic; font-weight: bold; font-size: 0.85em;"),
                    )), # close BMIPDistribution
                    markdown(
                      glue::glue(
                      "Conditional probability is used when the likelihood of one event is influenced by another event occcuring. It describes the chances that some outcome, say *Y* occurs given some other event *X* 
                      has already occurred. The **conditional probability** of Y given X, denoted P(Y|X) is given by the following formula: **P(Y &cap; X) &#8725; P(X)**. Conditional probability exhibits 
                      a conditional distribution with the target/dependent variable *Y* changing over variable *X*. Results shown here use the 2014 BRFSS data set and depict the target/dependent 
                      variable *y* (diabetes class) increasing over *x* (age and BMI), indicating higher probabilties of developing diabetes as you age and gain weight. This comports with reality and known published statistics. 
                      We can therefore confirm associations exist between age and BMI with the increased risk of diabetes in the population, reject the *null hypothesis* that no relationship exists, and use age and BMI as predictors in the model.
                      
                      ##### **Key Takeaways:** 
                      Based on data collected in this sample (2014 BRFSS), by approximately age-level 9, corresponding to the age range of 61-65, you are approximately 20% likely to develop diabetes. Diabetes rates increase at the onset of 
                      your senior years, when you are likely to have other medical conditions. With a class 2 BMI (35-40), you are approximately 30% likely to develop diabetes. Although not visually depicted here, conditions like high blood pressure and high 
                      cholesterol increase your risk of diabetes and make it harder to keep diabetes under control. All these health factors are used in the machine learning model of the Analysis tab to predict the probability of diabetes."
                      )
                    )
          ),
          nav_panel(title = "Analysis", value = "analysis",
                  fixedRow(
                    column(10, align = "center", tags$div(HTML("Density Plot: Shows actual values &ge; Age & BMI Inputs")), 
                     style = "font-weight: bold; font-size: 1.5em;")
                  ),
                  fixedRow(
                    column(10, align = "left", plotOutput("dbDensityPlot"))
                  ),
                  fixedRow(title = "Header",
                           column(10, align = "center", tags$div(HTML("Diabetes Predictions: via ordinal logistic regression model. For a model overview, please <a id=\"modelInfo\" href=''>click here</a>")),
                           style = "font-weight: bold; font-size: 1.0em;")
                  ),
                  fixedRow(title = "Headers",
                    column(5, align = "center", tags$div(HTML("Health Inputs Used")), 
                      style = "font-weight: bold; font-size: 1.5em;"), 
                    column(5, align = "center", tags$div(HTML("Diabetes Predictions (%)")), 
                      style = "font-weight: bold; font-size: 1.5em;")
                  ),
                  fixedRow(title = "Tables",
                    column(4, align = "center", tableOutput("dbPredictInput")),
                    column(2, align = "center", imageOutput("arrowImage")),
                    column(4, align = "center", tableOutput("dbPredictOutput"))
                  )
          ),
          nav_panel(title = "Data", value = "data",
                    fixedRow(
                      column(10, align = "center", textOutput("dbTableHeader"), 
                             style = "font-weight: bold; font-size: 1.5em;")
                    ),
                    fixedRow(
                      column(10, align = "left", DT::dataTableOutput("dbTable"))
                    )
          ),
          #nav_panel(title = "Summary", tableOutput("dbSummary")),
          nav_panel(title = "About", value = "about", 
            markdown(
              glue::glue(
                "##### **Survey Sample Population:** 
                The data set used for the diabetes analysis was obtained from the 2014 Behavioral Risk Factor Surveillance System (BRFSS). For more information about the 2014 BRFSS, 
                please see [CDC - 2014 BRFSS](https://www.cdc.gov/brfss/annual_data/annual_2014.html). The analysis was conducted using {nrow(dbData)} surveys collected to understand 
                the relationship between lifestyle and diabetes in the US. The final data set was obtained from the [UC Irvine ML Repository](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
                
                ##### **Brief History of the BRFSS:** 
                The BRFSS is a collaborative project between all states in the United States and the Centers for Disease Control (CDC) and Prevention. 
                The BRFSS completes more than 400,000 adult interviews each year. This makes it the largest health survey system in the world. The target
                survey population is noninstitutionalized adults of the age 18 and older.
                
                ##### **Ordinal Logistic Regression:**
                Ordinal logistic regression (OLR) is used when your dependent variable is an ordered categorical variable. OLR models change among the ordered values of the dependent variable as a function of a unit increase in the predictors.
                Logistic regression uses the logit function for a single event as a linear combination of independent variables. OLR uses cummulative events for the log odds computation. OLR can be used in many situations where responses are ordinal, like for example
                with medical conditions, disease scale, and even satisfaction surveys. In this diabetes analaysis, healthy, pre-diabetes, and diabetes are ordered response values. To handle ordinal dependent variables, [polr](https://rdrr.io/cran/MASS/man/polr.html) or 
                *proportional odds logistic regression* from the MASS package was used. 
                
                ###### **Predictors:**
                The BRFSS data contained 21 variables. ***Most*** were evaluated as model predictors. Predictors used in the model include:
                
                - Age
                - BMI
                - HighBP
                - HighChol
                
                ###### **Model Evaluation:**
                Evaluating a Confusion Matrix produced from the test data demonstrated the model has an 8% missclassification rate.  It is important to note that the model was rarely able to produce a proper classification for Pre-Diabetes. This is mainly due to an inadequate 
                representation of Pre-Diabetes subjects in the data set. Pre-Diabetes observations counted for &lt; 2% of the total data set. Future analysis will look to augment this data set with additional years of BRFSS data.
                Analyzing the assumptions of proportional odds by comparing with a baseline (multinomial) logit model yielded a small p-value. The p-value is an outcome of a [logLik](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/logLik) calculation between the models
                to determine the difference in deviance statistics: *D = -2loglik(&Beta;)*.  The result indicated that the proportional odds model did *not* fit the data differently.
                The model was kept as is with the goal of future enhancements in mind. We will now look at estimates for two intercepts and the confidence intervals (CI) of the predictors using table output at the bottom of the page.
                
                **Intercepts (estimate):** the intercepts determine the boundaries. Healthy|Pre-Diabetes corresponds to logit[P(Y &le; 1)]. It translates to the log of odds of being healthy versus pre-diabetic or diabetic. Similarly, the intercept Pre-Diabetes|Diabetes
                corresponds to logit[P(Y &le; 2)]. Interpreted as the log of odds of being healthy or pre-diabetic versus diabetic. 
                
                **Estimated Model -** using Proportional Odds Model: 
                *Intercepts from the table below are exponenciated*
                  - logit(P(Y &le; 1)) => ln(455.09) => 6.1205 - (1.16 * Age) - (2.67 * HighBPYes) - (2.03 * HighCholYes) - (1.08 * BMI)   
                  - logit(P(Y &le; 2)) => ln(538.12) => 6.2881 - (1.16 * Age) - (2.67 * HighBPYes) - (2.03 * HighCholYes) - (1.08 * BMI)   
                
                **Confidence Intervals (conf.low, conf.high):** There is no significance test by default. Calculated p-values were also considered and analyzed, all variables < 0.05 and statistically
                significant at 95% CI. When confidence intervals do not cross 0, the variable is considered statistically significant. For example, using the data below, for a one-unit increase in HighBP (going from 0/No to 1/yes) expect a 0.16 increase in the value 
                of DiabeticState on the [log odds](https://www.statisticshowto.com/log-odds/) scale, log odds equals ln(OR), where OR is the odds ratio.
                "
              )
            ), # end markdown
            fixedRow(
              column(10, align = "center", tableOutput("dbFitxOutput"),
                     style = "font-weight: bold; font-size: 0.95em;")
            )
          )
        ), # Close navset_card_pill
    width = 10) # close mainPanel
  ) # close page_sidebar
) # close fluid_page




#shinyApp(ui = ui, server = server)


