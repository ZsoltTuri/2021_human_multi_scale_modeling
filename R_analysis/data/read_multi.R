dpath <- file.path('data', 'multiscale', 'spTMS_syn')
files <- list.files(dpath, pattern = "*.xlsx")
data = NULL
for(file in files){
  d <- NULL
  d <- readxl::read_excel(file.path(dpath, file), col_names = FALSE)
  data <- rbind(data, d)
}
MSM_spTMS_syn <- data
colnames(MSM_spTMS_syn) <- c("participant", "target", "mso", "efield")
MSM_spTMS_syn <- MSM_spTMS_syn %>% dplyr::mutate("participant" = factor(participant),
                                                 "target" = factor(target) %>% mapvalues(., from = c("1", "2"), to = c("DLPFC", "M1")) %>% relevel(., ref = "M1"))

rm(data, d, file, dpath, files)