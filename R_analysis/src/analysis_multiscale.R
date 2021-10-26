library(ProjectTemplate)
load.project()

# Check the data frames -------
str(MSM_spTMS_syn)

# General plots -------
ggplot(data = MSM_spTMS_syn %>% dplyr::filter(mso <= 100), 
       aes(x = target, y = mso)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  geom_jitter(alpha = 0.5) + 
  labs(x = "", y = "Activation threshold (MSO%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")

ggplot(data = MSM_spTMS_syn %>% dplyr::filter(mso <= 100), aes(x = mso, y = efield)) + 
  facet_grid(cols = vars(target)) +
  geom_jitter() +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")

# Figure about activation threshold and cortical target -------
ggplot(data = MSM_spTMS_syn %>% dplyr::filter(mso <= 100), 
       aes(x = target, y = mso, color = target)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1, width = 0.4) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_y_continuous(breaks = seq(from = 70, to = 80, by = 2)) +
  coord_cartesian(ylim = c(70, 80)) +
  scale_fill_manual(values = c("gray15", "#FF69B4"), name = "fill") +
  scale_color_manual(values = c("gray15", "#FF69B4"), name = "color") +
  labs(x = "", y = "Activation threshold (MSO%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")

# Binomial regression about the activated neurons and cortical targets -------
nrep <- MSM_spTMS_syn %>% dplyr::group_by(participant, target) %>% summarise(n = n()) %>% dplyr::ungroup()
rmt_values <- rep(rep(rmt$mso, each = 2), nrep$n)
MSM_spTMS_syn <- MSM_spTMS_syn %>% dplyr::arrange(participant) %>% dplyr::mutate(rmt = rmt_values)
MSM_spTMS_syn <- MSM_spTMS_syn %>% dplyr::mutate(act_rmt80 = mso <= rmt * 0.8,
                                     act_rmt90 = mso <= rmt * 0.9,
                                     act_rmt100 = mso <= rmt,
                                     act_rmt110 = mso <= rmt * 1.1,
                                     act_rmt120 = mso <= rmt * 1.2)

df <- MSM_spTMS_syn %>% dplyr::filter(mso <= 100) %>% dplyr::select(-efield) %>% tidyr::pivot_longer(!c(participant, target, rmt, mso), names_to = "intensity", values_to = "act")

df_summary <- df %>% dplyr::group_by(participant, target, intensity) %>% dplyr::summarize(act = sum(act)) %>% dplyr::ungroup() %>%
  dplyr::mutate(ncell = rep(nrep$n, each = 5), rmt = rep(rmt$mso, each = 10)) %>% dplyr::mutate(perc = 100*(act/ncell)) %>% dplyr::mutate(intensity = factor(intensity, levels = c("act_rmt80", "act_rmt90", "act_rmt100", "act_rmt110", "act_rmt120")))

mod0 <- lme4::glmer(act ~ (1|participant), family = binomial(link = "logit"), data = df) 
mod1 <- lme4::glmer(act ~ (1|participant) + target, family = binomial(link = "logit"), data = df) 
anova(mod0, mod1)
summary(mod1)

# Figure about activated cells at different RMT -------
df_summary1 <- df_summary %>% dplyr::filter(intensity == 'act_rmt120')
df_summary1 %>% dplyr::filter(target == 'DLPFC') %>% dplyr::summarise(r = range(perc))

ggplot(data = df_summary, 
       aes(x = target, y = perc, fill = intensity)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position="dodge",  alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", position = position_dodge(width = 0.9), shape = 21, size = 3, stroke = 1, colour = "black") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "right")


# Select only those cells that can be activated with 100% MSO or with lower intensities -------
df <- MSM_spTMS_syn %>% dplyr::filter(mso <= 100)

# What is the activation threshold of the cells at each cortical target? -------
df_summary_act_mso <- df %>% dplyr::group_by(participant, target) %>% dplyr::summarize(activation_thold = median(mso)) %>% dplyr::ungroup() 
# figure
ggplot(data = df_summary_act_mso, 
       aes(x = target, y = activation_thold)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_y_continuous(breaks = seq(from = 50, to = 100, by = 10)) +
  coord_cartesian(ylim = c(50, 100)) +
  labs(x = "", y = "Activation threshold (MSO%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
# statistical test
t.test(data = df_summary_act_mso, activation_thold ~ target, paired = TRUE)
wilcox.test(data = df_summary_act_mso, activation_thold ~ target, paired = TRUE)

# How many cells can be activated by the stimulation intensity corresponding to 120% RMT at each cortical target? -------
nrep <- df %>% dplyr::group_by(participant, target) %>% summarise(n = n()) %>% dplyr::ungroup()
rmt_values <- rep(rep(rmt$mso, each = 2), nrep$n)
df <- df %>% dplyr::arrange(participant, target) %>% dplyr::mutate(rmt = rmt_values)
df <- df %>% dplyr::mutate(act_rmt120 = mso <= rmt * 1.2)
df_summary_rmt <- df %>% dplyr::filter(act_rmt120 == TRUE) %>% dplyr::group_by(participant, target) %>% dplyr::summarize(activated_cells = n()) %>% dplyr::ungroup() %>% 
  dplyr::mutate(n_cells = df %>% dplyr::group_by(participant, target) %>% dplyr::summarize(n_cells = n()) %>% dplyr::ungroup() %>% dplyr::pull(n_cells),
                percent = 100 * (activated_cells/n_cells)) 
# figure
ggplot(data = df_summary_rmt, 
       aes(x = target, y = percent)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_y_continuous(breaks = seq(from = 0, to = 100, by = 20)) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(x = "", y = "Activated cells (%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/MSM_act_cells_rmt.svg", plot = last_plot(), 
       width = 60, height = 75, units = "mm", dpi = 500)
#statistical test
hist(df_summary_rmt$percent)
t.test(data = df_summary_rmt, percent ~ target, paired = TRUE)
wilcox.test(data = df_summary_rmt, percent ~ target, paired = TRUE)
rstatix::wilcox_test(data = df_summary_rmt, percent ~ target, paired = TRUE)
rstatix::wilcox_effsize(data = df_summary_rmt, percent ~ target)
# How many cells can be activated by stimulation intensity corresponding to 140 V/m E-field at each cortical target? -------
ef_values <- EF_macro_efield_opt_mso %>% dplyr::filter(angle == 45) 
ef_values <- ef_values %>% dplyr::mutate(participant = factor(participant) %>% mapvalues(., from = c("s1", "s2", "s6", "s8", "s9", "s12", "s13", "s14", "s15", "s16", "s17", "s19", "s21", "s22", "s24", "s25"),
                                                                                         to = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16")),
                                         target = factor(target) %>% mapvalues(., from = c("dlpfc", "m1"), 
                                                                               to = c("DLPFC", "M1")) %>% relevel("M1")) %>% dplyr::arrange(participant, target)
ef_values <- rep(rep(ef_values$mso), nrep$n)
df <- df %>% dplyr::arrange(participant, target) %>% dplyr::mutate(ef_mso = ef_values)
df <- df %>% dplyr::mutate(act_ef = mso <= ef_mso)
df_summary_ef <- df %>% dplyr::filter(act_ef == TRUE) %>% dplyr::group_by(participant, target) %>% dplyr::summarize(activated_cells = n()) %>% dplyr::ungroup() %>% 
  dplyr::mutate(n_cells = df %>% dplyr::group_by(participant, target) %>% dplyr::summarize(n_cells = n()) %>% dplyr::ungroup() %>% dplyr::pull(n_cells),
                percent = 100 * (activated_cells/n_cells))
# figure
ggplot(data = df_summary_ef, 
       aes(x = target, y = percent)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_y_continuous(breaks = seq(from = 0, to = 100, by = 20)) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(x = "", y = "Activated cells (%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/MSM_act_cells_ef.svg", plot = last_plot(), 
       width = 60, height = 75, units = "mm", dpi = 500)
# statistical test
hist(df_summary_ef$percent)
t.test(data = df_summary_ef, percent ~ target, paired = TRUE)
wilcox.test(data = df_summary_ef, percent ~ target, paired = TRUE)
rstatix::wilcox_test(data = df_summary_ef, percent ~ target)
rstatix::wilcox_effsize(data = df_summary_ef, percent ~ target)

# How many cells can be activated by the stimulation intensity corresponding to the median activation threshold at each cortical target? -------
ms_values <- rep(rep(df_summary_act_mso$activation_thold) %>% round(., 0), nrep$n)
df <- df %>% dplyr::arrange(participant, target) %>% dplyr::mutate(ms_mso = ms_values)
df <- df %>% dplyr::mutate(act_ms = mso <= ms_mso)
df_summary_ms <- df %>% dplyr::filter(act_ms == TRUE) %>% dplyr::group_by(participant, target) %>% dplyr::summarize(activated_cells = n()) %>% dplyr::ungroup() %>% 
  dplyr::mutate(n_cells = df %>% dplyr::group_by(participant, target) %>% dplyr::summarize(n_cells = n()) %>% dplyr::ungroup() %>% dplyr::pull(n_cells),
                percent = 100 * (activated_cells/n_cells))
# figure
ggplot(data = df_summary_ms, 
       aes(x = target, y = percent)) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", alpha = 1, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 21, size = 1, stroke = 1, colour = "black") +
  scale_y_continuous(breaks = seq(from = 0, to = 100, by = 20)) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(x = "", y = "Activated cells (%)") +
  theme_bw() +
  theme(axis.text = element_text(colour = "black", size = 14),
        axis.title = element_text(colour = "black", size = 14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = "none")
ggsave("graphs/MSM_act_cells_ms.svg", plot = last_plot(), 
       width = 60, height = 75, units = "mm", dpi = 500)
# statistical test
hist(df_summary_ms$percent)
t.test(data = df_summary_ms, percent ~ target, paired = TRUE)
wilcox.test(data = df_summary_ms, percent ~ target, paired = TRUE)

# Bonferroni-Holm adjustment -------
p_values <- c(0.0001526, 0.782, 0.4037)
p.adjust(p_values, method = "holm")
