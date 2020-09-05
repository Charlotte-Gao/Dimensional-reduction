shinyServer(function(input, output, session) {
  output$Structure <- renderPrint({
    str(mtcars)
  })
  output$rawdata <- DT::renderDataTable({
    DT::datatable(data = mtcars)
  })
  output$model = renderPrint({
    Scores=pls::plsr(mpg ~ ., data = numerical , scale = input$Scalepls )$scores
    Scores
  })
  output$corrgram2=renderPlot({
    Scores=pls::plsr(mpg ~ ., data = numerical , scale = input$Scalepls )$scores
    suppressPackageStartupMessages( library(corrgram) )
    corrgram::corrgram( x = cor(Scores), upper.panel = panel.cor)
  })
  output$scores=renderPrint({
    Scores=pls::plsr(mpg ~ ., data = numerical , scale = input$Scalepls )$scores
    print( diag(var(Scores)) )
  })
  output$pls <- renderPlot({
    plot(Scores[, input$Variables1] ~ Scores[, input$Variables2])
  })
  output$corrgram=renderPlot
  output$modelPCA=renderPrint({
    modelpca <- prcomp(~ . -mpg, data = numerical, scale. = input$Scalepca)
    predict(modelpca, newdata = numerical)
  })
  output$biplot=renderPlot({
    biplot(modelpca,var.axes = input$displaypoints)
  })
  output$pca <- renderPlot({
    plot(PCA[,c(input$Variables3,input$Variables4)])
  })
  output$pcascree <- renderPlot({
    screeplot(modelpca, type = "lines", main = "PCA Scree plot")
  })
  output$distance<- renderPrint({
    numeircal.dist <- stats::dist(numerical, method = input$Variables5)  # compute distance matrix
    numeircal.dist
  })
  output$cmdscale <- renderPlot({
    numeircal.dist <- stats::dist(numerical, method = input$Variables6)
    data2d <- stats::cmdscale(numeircal.dist, k = 2)
    plot(data2d)
  })
  output$matrix<- renderPrint({
    numerical.dist1 <- stats::dist(numerical, method = input$Variables7)  # compute distance matrix
    numerical.mds1 <- MASS::isoMDS(numerical.dist1, )
  })
  
  output$point <- renderPlot({
    numerical.dist2 <- stats::dist(numerical, method = input$Variables8)
    numerical.mds2 <- MASS::isoMDS(numerical.dist2, )
    plot(numerical.mds2$points,  type = "n", xlab = "PC1", ylab = "PC2")
    text(numerical.mds2$points, labels = rownames(numerical.mds2$points))
  })
  output$Sammon = renderPrint({
    MASS::sammon(numerical.dist, k = 2)
  })
  output$sammonpoints = renderPlot({
    plot(numerical.sam$points,  type = "n", xlab = "PC1", ylab = "PC2")
    text(numerical.sam$points, labels = rownames(numerical.sam$points))
  })
  output$clustering <- renderPlot({
    kmeans_clust <- kmeans(numerical.sam$points, input$k)  # k-means wihth 3 clusters.
    plot(numerical.sam$points, type = "n", main = "Dimensional Reduction by sammon() and then clustered", xlab = "var 1", ylab = "var 2")
    text(numerical.sam$points, labels = rownames(numerical), col = kmeans_clust$cluster)  # set color using k-means output
  })
  output$solTrainXtrans <- renderPrint({
  str(solTrainXtrans)
  })
  
  output$matplot <- renderPlot({
    
    matplot(solTrainXtrans, type = "l")
  })
  output$CV1 <- renderPrint({
    #oliveoil.pcr <- pls::pcr(sensory ~ chemical, ncomp = 4, data = oliveoil, validation = "CV")
    #summary(oliveoil.pcr)
    training.pcr <- pls::pcr(solubility ~., ncomp = 20, data = training, validation = "CV")
    summary(training.pcr)
  })
  output$validationplot1 <- renderPlot({
    #training.pls <- pls::plsr(solubility ~., ncomp = 20, data = training, validation = "CV")
    training.pcr <- pls::pcr(solubility ~., ncomp = 20, data = training, validation = "CV")
    pls::validationplot(training.pcr, legendpos = "topright")
    validationplot(training.pcr, val.type="RMSEP")
  })
  output$CV2=renderPrint({
    training.pls <- pls::plsr(solubility ~., ncomp = 20, data = training, validation = "CV")
    summary(training.pls)
  })
  output$validationplot2 <- renderPlot({
    training.pls <- pls::plsr(solubility ~., ncomp = 20, data = training, validation = "CV")
    pls::validationplot(training.pls, legendpos = "topright")
    validationplot(training.pls, val.type="RMSEP")
  })
  stepX <- function(recipe, name) {
    if (name == "step_pca") {
      step_pca(recipe, all_predictors(), num_comp = 12)
    } else if (name == "step_pls") {
      step_pls(recipe, all_predictors(), outcome = "solubility", num_comp = 12)
    }   
  }
  output$Regularising <- renderPlot({
    yarn2 <- data.frame(solubility = solTrainY,training)
    rec <- recipes::recipe(solubility ~ ., data = yarn2) %>%
      stepX(input$Function)
    the_last_model <- caret::train(rec, data = yarn2, method = "glmnet")
    plot(varImp(the_last_model))
    #caret::predictors(the_last_model)
  })
  output$Components=renderPrint({
    yarn2 <- data.frame(solubility = solTrainY,training)
    rec <- recipes::recipe(solubility ~ ., data = yarn2) %>%
      stepX(input$Function)
    the_last_model <- caret::train(rec, data = yarn2, method = "glmnet")
    caret::predictors(the_last_model)
  })
})


#runApp(appDir = ".", display.mode = "showcase")
