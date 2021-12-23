
```bash
conda activate ENV_NAME
conda install -c conda-forge udunits2
```

```R
# 不要在Rstudio中操作
config <- c(units="--with-udunits2-lib=/path/to/home/directory/anaconda/envs/ENV/lib --with-udunits2-include=/path/to/home/directory/anaconda/envs/ENV/include")
install.packages("units", configure.args = config )
```
```bash
conda install -c conda-forge r-sf
```
```R
install.packages("ggVennDiagram")
```
```R
# install.packages("ggVennDiagram")
library(ggVennDiagram)

# List of items
x <- list(A = 1:5, B = 2:7)

# 2D Venn diagram
ggVennDiagram(x) 


# List of items
x <- list(A = 1:5, B = 2:7, C = 5:10, D = 8:15)

# 4D Venn diagram
ggVennDiagram(x,category.names = c("Group 1",
                                  "Group 2",
                                  "Group 3",
                                  "Group 4"),
              label_alpha = 0, 
              label = "percent",)+
              #label = "count") + 
  scale_fill_gradient(low = "#F4FAFE", high = "#4981BF")
  ```
