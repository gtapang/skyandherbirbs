# Acoustic Index Analysis

# Importing Data to R (Set Working Directory)
currentdirectory = ("~/SOUNDFILES/00JelSound-1/PreProcessed")
setwd(currentdirectory)

# Install packages
install.packages("soundecology")
install.packages("seewave")
install.packages("tidyverse")
install.packages("dplyr")                                        
install.packages("plyr")                                         
install.packages("readr") 

# Load packages
library(soundecology)
library(seewave)
library(tidyverse)
library(dplyr)                                                 
library(plyr)                                                  
library(readr)   



### Acoustic Index Analysis: SOUNDECOLOGY

## Acoustic Complexity Index (ACI)
# Calculate ACI
multiple_sounds(directory = currentdirectory,
                resultfile = "aci_results.csv",
                soundindex = "acoustic_complexity",
                no_cores = "max")

# Create aci_results dataframe
aci_results = read.csv("aci_results.csv")

# Create new data frame, selecting only FILENAME & LEFT_CHANNEL columns
ACI = aci_results[,c("FILENAME","LEFT_CHANNEL")]

# Rename FILENAME to WAV and LEFT_CHANNEL to ACI
names(ACI)[1]<-paste("WAV")
names(ACI)[2]<-paste("ACI")


## Acoustic Diversity Index (ADI)
# Calculate ADI
multiple_sounds(directory = currentdirectory,
                resultfile = "adi_results.csv",
                soundindex = "acoustic_diversity",
                no_cores = "max")

# Create adi_results dataframe
adi_results = read.csv("adi_results.csv")

# Remove duplicates based on FILENAME and LEFT_CHANNEL columns
adi_resultsxdupes = adi_results %>% distinct(FILENAME, 
                                             LEFT_CHANNEL, 
                                             .keep_all = TRUE)

# Create new data frame, selecting only FILENAME & LEFT_CHANNEL columns
ADI = adi_resultsxdupes[,c("FILENAME","LEFT_CHANNEL")]

# Rename FILENAME to WAV and LEFT_CHANNEL to ADI
names(ADI)[1]<-paste("WAV")
names(ADI)[2]<-paste("ADI")


## Acoustic Evenness Index (AEI)
# Calculate AEI
multiple_sounds(directory = currentdirectory,
                resultfile = "aei_results.csv",
                soundindex = "acoustic_evenness",
                no_cores = "max")

# Create aei_results dataframe
aei_results = read.csv("aei_results.csv")

# Remove duplicates based on FILENAME and LEFT_CHANNEL columns
aei_resultsxdupes = aei_results %>% distinct(FILENAME,
                                             LEFT_CHANNEL,
                                             .keep_all = TRUE)

# Create new data frame, selecting only FILENAME & LEFT_CHANNEL columns
AEI = aei_resultsxdupes[,c("FILENAME","LEFT_CHANNEL")]

# Rename FILENAME to WAV and LEFT_CHANNEL to AEI
names(AEI)[1]<-paste("WAV")
names(AEI)[2]<-paste("AEI")


## Bioacoustic Index (BI)
# Calculate BI
multiple_sounds(directory = currentdirectory,
                resultfile = "bi_results.csv",
                soundindex = "bioacoustic_index",
                no_cores = "max")

# Create bi_results dataframe
bi_results = read.csv("bi_results.csv")

# Create new data frame, selecting only FILENAME & LEFT_CHANNEL columns
BI = bi_results[,c("FILENAME","LEFT_CHANNEL")]

# Rename FILENAME to WAV and LEFT_CHANNEL to BI
names(BI)[1]<-paste("WAV")
names(BI)[2]<-paste("BI")


## Acoustic Entropy Index (H)
# Calculate H
multiple_sounds(directory = currentdirectory,
                resultfile = "h_results.csv",
                soundindex = "H")

# Create h_results dataframe
h_results = read.csv("h_results.csv")

# Create new data frame, selecting only FILENAME & LEFT_CHANNEL columns
H = h_results[,c("FILENAME","LEFT_CHANNEL")]

# Rename FILENAME to WAV and LEFT_CHANNEL to H
names(H)[1]<-paste("WAV")
names(H)[2]<-paste("H")



### Acoustic Index Analysis: SEEWAVE

## Acoustic Richness Index (AR)
# Calculate AR
ar_results = AR(getwd(), datatype = "files")

# Create .csv file
write.csv(ar_results, 
          file = "~/SOUNDFILES/00JelSound-1/PreProcessed/ar_results.csv")

# Remove duplicates based on AR column
ar_resultsxdupes = ar_results %>% distinct(AR,.keep_all = TRUE)

# Create new data frame, selecting only AR column
AR = ar_resultsxdupes %>% select(AR)



### Additional Calculations ACI & AEI

## ACI & AEI addtl calc
ACIoverfive = ACI [c("ACI")]/5
oneminusAEI = 1.0-AEI [c("AEI")]



### Merging dataframes 

## Parse using ACI$WAV column
YYYY = substr(ACI$WAV, 1,4)
MM = substr(ACI$WAV, 6,7)
DD = substr(ACI$WAV, 9,10)
HH = substr(ACI$WAV, 12,13)
mm = substr(ACI$WAV, 15,16)
L = substr(ACI$WAV, 18,22)

## Combine all dataframes
AIanalysis = data.frame(YYYY,
                        MM,
                        DD,
                        HH,
                        mm,
                        L,
                        ACIoverfive,
                        ADI [c("ADI")], 
                        oneminusAEI, 
                        BI [c("BI")], 
                        H [c("H")], 
                        AR[c("AR")])

## Create .csv file 
write.csv(AIanalysis, 
          file = "~/SOUNDFILES/00JelSound-1/PreProcessed/AIanalysis.csv")


Sanalysis = read.csv("Sanalysis.csv")
Sanalysis

### Statistical Analysis: Spearman's rank correlation coefficient 

## Is the number of species heard significantly correlated with AI values?
## Null = not significant
## Alt = significant
## p-value < 0.05 = reject the null hypothesis
## p-value > 0.05 = fail to reject null hypothesis

# Species Heard vs. ACI
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$ACI, 
         method = "spearman")
# p-value = 0.5037
# rho = -0.06764296 
# Not significant 
# Very weak negative correlation

boxplot(Sanalysis$ACI~Sanalysis$SH, 
        ylab = "ACI/5", 
        xlab ="Species Heard")
title("ACI/5 vs. SH")
text(x= 9.5, y= 1950, labels="Rs = -0.07")
text(x= 9.5, y= 1930, labels= "p = 0.50")


# Species Heard vs. ADI
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$ADI, 
         method = "spearman")
# p-value = 0.004902
# rho = -0.2792318
# Significant 
# Weak negative correlation

boxplot(Sanalysis$ADI~Sanalysis$SH, 
        ylab = "ADI", 
        xlab ="Species Heard")
title("ADI vs. SH")
text(x= 9.5, y= 2, labels="Rs = -0.28", col="red")
text(x= 9.5, y= 1.87, labels= "p = 0.005", col="red")


# Species Heard vs. AEI
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$AEI, 
         method = "spearman")
# p-value = 0.00616
# rho = -0.2721475 
# Significant 
# Weak negative correlation

boxplot(Sanalysis$AEI~Sanalysis$SH, 
        ylab = "AEI-1", 
        xlab ="Species Heard")
title("AEI-1 vs. SH")
text(x= 9.5, y= 0.85, labels="Rs = -0.27", col="red")
text(x= 9.5, y= 0.80, labels= "p = 0.06", col="red")


# Species Heard vs. BI
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$BI, 
         method = "spearman")
# p-value = 0.7356
# rho = 0.03419115 
# Not significant
# Very weak positive correlation

boxplot(Sanalysis$BI~Sanalysis$SH, 
        ylab = "BI", 
        xlab ="Species Heard")
title("BI vs. SH")
text(x= 9.5, y= 21, labels="Rs = 0.034")
text(x= 9.5, y= 19.8, labels= "p = 0.74")


# Species Heard vs. H
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$H, 
         method = "spearman")
# p-value = 0.9238
# rho = 0.009684058 
# Not significant
# Very weak positive correlation

boxplot(Sanalysis$H~Sanalysis$SH,
        ylab = "H", 
        xlab ="Species Heard")
title("H vs. SH")
text(x= 9.5, y= 0.88, labels="Rs = 0.01")
text(x= 9.5, y= 0.86, labels= "p = 0.92")


# Species Heard vs. AR
cor.test(x = Sanalysis$SH, 
         y = Sanalysis$AR, 
         method = "spearman")
# p-value = 3.875e-05
# rho = -0.3992523 
# Significant
# Moderate negative correlation

boxplot(Sanalysis$AR~Sanalysis$SH, 
        ylab = "AR", 
        xlab ="Species Heard")
title("AR vs. SH")
text(x= 9, y= 0.8, labels="Rs = 0.40", col="red")
text(x= 9, y= 0.7, labels= "p = 3.875e-05", col="red")


