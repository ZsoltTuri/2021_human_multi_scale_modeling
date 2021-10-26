library(ProjectTemplate)
load.project()

# Check the data frames ----------------------------------------------------------------------------------------------------------------------------------------------
str(EF_macro_mso1)
str(EF_macro_rmt)
str(EF_macro_fxd)
str(EF_macro_efield_opt)
str(EF_macro_efield_opt_mso)
str(scalp_cortex_distance)
str(EF_macro_mso1_max)

# Analysis (E-total) ------------------------------------------------------------------------------------------------------------------------------------------------
# Model
df <- EF_macro_mso1 %>% dplyr::filter(component == 'EFabs_GMsurf') 
mod0 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant))
mod1 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target)
mod2 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + angle)
mod3 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target * angle)
anova(mod0, mod1, mod2, mod3)
anova(mod1)
summary(mod1)
plot(mod1)
(-26.489) - (-132.679) # delta BIC

# effect size:
effectsize::F_to_eta2(f =  130.75, df = 1, df_error = 367)
effectsize::F_to_epsilon2(f =  130.75, df = 1, df_error = 367)
effectsize::F_to_omega2(f =  130.75, df = 1, df_error = 367)

# figure
ggplot(data = df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(1.5, 2.5)) +
  scale_y_continuous(breaks = seq(from = 1.5, to = 2.5, by = 0.25)) +
  labs(x = "Target", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf.svg", plot = last_plot(), 
       width = 50, height = 65, units = "mm", dpi = 500)

# Analysis (E-tangential) -------------------------------------------------------------------------------------------------------------------------------------------
# Model
df <- EF_macro_mso1 %>% dplyr::filter(component == 'EFtan_GMsurf') 
mod0 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant))
mod1 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target)
mod2 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + angle)
mod3 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target * angle)
anova(mod0, mod1, mod2, mod3)
anova(mod1)
summary(mod1)
plot(mod1)
(39.613) - (-19.329) # delta BIC

# effect size:
effectsize::F_to_eta2(f =  70.772, df = 1, df_error = 367)

# figure
ggplot(data = df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(1.5, 2.25)) +
  scale_y_continuous(breaks = seq(from = 1.5, to = 2.25, by = 0.25)) +
  labs(x = "Target", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFtan_GMsurf.svg", plot = last_plot(), 
       width = 50, height = 65, units = "mm", dpi = 500)

# Analysis (E-perpendicular) ----------------------------------------------------------------------------------------------------------------------------------------
# Model
df <- EF_macro_mso1 %>% dplyr::filter(component == 'EFperp_GMsurf') 
mod0 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant))
mod1 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target)
mod2 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + angle)
mod3 <- lmerTest::lmer(data = df, formula = efield ~ (1|participant) + target * angle)
anova(mod0, mod1, mod2, mod3)
anova(mod1)
summary(mod1)
plot(mod1)
(-40.670) - (-47.313) # delta BIC

# effect size
effectsize::F_to_eta2(f =  12.778, df = 1, df_error = 367)

# figure 
ggplot(data = df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(0.7, 1.25)) +
  scale_y_continuous(breaks = seq(from = 0.75, to = 1.25, by = 0.25)) +
  labs(x = "Target", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFperp_GMsurf.svg", plot = last_plot(), 
       width = 50, height = 65, units = "mm", dpi = 500)

# Best rotation for M1 and DLPFC (E-total) --------------------------------------------------------------------------------------------------------------------------
EF_macro_optimal <- EF_macro_mso1 %>% dplyr::group_by(participant, target, component) %>% dplyr::slice_max(efield) %>% dplyr::ungroup()
df <- EF_macro_optimal %>% dplyr::filter(component == 'EFabs_GMsurf')

# figure
ggplot(df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(2, 2.75)) +
  scale_y_continuous(breaks = seq(from = 2, to = 2.75, by = 0.25)) +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 12),
        axis.title = element_text(colour = "black", size = 12), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_opt.svg", plot = last_plot(), 
       width = 50, height = 65, units = "mm", dpi = 500)

# test
shapiro.test(df$efield)
t.test(data = df, efield ~ target, paired = TRUE,  alternative = "two.sided")

# effect size
effectsize::t_to_eta2(t = 2.5623, df = 15)

# example participant
EF_macro_optimal %>% dplyr::filter(participant == 's21' & component == 'EFabs_GMsurf')

# Best rotation for M1 and DLPFC (E-perpendicular) ------------------------------------------------------------------------------------------------------------------
df <- EF_macro_optimal %>% dplyr::filter(component == 'EFperp_GMsurf')

# figure
ggplot(df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(0.9, 1.4)) +
  scale_y_continuous(breaks = seq(from = 0.9, to = 1.4, by = 0.1)) +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 12),
        axis.title = element_text(colour = "black", size = 12), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
# test
shapiro.test(df$efield)
t.test(data = df, efield ~ target, paired = TRUE,  alternative = "two.sided")

# effect size
effectsize::t_to_eta2(t = 3.2588, df = 15)

# example participant
EF_macro_optimal %>% dplyr::filter(participant == 's21' & component == 'EFperp_GMsurf')

# Best rotation for M1 and DLPFC (E-tangential) ------------------------------------------------------------------------------------------------------------------
df <- EF_macro_optimal %>% dplyr::filter(component == 'EFtan_GMsurf')

# figure
ggplot(df, 
       aes(x = target, y = efield, color = target, fill = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  coord_cartesian(ylim = c(1, 3)) +
  scale_y_continuous(breaks = seq(from = 1, to = 3, by = 0.1)) +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 12),
        axis.title = element_text(colour = "black", size = 12), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
# test
shapiro.test(df$efield)
t.test(data = df, efield ~ target, paired = TRUE,  alternative = "two.sided")

# effect size
effectsize::t_to_eta2(t = 1.8683, df = 15)

# correction for multiple comparison 
p.adjust(c(0.02166, 0.005287, 0.08138), method = "holm") %>% round(., 5)

# example participant
EF_macro_optimal %>% dplyr::filter(participant == 's21' & component == 'EFperp_GMsurf')


# Inter-individual variability (RMT) ------------------------------------------------------------------------------------------------------------------------------
# E-total
ggplot(EF_macro_rmt %>% dplyr::filter(component == "EFabs_GMsurf") %>% 
         mutate(target = factor(target, c('m1', 'dlpfc')),
                pid = factor(stringr::str_remove(participant, pattern = "s"))) %>% dplyr::arrange(efield) %>% dplyr::mutate(pid = forcats::fct_reorder(pid, desc(efield))), 
       aes(x = pid, y = efield, color = target, fill = target)) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 0.5, position = "dodge") +
  stat_summary(fun = mean, geom = "bar", color = "black", position = "dodge") +
  coord_cartesian(ylim = c(80, 200)) +
  scale_y_continuous(breaks = seq(from = 80, to = 200, by = 20)) +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_rmt.svg", plot = last_plot(), 
       width = 135, height = 65, units = "mm", dpi = 500)

EF_macro_rmt %>% dplyr::filter(component == "EFabs_GMsurf") %>% dplyr::group_by(participant, target) %>% summarize(efield = mean(efield)) %>% dplyr::ungroup() %>% 
  dplyr::group_by(target) %>% summarize(range(efield))

# Inter-individual variability (Fixed) ------------------------------------------------------------------------------------------------------------------------------
# E-total
ggplot(EF_macro_fxd %>% dplyr::filter(component == "EFabs_GMsurf") %>% 
         mutate(target = factor(target, c('m1', 'dlpfc')),
                pid = factor(stringr::str_remove(participant, pattern = "s"))) %>% dplyr::arrange(efield) %>% dplyr::mutate(pid = forcats::fct_reorder(pid, desc(efield))), 
       aes(x = pid, y = efield, color = target, fill = target)) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 0.5, position = "dodge") +
  stat_summary(fun = mean, geom = "bar", color = "black", position = "dodge") +
  coord_cartesian(ylim = c(80, 200)) +
  scale_y_continuous(breaks = seq(from = 80, to = 200, by = 20)) +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_fxd.svg", plot = last_plot(), 
       width = 135, height = 65, units = "mm", dpi = 500)

EF_macro_fxd %>% dplyr::filter(component == "EFabs_GMsurf") %>% dplyr::group_by(participant, target) %>% summarize(efield = mean(efield)) %>% dplyr::ungroup() %>% 
  dplyr::group_by(target) %>% summarize(range(efield))

# Inter-individual variability (E-field) ------------------------------------------------------------------------------------------------------------------------------
# E-total
ggplot(EF_macro_efield_opt %>% dplyr::filter(component == "EFabs_GMsurf") %>% 
         mutate(target = factor(target, c('m1', 'dlpfc')),
                pid = factor(stringr::str_remove(participant, pattern = "s"), levels = c("1", "2", "6", "8", "9", "12", "13", "14", "15", "16", "17", "19", "21", "22", "24", "25"))), 
       aes(x = pid, y = efield, color = target, fill = target)) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 0.5, position = "dodge") +
  stat_summary(fun = mean, geom = "bar", color = "black", position = "dodge") +
  coord_cartesian(ylim = c(80, 200)) +
  scale_y_continuous(breaks = seq(from = 80, to = 200, by = 20)) +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  labs(x = "", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_efield.svg", plot = last_plot(), 
       width = 135, height = 65, units = "mm", dpi = 500)

# figure: MSO
ggplot(EF_macro_efield_opt_mso %>% 
         dplyr::mutate(pid = factor(stringr::str_remove(participant, pattern = "s"), levels = c("1", "2", "6", "8", "9", "12", "13", "14", "15", "16", "17", "19", "21", "22", "24", "25"))),
       aes(x = pid, y = mso, color = target, fill = target)) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 0.5, position = "dodge") +
  stat_summary(fun = mean, geom = "bar", color = "black", position = "dodge") +
  coord_cartesian(ylim = c(0, 100)) +
  scale_y_continuous(breaks = seq(from = 0, to = 100, by = 20)) +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  labs(x = "", y = "MSO (%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_efield_mso.svg", plot = last_plot(), 
       width = 135, height = 65, units = "mm", dpi = 500)

# Scalp-to-cortex distance -----------------------------------------------------------------------------------------------------------------------------------------
# test
shapiro.test(scalp_cortex_distance$distance)
t.test(data = scalp_cortex_distance, distance ~ target, paired = TRUE,  alternative = "two.sided")
effectsize::t_to_eta2(t = 1.383, df = 0.1869)

# Analysis (Robust max, E-total) --------------------------------------------------------------------------------------------------------------------------------------
# Gray matter surface
df <- EF_macro_mso1_max %>% dplyr::filter(component == 'EFabs_GMsurf')
ggplot(data = df, 
       aes(x = angle %>% factor(., levels = c('0', '15', '30', '45', '60', '75', '90', '105', '120', '135', '150', '165')), y = max)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  coord_cartesian(ylim = c(2.5, 3.25)) +
  scale_y_continuous(breaks = seq(from = 2.5, to = 3.25, by = 0.25)) +
  labs(x = "Coil angle", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMsurf_max.svg", plot = last_plot(), 
       width = 140, height = 65, units = "mm", dpi = 500)

# Gray matter volume
df <- EF_macro_mso1_max %>% dplyr::filter(component == 'EFabs_GMvol')
ggplot(data = df, 
       aes(x = angle %>% factor(., levels = c('0', '15', '30', '45', '60', '75', '90', '105', '120', '135', '150', '165')), y = max)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  coord_cartesian(ylim = c(2.2, 3)) +
  scale_y_continuous(breaks = seq(from = 2.25, to = 3, by = 0.25)) +
  labs(x = "Coil angle", y = "E-Field (mV/mm)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/EFabs_GMvol_max.svg", plot = last_plot(), 
       width = 140, height = 65, units = "mm", dpi = 500)
