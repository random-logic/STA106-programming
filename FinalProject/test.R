data <- read.csv("insurance.csv")
selected_columns <- c("charges", "children", "region")
data <- subset(data, select = selected_columns)
colnames(data) <- c("Y", "A", "B")

model <- lm(Y ~ A * B, data = data)
print(summary(model))