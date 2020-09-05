shinyUI(
  fluidPage(
    useShinyjs(),
    titlePanel("Assignment2-Meng Gao"),
    tabsetPanel(
      #img(src="download.jpeg "),height=100,width=160)),
      tabPanel("Raw data & Structure",
               tabsetPanel(
                 tabPanel("Raw data",
                          DT::dataTableOutput(outputId = "rawdata")
               ),
               tabPanel("Structure",
               verbatimTextOutput(outputId = "Structure")
                          ))),
      tabPanel("PLS",
               tabsetPanel(
                 tabPanel("Model", 
                          h3("We assume mpg is the outcome variable. The following 'Copm n' columns go in descending significance. "),
                          checkboxInput("Scalepls", "Scale", FALSE),
                          verbatimTextOutput("model")
                 ),
                 tabPanel("Corrgram",
                          h3("Note: This is the output of scaled data  if you choose Scale in the previous page.Now we confirm these latent variables (also called “scores”) are uncorrelated."),
                          plotOutput(outputId="corrgram2"),
                          h3('We can also confirm that the latent variables  have descending variances.'),
                          
                          verbatimTextOutput("scores")
                          
                 ),
                 tabPanel("Plot",
                          h3("Note: This is the output of scaled data  if you choose Scale in the previous page. "),
                          selectInput("Variables1", label = "Y axis", choices = choices1, multiple = FALSE, selected = choices1[1]),
                          selectInput("Variables2", label = "X axis", choices = choices1, multiple = FALSE, selected = choices1[2]),
                          plotOutput(outputId="pls"))
               )
      ),
      tabPanel("PCA",
               tabsetPanel(
               tabPanel("Model PCA",
                        h3('Suppose, we do have an outcome variable then we must resort to unsupervised dimensional reduction. PCA can be used.'),
                        checkboxInput("Scalepca", "Scale", FALSE),
                          verbatimTextOutput("modelPCA")
               ),
               tabPanel("2d Plot",
                        h3("Note: This is the output of scaled data  if you choose Scale in the previous page. "),
                        selectInput("Variables3", label = "Y axis", choices = choices2, multiple = FALSE, selected = choices2[1]),
                        selectInput("Variables4", label = "X axis", choices = choices2, multiple = FALSE, selected = choices2[2]),
                        h3('A PCA plot shows clusters of samples based on their similarity.'),
                        plotOutput(outputId="pca")),
               tabPanel("BI Plot",
                        checkboxInput("displaypoints", label = "Display arrows", value = TRUE),
                        h3('A BI plot allows us to read PCA scores and find out how strongly each characteristic (vector) influence the principal components.As the other columns are less important, I will take only the first 2 columns.'),
                        plotOutput(outputId="biplot")
               ),
               tabPanel("PCA Scree plot",
                        h3('A Scree plot can be used to check whether PCA works well. It shows how much variation each PC captures from the data. In this plot, we can say just PC 1,2, and 3 are enough to describe the data.'),
                        plotOutput(outputId="pcascree")
               )
               )),
      tabPanel("Scaling",
      tabsetPanel(
        tabPanel('What does MDS do?',
                 h3('MDS(Multi-dimensional scaling) finds an embedding  that preserves the distances as closely as possible.')
                 ),
      tabPanel("Classical Multi-dimensional scaling",
               tabsetPanel(
                 tabPanel("Distance Matrix",
                          selectInput("Variables5", label = "distance method", choices = choices3, multiple = FALSE, selected = choices3[1]),
                          verbatimTextOutput("distance")
                 ),
                 tabPanel("Plot", 
                          selectInput("Variables6", label = "distance method", choices = choices3, multiple = FALSE, selected = choices3[1]),
                          plotOutput(outputId ="cmdscale")
                          #wordcloud2Output("Cloud")
                 )
               )
      ),
      tabPanel("Non-metric Multi-dimensional scaling",
               tabsetPanel(
                 tabPanel("Distance Matrix",
                          selectInput("Variables7", label = "distance method", choices = choices3, multiple = FALSE, selected = choices3[1]),
                          verbatimTextOutput("matrix")
                 ),
                 tabPanel("Plot",
                          selectInput("Variables8", label = "distance method", choices = choices3, multiple = FALSE, selected = choices3[1]),
                          #selectizeInput("VariablesD", label = "Show variables:", choices = choicesD, multiple = TRUE, selected = choicesD[1:4]),
                          plotOutput("point")
                 )
               )
      ))),
      tabPanel("Sammon mapping and Clustering",
               tabsetPanel(
                 tabPanel("Sammon",
                          h3('Sammon mapping is also a form of non-metric multidimensional scaling.'),
                          verbatimTextOutput("Sammon")
                 ),
                 tabPanel("View points",
                          h3('This plot is the same as the one under non-metric multidimensional scaling, when distance method is "euclidean".'),
                          #selectizeInput("VariablesD", label = "Show variables:", choices = choicesD, multiple = TRUE, selected = choicesD[1:4]),
                          plotOutput("sammonpoints")
                 ),
                 tabPanel("Clustering",
                          sliderInput("k",
                                      "Number of clusters:",
                                      min = 1,
                                      max = 5,
                                      value = 3),
                            #selectizeInput("VariablesD", label = "Show variables:", choices = choicesD, multiple = TRUE, selected = choicesD[1:4]),
                            plotOutput("clustering")
                 )
               )
               ),
      tabPanel("Wide short datasets",
               tabsetPanel(
                 tabPanel("Structure",
                          verbatimTextOutput("solTrainXtrans")
                 ),
                 tabPanel("Matplot",
                          h3("Matplot displays all of these observations on the same graph."),
                          plotOutput("matplot")),
                 tabPanel("PCR: using CV",
                          verbatimTextOutput("CV1"),
                          h3('This plot shows that after 16ish components there is no further benefit from having more components. This plot is telling us that to model solubility we can compress the data to about 16 predictors. We started with 228 predictors. '),
                          plotOutput("validationplot1")),
                 tabPanel("PLSR: using CV",
                          #selectInput("validation", label = "Validation type", choices = choices5, multiple = FALSE, selected = choices5[1]),
                          verbatimTextOutput("CV2"),
                          h3("Partial Leasts Squares confirms the compression shown by PCA and it achieves the same as PCR with fewer components."),
                          plotOutput("validationplot2"))
               )),
      tabPanel("Caret and Recipes",
               tabsetPanel(
                 tabPanel("Plot",
                        #h4("PLS components"),
                        #checkboxInput("Scale_regularising", "Scale", FALSE),
                        selectInput("Function", label = "Function", choices = choices4, multiple = FALSE, selected = choices4[1]),
                        withSpinner(
                          plotOutput("Regularising")
                        )
                 ),tabPanel("Components",
                            h3("Note: This output is based on the Function you choose in the previous page. In this case, PLS(supervised) approach performs slightly better than PCA(unsupervised), with one fewer component."),
                            verbatimTextOutput("Components")
                            
                 )
               ))
  )
))
