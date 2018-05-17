######
# Bisecting K-Means and KNN Classifier
# Rename this file before submitting 
#####

require(RColorBrewer)
require(class)
require(caret)

# set seed to ensure consistent results
set.seed(100)


################################################
#   TA defined functions
#   Code has already been provided for you - you don't need to modify this 
###############################################
# Plot clustering result
plot_clustering_result <- function(data.df, result, title, k){
  # Plot using two columns in the data
  plot(data.df[, c(2,4)], col = brewer.pal(k, "Set1")[result[[1]]], pch = '.',
       cex = 3, main = title)
}

################################################
# GRADED FUNCTIONS
# Write your code using the given function definitions
# Input and output types are defined for each function
###############################################

# Implement bisecting k means.
# Input:
# data.df: data frame loaded using load_data() function
# iter.max: Max. number of trials for kmeans, as per Algorithm 8.2 in textbook. 
# You are allowed to use the pre-defined kmeans() function.
# k: Number of clusters to find in bisecting k-means

# Output:
# Your output/function return value will be a list containing 2 elements
# first element of the list is a vector containing cluster assignments (i.e., values 1 to k assigned to each data point)
# second element of the list is a vector containing SSE of each cluster
# Additional Information:
# When identifying which cluster to split, choose the one with maximum SSE
# When performing kmeans, pick two random points the cluster with largest SSE as centers at every iteration. 
# Ensure that the two centers being randomly picked are not the same.
# terminating condition: when k clusters have been found
# bisecting k means 
bkm <- function(data.df, iter.max, k){
  # Hint: Remember, the first column is of type ID. 
  # Don't use this column while clustering
  
  
  #store relevant data after removing ID
  intermediateStore <- data.df[,c('Sepal.Length','Sepal.Width','Petal.Length', 'Petal.Width')]
  #initialize squared error frame for storing errors of each cluster to zero
  SquaredError <- rep(0, times=k)
  #initialize to store 2 initial vectors which are split using kmeans
  kmeansReturn <- kmeans(intermediateStore, 2, algorithm = c("Lloyd"))
  #store intermediate clusters in separate frame to pass the selected cluster point for splitting
  intermediateStore$cluster <- kmeansReturn$cluster
  #initialize 
  iterator <- 2
  separatedClusterA <- intermediateStore[intermediateStore$cluster == 1, ]
  separatedClusterB <- intermediateStore[intermediateStore$cluster == 2, ]
  SquaredError[1] <- kmeansReturn$withinss[1]
  SquaredError[2] <- kmeansReturn$withinss[2]
  
  while (iterator < k) {
    splitSelector <- which.max(SquaredError)
    splitPointsVector <- intermediateStore[intermediateStore$cluster == splitSelector, ]
    intermediateStore = intermediateStore[intermediateStore$cluster != splitSelector, ]
    kmeansReturn = kmeans(splitPointsVector, 2, iter.max = iter.max, algorithm = c("Lloyd"))
    innerIterator <- 0
    for (innerIterator in 1:length(kmeansReturn$cluster)) {
      if(kmeansReturn$cluster[innerIterator]==1)
        kmeansReturn$cluster[innerIterator] = splitSelector
      else
        kmeansReturn$cluster[innerIterator] = iterator+1
    }
    splitPointsVector$cluster = kmeansReturn$cluster
    SquaredError[splitSelector] = kmeansReturn$withinss[1]
    SquaredError[iterator+1] = kmeansReturn$withinss[2]
    separatedClusterA = splitPointsVector[splitPointsVector$cluster == splitSelector, ]
    separatedClusterB = splitPointsVector[splitPointsVector$cluster == iterator+1, ]
    splitPointsVector = rbind(separatedClusterA, separatedClusterB)
    intermediateStore = rbind(intermediateStore, splitPointsVector)
    iterator = iterator + 1
  }
  intermediateStore$index = as.numeric(row.names(intermediateStore))
  intermediateStore = intermediateStore[order(intermediateStore$index), ]
  finalClusters <- list(intermediateStore$cluster, SquaredError)
  print(sum(SquaredError))
  return(finalClusters)
}

# Write code for comparing kmeans with result from bisecting kmeans here - Part b
# Input:
# data.df:  Dataset used for kmeans/bisecting kmeans clustering 
# Result: Variable of type list, obtained on running bkm() function
# k : k value for k-means
# km_centers: ID values of centers for KMeans

#Returns:
# Nothing, just print the observations requested

kmeans_comparison <- function(data.df, result, k, km_centers){
    # First, run KMeans using km_centers and k. 
    # Compare outcomes of kmeans with bisecting kmeans in terms of:
    # 1. Overall SSE
    # 2. Plot the clusters and compare the size and shape of clusters generated
    # 3. Using the plot, also verify (visually) if points are being assigned to different clusters
  getCenterPointsData <- data.df[km_centers, ]
  clusterResultForKmeans <- kmeans(data.df, centers = getCenterPointsData, algorithm = c("Lloyd"))
  print(clusterResultForKmeans$withinss)
  getClusters <- list(clusterResultForKmeans$cluster)
  plot_clustering_result(data.df, getClusters, "KMeans Clusters", k)
  plot_clustering_result(data.df, result, "Bisecting KMeans Clusters", k)    
}

# Write code for KNN algorithm
# implement my_knn with euclidean distance, majority vote and 
# randomly resolving ties
# you are NOT allowed to use the built-in knn function or the dist() function
# (i.e., implement the K Nearest Neighbors, also implement a function for euclidean distance calculation)

# Input: 
# train: training data frame
# test: test data frame
# cl: class labels for training data
# k: 'k' value in KNN

# Output:
# A vector of class labels. return variable should be of type factor
my_knn <- function(train, test, cl, k)
{
  classPred = c()
  for(i in 1:length(test[,1])){
    distNode <- c()
    CLable <- c()
    setosa <- 0
    versicolor <- 0
    virginica <- 0
    for(j in 1:length(train[,1])){
      distNode <- c(distNode, euclidean(train[j,],test[i,]))
      CLable <- c(CLable, cl[j])
    }
    resultMat <- data.frame(CLable, distNode)
    #print(resultMat)
    resultMat <- resultMat[order(resultMat$distNode),]
    resultMat <- resultMat[1:k,]
    #print(resultMat[k,"CLable"]);
    for(k in 1:length(resultMat[,1])){
      if(resultMat[k,"CLable"] == 1){
        setosa = setosa + 1
      }
      else if((resultMat[k,"CLable"]) == 2){
        versicolor = versicolor + 1
      }
      else if((resultMat[k,"CLable"]) == 3){
        virginica = virginica + 1  
      }
    }
    if(setosa >= versicolor && setosa >= virginica){
      classPred <- c(classPred,"setosa")
    }
    else if(versicolor >= setosa && versicolor >= virginica){
      classPred <- c(classPred,"versicolor")
    }
    else if(virginica >= setosa && virginica >= versicolor){
      classPred <- c(classPred,"virginica") 
    }
  }
  #print(classPred)
  return(classPred)
}

euclidean <- function(x,y){
  sum = 0
  for(i in c(1:(length(x)-1))){
    sum = sum + (y[[i]]-x[[i]])^2
  }
  result = sqrt(sum)
  return(result)
}
# Generate accuracy measures for your KNN classification
# Input:
# test_cl: actual class labels for test data
# knn_result: predicted class labels for test data

# Output:
# A vector of size 4 in the following order: 
# (overall accuracy, precision for the class 'setosa', recall for the class 'setosa', F-measure for the class 'setosa')

# DONOT use predefined libraries to calculate the accuracy measures
# Implement the formulae by generating the confusion matrix using the table() function
my_knn_accuracy <- function(test_cl, knn_result){
  correct = 0
  precisions = 0
  recalls = 0
  corsen = 0
  result = c()
  for(i in 1:length(test_cl)){
    #print(test_cl[i])
    print(knn_result[i])
    if(test_cl[i]==knn_result[i]){
      correct = correct + 1
    }
    if(as.numeric(test_cl[i])!=1 & knn_result[i]=="setosa")
    {
      precisions = precisions + 1
    }
    if(as.numeric(test_cl[i])==1 & knn_result[i]!="setosa")
    {
      recalls = recalls + 1
    }
    if(as.numeric(test_cl[i])==1 & knn_result[i]=="setosa")
    {
      corsen = corsen + 1
    }
  }
  prec = corsen/(corsen+precisions)
  #print(prec)
  rec = corsen/(corsen+recalls)
  #print(rec)
  fmeasure = (2*corsen)/((2*corsen)+precisions+recalls)
  #print(fmeasure)
  accu = correct/length(test_cl) * 100
  result <- c(result,accu)
  result <- c(result,prec)
  result <- c(result,rec)
  result <- c(result,fmeasure)
  return(result)
}
