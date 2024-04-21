

# ----------------------  << Server >> -------------------------

server <- function(input, output, session) {
  #
  # Refresh UI inputs
  #
  observeEvent(input$reset, {
    reset("Age")
    reset("BMI")
    reset("HighBP")
    reset("HighChol")
  })
  
  predictData = reactive({
    list = get_data()
    inputs = list$reactives
    
    # Get values for model
    Age = as.integer(inputs["AgeLevel"])
    iAge = inputs["Age"] # standard years
    BMI = as.integer(inputs["BMI"])
    HighBPf = c(inputs["HighBPf"])
    HighCholf = c(inputs["HighCholf"])
    
    # Take 3 random samples
    rsample = testDiabetes[sample(nrow(testDiabetes), 3), ]
    # Set predictors to UI/input values    
    rsample$Age = Age
    rsample$BMI = BMI
    rsample$HighBPf = HighBPf
    rsample$HighCholf = HighCholf
    
    newData = data.frame(iAge, HighBPf, HighCholf, BMI)
    # Friendly Col Names for display
    names(newData)[names(newData) == "iAge"] = "Age"
    names(newData)[names(newData) == "HighBPf"] = "HighBP"
    names(newData)[names(newData) == "HighCholf"] = "HighChol"
    
    predictData = (list(newData = newData,  rsample = rsample))
    
  })
  
  diabetesInputs = reactive({
    predictData = predictData()
    newData = predictData$newData
    #print(head(newData))
    head(newData)
  })
  output$dbPredictInput = renderTable(diabetesInputs())
  
  diabetesOutput = reactive({
    predictData = predictData()
    rsample = predictData$rsample
    #print(head(rsample))
    # Predict
    predicted = predict(fitx, rsample, se.fit = FALSE, "probs")
    head(predicted, 1)
  })
  output$dbPredictOutput = renderTable(diabetesOutput())
  
  output$arrowImage <- renderImage({
    # filename is images/right_arrow_small.png
    filename <- normalizePath(file.path('images/right_arrow_small1.png'))
    
    # Return list of filename and alt text
    list(src = filename,
         alt = " >> ")
    
  }, deleteFile = FALSE)
  
  
  # Disable/Enable UI Inputs 
  observeEvent(input$navigation, {
    if((input$navigation == "intro") || 
       (input$navigation == "about")){
      
      disable("Age")
      disable("BMI")
      disable("HighBP")
      disable("HighChol")
      disable("reset")
    } else if(input$navigation == "analysis"){
      enable("Age")
      enable("BMI")
      enable("HighBP")
      enable("HighChol")
      enable("reset")
    } else if(input$navigation == "data"){
      enable("Age")
      enable("BMI")
      enable("HighBP")
      enable("HighChol")
      enable("reset")
    }
    
  })
  
  
  get_data = reactive({
    # Get UI input
    highBP = input$HighBP
    highChol = input$HighChol
    bmi = input$BMI
    ageLevel = age_level(input$Age)
    # Normal=No; High=Yes
    highBP = if(highBP=='Normal') 'No' else 'Yes'
    highChol = if(highChol=='Normal') 'No' else 'Yes'
    inputs = c("Age"=input$Age, "AgeLevel"=ageLevel, "HighBPf"=highBP, "HighCholf"=highChol, "BMI"=bmi)
    
    #
    # Subset Case Study DFs based on UI
    #
    # Subset: from entire sample population
    dtDF = subset(dbData, dbData$HighBPf==highBP & dbData$HighCholf==highChol &
                    dbData$BMI >= bmi & dbData$Age >= ageLevel, 
                  select=c(Diabetes_012f, Age, AgeGroup, HighBPf, HighCholf, BMI, Smoker, 
                           Stroke, HeartDiseaseorAttack, PhysActivity, AnyHealthcare, GenHlth, DiffWalk))
    
  
    # R doesn't allow multiple return values!
    return (list(datatable = dtDF, reactives = inputs))
  })
  
  #
  # DISPLAY Age over Diabetes Density Plot
  #
  output$dbDensityPlot = renderPlot({
    list = get_data()
    histDF = list$datatable
    
    # Plot actual counts of Healhty, Pre-diabetes, Diabetes over independent var Age
    ggplot(histDF, aes(x = Age, y = after_stat(count), fill = Diabetes_012f)) +
      geom_density(alpha = 0.75, kernel = "cosine") +
      labs(title = "Diabetes over Age", x = "Age Range", y = "Total") +
      scale_fill_manual(values=c("#82E0AA", "#F1C40F", "#F5B7B1")) +
      scale_x_discrete(limits = c(
        '18-24', '25-30', '31-35', '36-40', '41-45', '46-50', 
        '51-55', '56-60', '61-65', '66-70', '71-75', '76-80',
        '80+')
      ) +
      #scale_x_discrete("Age Group", labels = histDF$AgeGroup) +
      theme(plot.title = element_text(size = 16, face = "bold", hjust=0.5),
            legend.position = "bottom",
            plot.margin = unit(c(1, 1, 5, 1), "lines"),
            axis.title.x = element_text(size= 12, face = "bold"),
            axis.title.y = element_text(size = 12, face = "bold"))
  })
  
  #
  # Conditional Probability Distribution P(y|x) of target var y over independent var x (Age)
  # Results more reliable for high-density regions of x 
  # Observe: ~20% in age group 10-13 have diabetes 
  #
  output$dbAgePDistribution = renderPlot({
    list = get_data()
    histDF = list$datatable
    
    cdplot(factor(Diabetes_012f) ~ Age, data=dbData, 
           main = "Estimated Diabeties Probability", xlab = "Age Level", 
           ylab = "Diabetes Class",
           yaxlabels = c("Healthy", "Pre", "Diabetes"))
    
  })
  
  #
  # Conditional Probability Distribution P(y|x) of target var y over independent var x (BMI)
  # Results more reliable for high-density regions of x 
  # Observe: ~20% in age group 10-13 have diabetes 
  #
  output$dbBMIPDistribution = renderPlot({
    list = get_data()
    histDF = list$datatable
    
    cdplot(factor(Diabetes_012) ~ BMI, data=dbData, 
           main = "Estimated Diabeties Probability", xlab = "BMI", 
           ylab = "Diabetes Class",
           yaxlabels = c("Healthy", "Pre", "Diabetes"))
    
  })
  
  #
  # Display Tidy output of polr fitx model
  #
  output$dbFitxOutput = renderTable({
    head(tidyFitx)
  }, digits = 5)
  
  #
  # DISPLAY DataTable of Sample Data
  #
  output$dbTable = DT::renderDataTable({
    list = get_data()
    dtDF = list$datatable
    
    # Friendly Col Names for display
    names(dtDF)[names(dtDF) == "Diabetes_012f"] = "DiabeticState"
    names(dtDF)[names(dtDF) == "Age"] = "AgeLevel"
    names(dtDF)[names(dtDF) == "HighBPf"] = "HighBP"
    names(dtDF)[names(dtDF) == "HighCholf"] = "HighChol"
    
    sampleSz = if(nrow(dtDF)>=100) 100 else nrow(dtDF)
    
    # 100 Random obs or whatever we have
    dbTable = dtDF[sample(1:nrow(dtDF), sampleSz,
                          replace=FALSE),]
    
    output$dbTableHeader = renderText({
      paste("BRFSS Surveys - ", sampleSz, " Samples Available") 
    })
    
    DT::datatable(data = dbTable,
                  options = list(pagelength = 10),
                  rownames = FALSE)
  })
  
}