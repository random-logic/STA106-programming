# Example dataframe
df <- data.frame(
  A = c(1, 2, 3),
  B = c(4, 5, 6),
  C = c(7, 8, 9)
)

# Apply a function to each row
mapped_result <- apply(df, 1, function(row) {
  # Do something with the row
  # For example, calculate the sum of the row
  print(row["A"])
  return(row["B"])
})

# Print the result
print(mapped_result)
