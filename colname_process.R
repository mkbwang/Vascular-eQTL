library(dplyr)

transformed_rpkm = read.table("transformed_morezerosdeleted.txt", sep="")

# set the first column as row names
# rownames(transformed_rpkm) = transformed_rpkm[ ,1]
# transformed_rpkm[,1] = NULL

# function to simplify the colnames to make them same as the sample ID
simplecol = function(cname){
  name = unlist(strsplit(cname, split="[.]"))[1]
  newname = sub('X', '', name)
  newname
}

newcolnames = sapply(colnames(transformed_rpkm)[-1], simplecol)
colnames(transformed_rpkm)[-1] = newcolnames

write.table(transformed_rpkm, file="transformed_rpkm.txt", row.names=FALSE, quote=FALSE)

