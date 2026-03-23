install.packages("dbscan")
library(dbscan)
library(ggplot2)
library(tidyverse)
library(dplyr)
install.packages("ggtern")
library(ggtern)
da <- read.csv("~/Downloads/CSS_Song2_Onsets_Selected.csv")
summary(da)
clave_onset <- da$Clave
clave_ons<-na.omit(clave_onset)
p1<-clave_ons[-length(clave_ons)]
p2<-clave_ons[-1]
clave.int=p2-p1

pair1<-clave.int[-length(clave.int)]
pair2<-clave.int[-1]
cd.clave= pair1 + pair2
rhythm = pair1/cd.clave 

sixteen=60/68/4

data <- data.frame(cd = cd.clave/sixteen, rhythm)

ppair1 <- data[-nrow(data),]
ppair2 <- data[-1,]
grey.trans <- data.frame(from =ppair1, to = ppair2 )



data_mat <- as.matrix(data[, c("rhythm", "cd")])
cl <- hdbscan(data_mat, minPts = 10)
cl$cluster

final <-data.frame(cluster = cl$cluster, cd = cd.clave/sixteen, rhythm)


# 相邻两个pattern的cluster转换
from_cluster <- final$cluster[-nrow(final)]      # 去掉最后一行
to_cluster   <- final$cluster[-1]             # 去掉第一行

transitions <- data.frame(from = from_cluster, to = to_cluster)

# 计算每种转换的频率
trans_count <- transitions %>%
  group_by(from, to) %>%
  summarise(count = n(), .groups = "drop")

center <- final %>%
  group_by(cluster) %>%
  summarise(x = mean(rhythm), y = mean(cd))

arrows_data <- trans_count %>%
  left_join(center, by = c("from" = "cluster")) %>%
  rename(x_from = x, y_from = y) %>%
  left_join(center, by = c("to" = "cluster")) %>%
  rename(x_to = x, y_to = y) %>%
  filter(from != to) 


arrows_data_filtered <- arrows_data %>%
  filter(count >= 90)


p1 <- ggplot(final,aes(x = rhythm, y = cd)) +
  geom_segment(
    data = grey.trans,
    aes(x = from.rhythm, y = from.cd, xend = to.rhythm, yend = to.cd),
    arrow = arrow(length = unit(0.1, "cm"), type = "closed"),
    color = "grey80", size = 0.1, alpha = 0.3,
    inherit.aes = FALSE) +
  scale_size_continuous(range = c(0.001, 0.01))+
  geom_point(data = subset(final, cluster != 0),
             aes(color = as.factor(cluster)),
             size = 0.2,alpha = 1) +
  geom_point(data = subset(final, cluster == 0),
             color = "grey", shape = 3) +
  geom_segment(
    data = arrows_data_filtered,
    aes(x = x_from, y = y_from, xend = x_to, yend = y_to,
        linewidth = count),
    arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
    color = "black",
    inherit.aes = FALSE
  ) +
  scale_linewidth_continuous(range = c(0.3, 1))+
  labs(x = "pattern", y = "duration")+
  scale_x_continuous(limits = c(0.0, 1.0), 
                     breaks = seq(0.0, 1.0, 0.1)) +
  scale_y_continuous(limits = c(0, 8), 
                     breaks = seq(0, 10, 2)) +
  theme_classic()

print(p1)


pair1.<-clave.int[-c(length(clave.int), length(clave.int)-1)]
pair2.<-clave.int[-c(1, length(clave.int))]
pair3.<-clave.int[-c(1,2)]
cd3=(pair1.+pair2.+pair3.)/0.5

r1= pair1./cd3*2
r2= pair2./cd3*2
r3= pair3./cd3*2

final3<-data.frame(r1, r2, r3, cd3)

data_mat3 <- as.matrix(final3[, c("r1", "r2", "r3", "cd3")])
cl3 <- hdbscan(data_mat3, minPts = 5)
cl3$cluster

final33 <-data.frame(cluster = cl3$cluster, cd3, r1, r2, r3)

# 相邻两个pattern的cluster转换
from_cluster3 <- final33$cluster[-nrow(final33)]      
to_cluster3   <- final33$cluster[-1]             

transitions3 <- data.frame(from = from_cluster3, to = to_cluster3)

# 计算每种转换的频率
trans_count3 <- transitions3 %>%
  group_by(from, to) %>%
  summarise(count = n(), .groups = "drop")

center3 <- final33 %>%
  group_by(cluster) %>%
  summarise(r1_c = mean(r1),
            r2_c = mean(r2),
            r3_c = mean(r3))

arrows_data3 <- trans_count3 %>%
  left_join(center3, by = c("from" = "cluster")) %>%
  rename(r3_from = r3_c, r1_from = r1_c, r2_from = r2_c) %>%
  left_join(center3, by = c("to" = "cluster")) %>%
  rename(r3_to = r3_c, r1_to = r1_c, r2_to = r2_c) %>%
  filter(from != to)


arrows_data_filtered3 <- arrows_data3 %>%
  filter(count >= 10)

p_tern <- ggtern(final3, aes(x = r3, y = r1, z = r2, color = cd3)) +
  geom_point(size = 0.01, alpha = 0.5) +
  geom_segment(
    data = arrows_data_filtered3,
    aes(x = r3_from, y = r1_from, z = r2_from,
        xend = r3_to, yend = r1_to, zend = r2_to,
        size = count),
    arrow = arrow(length = unit(0.2, "cm"), type = "open"),
    color = "black",
    inherit.aes = FALSE
  ) +
  scale_size_continuous(range = c(0.5, 1), 
                        breaks = unique(arrows_data_filtered3$count)) +
  scale_T_continuous(breaks = seq(0.1, 1, 0.1),
                     labels = seq(0.1, 1, 0.1)) +
  scale_L_continuous(breaks = seq(0.1, 1, 0.1),
                     labels = seq(0.1, 1, 0.1)) +
  scale_R_continuous(breaks = seq(0.1, 1, 0.1),
                     labels = seq(0.1, 1, 0.1)) +
  scale_color_viridis_c(option = "plasma") +  # 对应原图颜色
  labs(x = "Interval 3", y = "Interval 1", z = "Interval 2") +
  theme_bw()

print(p_tern)

