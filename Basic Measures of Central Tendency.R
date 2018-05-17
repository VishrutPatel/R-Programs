iris <- data.frame(iris)
iris.rows <- nrow(iris)
iris.cols <- ncol(iris)
iris.attrs <- colnames(iris)
iris.sw.vec <- iris[,2]
iris.sw.vec.subset <- vector(mode = "numeric")
m=0
for(cur in iris.sw.vec){
  if(cur >= 3 && cur <=4){
    iris.sw.vec.subset[m] = cur
    m=m+1
  }
}
meansum = 0
for (curval in iris.sw.vec)
  meansum = meansum + curval
iris.sw.mean = meansum/iris.rows
iris.sw.stdDev = sqrt(sum((iris.sw.vec - iris.sw.mean)^2)/(iris.rows-1))
k=sd(iris.sw.vec)
minsw = min(iris.sw.vec)
maxsw = max(iris.sw.vec)
div = maxsw-minsw
iris.sw.mm.vec <- vector(mode = "numeric",length = iris.rows)
i=0
for (val in iris.sw.vec){
  iris.sw.mm.vec[i] = (val - minsw)/div
  i=i+1
}
iris.sw.zn.vec <- vector(mode = "numeric", length = iris.rows)
j=0
for (value in iris.sw.vec){
  iris.sw.zn.vec[j] = (value-iris.sw.mean)/iris.sw.stdDev
  j=j+1
}
plot(iris$Sepal.Width,iris$Sepal.Length)

