require(haven)
require(tidyverse)

data <- read_sav('mergedData_2024-September-04-Deidentified Vetstudy 1.sav')

subdata <- data %>%
  select(starts_with('epsi') | starts_with('idas') & 
        (ends_with('_t1') | ends_with('_t2')))

subdata <- subdata[,c(1:45,54:98,213:239,241:277,279:313,333:359,361:397,399:433)]

IDs <- data %>% select(c('ID', 'flag1_t1', 'gender_t1'))
subdata <- cbind(IDs, subdata)
subdata <- subdata[which(subdata$flag1_t1==0),]

subdata$idas13_t2 <- ifelse(subdata$idas13_t2==0, 1, subdata$idas13_t2)

subdata$gender_t1 <- factor(subdata$gender_t1, 
                            levels=c('Female', 'Male', 'Missing', 'Other Gender'), 
                            labels=c(1:4))
subdata$gender_t1 <- as.numeric(subdata$gender_t1)
subdata$gender_t1 <- ifelse(subdata$gender_t1>2, NA, subdata$gender_t1)

write.csv(subdata, 'AllData_wide_merged.csv')

require(psych)

# polyt1 <- polychoric(subdata[,c(3:47, 93:191)], smooth=T, global=T)


# fa.parallel(subdata[,c(3:47, 93:191)], fm="minres",fa="both", 
            # main="Parallel Analysis Scree Plot",
            # n.iter=20,cor="poly", plot=TRUE)

# t1: 3:47, 93:191
# t2: 48:92, 192:290

# paSelect(keys,x,cor="cor", fm="minres",plot=FALSE)