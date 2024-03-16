sw_test <- function(model) {
  return(shapiro.test(model$residuals)$p.value)
}

bf_test <- function(model) {
  return(car::leveneTest(model)[1, 3])
}

do_transform <- function(y, x, objective, data) {
  if (objective == "None") {
    return(data)
  } else if (objective == "PPCC" || objective == "Shapiro-Wilk") {
    model <- lm(data[[y]] ~ data[[x]], data = data)
    L <- EnvStats::boxcox(model, objective.name = objective,
                          optimize = TRUE)$lambda
  } else if (objective == "Log-Likelihood") {
    L <- EnvStats::boxcox(data[[x]], objective.name = objective,
                          optimize = TRUE)$lambda
  } else {
    warning("Invalid objective")
    return()
  }

  YT <- (data[[x]] ^ L - 1) / L
  t.data <- data.frame()
  t.data[[y]] <- YT
  t.data[[x]] <- data$x

  return(t.data)
}

do_transform_and_model <- function(y, x, objective, data) {
  t.data <- do_transform(y, x, objective, data)
  t.model <- aov(t.data[[y]] ~ t.data[[x]], data = t.data)
  return(t.model)
}

remove_outlier <- function(y, x, objective, alpha = 0.05, data) {
  if (objective == "None") {
    return(data)
  }else if (objective == "Boxplot") {
    plot <- boxplot(data[[y]] ~ data[[x]], data = data, plot = FALSE)
    outliers <- plot$out
    return(data[!data[[y]] %in% outliers, ])
  } else if (objective == "Semi-studentized") {
    model <- lm(data[[y]] ~ data[[x]], data = data)
    rij <- rstandard(model)
    nt <- nrow(data)
    a <- length(unique(data[[x]]))
    t.cutoff <- qt(1 - alpha / (2 * nt), nt - a)
    CO.rij <- which(abs(rij) > t.cutoff)

    return(data[-CO.rij, ])
  } else {
    warning("Invalid objective")
    return()
  }
}

do_diagnostic <- function(y, x, o_objective, t_objective, alpha = 0.05, data) {
  data <- remove_outlier(y, x, o_objective, alpha, data = data)
  return(do_transform_and_model(y, x, t_objective, data = data))
}

# main function
options(error = traceback)
df <- read.csv("insurance.csv")
selected_columns <- c("charges", "children", "region")
df <- subset(df, select = selected_columns)
colnames(df) <- c("Y", "A", "B")
print(nrow(df))
print(do_diagnostic("Y", "A", "Boxplot", "Log-Likelihood", alpha = 0.05, data = df))