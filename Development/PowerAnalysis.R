
#===============================================================================
#
# Sample size / Power Analysis
#
#===============================================================================

library(rpact)


#-------------------------------------------------------------------------------
# Study type: Observational
# Primary measure: Hazard ratio
# Interest: Non-inferiority
# Question: Sample Size
#-------------------------------------------------------------------------------

Alpha.OneSided <- 0.025
Beta <- 0.2
HR.NImargin <- 1.2      # Largest acceptable worsening (HR > 1)
HR.H1 <- 1
AccrualTime <- 60
FollowUpTime <- 12
#DropOutRate <- 0.1
AllocationRatioPlanned <- 1      # Can be set to 0 to get optimal allocation ratio

# Perform sample size calculation
SampleSize <- getSampleSizeSurvival(design = getDesignGroupSequential(kMax = 1,
                                                                      alpha = Alpha.OneSided,
                                                                      beta = Beta,
                                                                      sided = 1),
                                    thetaH0 = HR.NImargin,
                                    hazardRatio = HR.H1,
                                    allocationRatioPlanned = AllocationRatioPlanned,
                                    accrualTime = AccrualTime,
                                    followUpTime = FollowUpTime)

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Study type: Observational
# Primary measure: Hazard ratio
# Interest: Non-inferiority
# Question: Power
#-------------------------------------------------------------------------------

SampleSize <- 4000
NumberOfEvents <- 2000
Alpha.OneSided <- 0.025
Beta <- 0.2
HR.NImargin <- 1.2      # Largest acceptable worsening (HR > 1)
HR.H1 <- 1
AccrualTime <- 60
FollowUpTime <- 12
#DropOutRate <- 0.1
AllocationRatioPlanned <- 1      # Can be set to 0 to get optimal allocation ratio

Median.Treatment <- 12
Lambda.Treatment <- log(2) / Median.Treatment

Median.Control <- 12
Lambda.Control <- log(2) / Median.Control


# Perform power calculation
Power <- getPowerSurvival(design = getDesignGroupSequential(kMax = 1,
                                                            alpha = Alpha.OneSided,
                                                            beta = Beta,
                                                            sided = 1),
                          thetaH0 = HR.NImargin,
                          hazardRatio = HR.H1,
                          allocationRatioPlanned = AllocationRatioPlanned,
                          accrualTime = AccrualTime,
                          maxNumberOfSubjects = SampleSize,
                          maxNumberOfEvents = NumberOfEvents,
                          # median1 = Median.Treatment,
                          median2 = Median.Control)
                          # lambda2 = Lambda.Control)



getSampleSizeSurvival(thetaH0 = 1.2, hazardRatio = 1,
        allocationRatioPlanned = 0, accrualTime = c(0, 60),
        followUpTime = 24, dropoutRate1 = 0.3, dropoutRate2 = 0.3,
        dropoutTime = 24) |>
    summary()





#-------------------------------------------------------------------------------
# Study type: Observational
# Primary measure: Risk ratio
# Interest: Non-inferiority
# Question: Risk ratio (minimum detectable effect)
#-------------------------------------------------------------------------------

Calculation <- power.prop.test(n = 4000,
                               p1 = NULL,
                               p2 = 0.3,
                               sig.level = 0.025,
                               power = 0.8,
                               alternative = "one.sided")

MDE <- Calculation$p1 / Calculation$p2


Calculation <- power.prop.test(n = 4000,
                               p1 = NULL,
                               p2 = 0.1,
                               sig.level = 0.025,
                               power = 0.8,
                               alternative = "one.sided")

MDE <- Calculation$p1 / Calculation$p2




