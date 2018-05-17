# R-Programs
Basic Algorithms in Data Mining implemented in R
File 1: Basic Measures of Central Tendency
  Data exploration/Transformation:
  a. Read the ‘iris’ dataset into memory using the data function.
        a. Store the number of rows in the dataset in the variable iris.rows
        b. Store the number of columns in the dataset in the variable iris.cols
        c. Store the names of the columns/attributes in iris.attrs
        d. Extract the column ‘Sepal.Width’ programmatically and store it in the variable
        iris.sw.vec
  b. Write code to identify all values in iris.sw.vec that are >= 3 and <= 4. If you do
        this right, it should take only one line of code. Store the resultant vector in the variable
        iris.sw.vec.subset
  c. Compute the mean for iris.sw.vec. Store this in a variable named iris.sw.mean
  d. Compute the standard deviation for iris.sw.vec and store the result in
        iris.sw.stdDev. Use the following formula to calculate standard deviation, where x
        refers a vector and N is the number of instances in x.
        s.d. = √ N−1
        (x−mean)2
  e. Transform iris.sw.vec using min-max normalization to [0,1] range and store
        the result in iris.sw.mm.vec
  f. Implement z-score normalization on iris.sw.vec and store the result in
        img.sw.zn.vec
  Data Visualization:
  g. (1 point) Generate the plot with the X axis as the column ‘Sepal.Width’ and Y axis as the
  column ‘Sepal.Length’ . Label your axes appropriately and provide a title for your plot.
  Include the code for plotting in your .R file, as well as show this plot in your PDF.
  
File 2: Bisecting KMeans and kNN classifier
#    a) (15 points) implement the bisecting kmeans method. Write your implementation in ‘ bkm’ function provided in the your_unity_id.R file.
    1) Input:
      1) data.df: input data frame using the load_data_bkm() function from utils.R
      2) iter.max: Max. number of iterations (trials) for kmeans, as per Algorithm 8.2. You are
      allowed to use the pre-defined kmeans() function.
      3) k: Number of clusters to find in bisecting k-means
    2) Returns:
      1) Your output/function return value will be a list containing 2 elements
      a) first element of the list is a vector containing cluster assignments (i.e., values 1 to
      k assigned to each data point)
      b) second element of the list is a vector containing SSE of each cluster
    3) What is the terminating condition for bisecting kmeans?
      A: Stop when k clusters have been found
    4) Which KMeans algorithm am I supposed to use?
      A: Use the “Lloyd” algorithm
    5) Do I need to implement SSE calculation?
      A: No need, explore the KMeans function and what its output is
#    b) (5 points) Comparison with kmeans: Write your implementation in ‘ kmeans_comparison ’ function provided in the your_unity_id.R file.
    implementation:
    Now use the same dataset from (a), and using points with ID values (15,16 and 19) as initial
    centers, identify the 3 clusters (use default settings for everything else) and do the following:
    a) Run kmeans clustering using the centers mentioned above
    b) Plot the clustering outcome of KMeans (use Sepal.Length as x-axis, and Petal.Length as
    y-axis)
    c) Compare the the clusters you found here with the clusters you found in (a). Did you
    notice any difference (visually)? Compare in terms of size and shape of the clusters and
    overall SSE. Submit your findings (including the plots for Bisecting KMeans and
    KMeans) in the PDF.
    Function arguments:
    i) Input:
      1) data.df: Dataset used for kmeans/bisecting kmeans clustering
      2) result: Variable of type list, obtained on running bkm() function
      k : k value for k-means
      km_centers : id’s of rows for kmeans
    Returns:
      None
# Q2) (15 points) K Nearest Neighbors Classification
#    i) (15 points) Implementing KNN: my_knn() function implementation:
    In this question, you will implement a simple kNN classifier which uses euclidean distance.
    Write your code in the function my_knn() with:
    i) Input:
      1) train: training data frame (containing columns: "Sepal.Length" "Sepal.Width"
      "Petal.Length" "Petal.Width")
      2) test: test data frame (having same columns as train)
      3) cl: class labels for training data
      4) k: 'k' value in KNN
    ii) Returns:
      1) A vector of class labels. return variable should be of type factor.
   
   
#   ii) (5 points) my_knn_accuracy() function implementation :
    In this question, you will write code to calculate the following accuracy measures:
      (i) overall accuracy,
      (ii) precision for the class 'setosa',
      (iii) recall for the class 'setosa',
      (iv) F-measure for the class 'setosa'
    Please note, you are not allowed to use any pre-defined methods or packages to calculate
    these values. Please implement the formulae. For generating the confusion matrix, you can use
    the table() function.
    Format for my_knn_accuracy():
    i) Input:
      1) test_cl: actual class labels for test data
      2) knn_result: predicted class labels for test data
    ii) Returns:
      1) A vector of size 4 in the following order:
      (overall accuracy, precision for the class 'setosa', recall for the class 'setosa', F-measure for the
      class 'setosa')

# File 4: kNN with cross validation
For this project, you will learn how to use 10-Fold Cross Validation to estimate the optimal value of k in a KNN classification task.
You will be using the ‘iris’ dataset.
Start with your_unity_id_knn_cv.R and fill in the missing content. The “###”s roughly indicate that
the line(s) below need(s) modification from you, or that you are expected to write your own section
of code based on the comments specified above the ‘###’s. It should be straightforward as to what
is asked and what the various variables are supposed to contain, especially since the file is heavily
commented. You might want to refresh your memory on cross validation from the textbook -
page 187.

# File 3: adb: Adaboost classifier using decision stump
Adaboost Classifier
For this project, you will learn how to implement an Adaboost Classifier .
You will be using the ‘Ionosphere’ dataset for this part of the project.
Start with your_unity_id_adb.R and fill in the missing content. The “###”s roughly indicate that the
functions below need to be completed by you, or that you are expected to write your own section of
code based on the comments specified above the ‘###’s. It should be straightforward as to what is
asked and what the various variables are supposed to contain, especially since the file is heavily
commented. You might want to refresh your memory on adaboost classifier from the
textbook - Algorithm 5.7 under section 5.6.5.
