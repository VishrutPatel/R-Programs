######
# Adaboost Classifier
# Student Name: Vishrut Patel 
# Student Unity ID: vnpatel
######

# Do not clear your workspace
install.packages("mlbench")
require(mlbench)
require(rpart) # for decision stump
require(caret)

# set seed to ensure reproducibility
set.seed(100)

# calculate the alpha value using epsilon
# params:
# Input: 
# epsilon: value from calculate_epsilon (or error, line 7 in algorithm 5.7 from Textbook)
# output: alpha value (single value) (from Line 12 in algorithm 5.7 from Textbook)
###
calculate_alpha <- function(epsilon){
  return((0.5)*log((1-epsilon)/epsilon))
}

print(calculate_alpha(0.25))
# calculate the epsilon value  
# input:
# weights: weights generated at the end of the previous iteration
# y_true: actual labels (ground truth)
# y_pred: predicted labels (from your newly generated decision stump)
# n_elements: number of elements in y_true or y_pred
# output:
# just the epsilon or error value (line 7 in algorithm 5.7 from Textbook)
###
calculate_epsilon <- function(weights, y_true, y_pred, n_elements){
  interEpsilon = 0;
  for(i in 1:n_elements){
    if(y_true[i] == y_pred[i]){
      interEpsilon = interEpsilon + weights[i];  
    }
  }
  return(interEpsilon/n_elements);
}


# Calculate the weights using equation 5.69 from the textbook 
# Input:
# old_weights: weights from previous iteration
# alpha: current alpha value from Line 12 in algorithm 5.7 in the textbook
# y_true: actual class labels
# y_pred: predicted class labels
# n_elements: number of values in y_true or y_pred
# Output:
# a vector of size n_elements containing updated weights
###
calculate_weights <- function(old_weights, alpha, y_true, y_pred, n_elements){
  updated_weights <- c();
  for(i in 1:n_elements){
    temp_weight = 0;
    if(y_true[i] == y_pred[i]){
      temp_weight = (old_weights[i])*exp(-alpha);   
    }else{
      temp_weight = (old_weights[i])*exp(alpha);
    }
    updated_weights <- c(updated_weights,temp_weight);
  }
  sum = 0;
  for(i in 1:length(updated_weights)){
    sum = sum + updated_weights[i];
  }
  for(i in 1:length(updated_weights)){
    updated_weights[i] = updated_weights[i]/sum;
  }
  return(updated_weights)
}

# implement myadaboost - simple adaboost classification
# use the 'rpart' method from 'rpart' package to create a decision stump 
# Think about what parameters you need to set in the rpart method so that it generates only a decision stump, not a decision tree
# Input: 
# train: training dataset (attributes + class label)
# k: number of iterations of adaboost
# n_elements: number of elements in 'train'
# Output:
# a vector of predicted values for 'train' after all the iterations of adaboost are completed
###

myadaboost <- function(train, k, n_elements){
  status = TRUE;
  PredictedValues <- c();
  FinalPredList <- matrix(list(),nrow = n_elements,ncol = k);
  #print(train);
  alphaList <- c();
  weights <- c();
  #print(n_elements);
  for(i in 1:n_elements){
    temp_weight = 1/n_elements;
    weights <- c(weights,temp_weight)
  }
  for(i in 1:k){
    if(status == FALSE){
      i=i-1;
      status = TRUE;
    }
    passData = train[sample(nrow(train), n_elements, replace = TRUE, prob=weights),];
    DecisionStump = rpart(Label~V3+V4+V5+V6+V7+V8+V9+V10+V11+V12+V13+V14+V15+V16+V17+V18+V19+V20+V21+V22+V23+V24+V25+V26+V27+V28+V29+V30+V31+V32+V33+V34, data=passData, method="class",control = list(maxdepth = 1) );
    PredictedValues <- predict(DecisionStump,train[,0:32],type="class")
    result <- dim(PredictedValues);
    if(i==1){
      print(PredictedValues);  
    }
    for(j in 1:n_elements){
      FinalPredList[[j,i]] <- result[j];
      if(j==1){
        print(FinalPredList[[j,i]])
        #print(PredictedValues[j]);
      }
    }
    eps <- calculate_epsilon(weights,train[,33],PredictedValues,length(train))
    if(eps>0.5){
      weights <- c();
      for(i in 1:n_elements){
        temp_weight = 1/n_elements;
        weights <- c(weights,temp_weight)
      }
      status = FALSE;
    }
    alpha <- calculate_alpha(eps);
    alphaList <- c(alphaList,alpha);
    weights <- calculate_weights(weights,alpha,train[,33],PredictedValues,n_elements);
  }
  #print(alphaList);
  #print(FinalPredList);
  return(PredictedValues);
}


# Code has already been provided here to preprocess the data and then call the adaboost function
# Implement the functions marked with ### before this line
data("Ionosphere")
Ionosphere <- Ionosphere[,-c(1,2)]
# lets convert the class labels into format we are familiar with in class
# -1 for bad, 1 for good (create a column named 'Label' which will serve as class variable)
Ionosphere$Label[Ionosphere$Class == "good"] = 1
Ionosphere$Label[Ionosphere$Class == "bad"] = -1
# remove unnecessary columns
Ionosphere <- Ionosphere[,-(ncol(Ionosphere)-1)]
# class variable
cl <- Ionosphere$Label
# train and predict on training data using adaboost
predictions <- myadaboost(Ionosphere, 5, nrow(Ionosphere))
# generate confusion matrix
print(table(cl, predictions))

