rm reports/rmse

Rscript src/baseline.R >> reports/rmse

Rscript src/lasso.R >> reports/rmse
Rscript src/log_lasso.R >> reports/rmse
Rscript src/scale_lasso.R >> reports/rmse
Rscript src/scale_log_lasso.R >> reports/rmse

Rscript src/ridge.R >> reports/rmse
Rscript src/log_ridge.R >> reports/rmse
Rscript src/scale_ridge.R >> reports/rmse
Rscript src/scale_log_ridge.R >> reports/rmse

Rscript src/hashtags.R >> reports/rmse
Rscript src/mentions.R >> reports/rmse
Rscript src/urls.R >> reports/rmse
