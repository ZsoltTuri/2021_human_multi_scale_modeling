update_dataframe <- function(data){
  data <- data %>% dplyr::mutate(participant = factor(participant, levels = c('s1', 's2', 's6', 's8', 's9', 's12', 's13', 's14', 's15', 's16', 's17', 's19', 's21', 's22', 's24', 's25')),
                                 component = factor(component),
                                 target = factor(target, levels = c('m1', 'dlpfc')) %>% relevel(., ref = 'm1'),
                                 angle = factor(angle, levels = c('0', '15', '30', '45', '60', '75', '90', '105', '120', '135', '150', '165')) %>% relevel(., ref = "45"))
  }

EF_macro_mso1 <- update_dataframe(EF_macro_mso1)
EF_macro_rmt <- update_dataframe(EF_macro_rmt)
EF_macro_fxd <- update_dataframe(EF_macro_fxd)
EF_macro_efield_opt <- update_dataframe(EF_macro_efield_opt)

# Use a separate procedure for the MSO values
EF_macro_efield_opt <- EF_macro_efield_opt %>% dplyr::mutate(participant = factor(participant, levels = c('s1', 's2', 's6', 's8', 's9', 's12', 's13', 's14', 's15', 's16', 's17', 's19', 's21', 's22', 's24', 's25')),
                                                             target = factor(target, levels = c('m1', 'dlpfc')) %>% relevel(., ref = 'm1'),
                                                             angle = factor(angle, levels = c('0', '15', '30', '45', '60', '75', '90', '105', '120', '135', '150', '165')) %>% relevel(., ref = "45"))

# Use a separate procedure for the scalp-to-cortex distance
scalp_cortex_distance <- scalp_cortex_distance %>% dplyr::mutate(participant = factor(c('s1', 's2', 's6', 's8', 's9', 's12', 's13', 's14', 's15', 's16', 's17', 's19', 's21', 's22', 's24', 's25')))
colnames(scalp_cortex_distance) <- c('dlpfc', 'm1', 'participant')
scalp_cortex_distance <- scalp_cortex_distance %>% pivot_longer(!participant, names_to = "target", values_to = "distance")

# Update data frame that contains the robust max values 
EF_macro_mso1_max <- EF_macro_mso1_max %>% dplyr::mutate(participant = factor(participant, levels = c('s1', 's2', 's6', 's8', 's9', 's12', 's13', 's14', 's15', 's16', 's17', 's19', 's21', 's22', 's24', 's25')),
                                                         angle = factor(angle, levels = c('0', '15', '30', '45', '60', '75', '90', '105', '120', '135', '150', '165')) %>% relevel(., ref = "45"))