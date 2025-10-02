

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AlphaPalettes.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Alpha palettes by Tinkerbelly
#'
#' A list of named vectors containing alpha values
#'
#' @format ## `AlphaPalettes`
#' A list of named vectors
#' \describe{
#'   \item{name}{Palette name}
#'   \item{values}{Vector of alpha values}
#' }
#' @source Own preferences
"AlphaPalettes"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.ATCCoding.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Table of ATC codes of all categoric levels with german labels
#'
#' A tibble
#'
#' @format ## 'Res.ATCCoding'
#' Tibble
#' \describe{
#'   \item{Code}{Full ATCCode}
#'   \item{Substance}{}
#'   \item{Category1Code}{}
#'   \item{Category1}{}
#'   \item{Category3Code}{}
#'   \item{Category3}{}
#'   \item{Category4Code}{}
#'   \item{Category4}{}
#'   \item{Category5Code}{}
#'   \item{Category5}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.ATCCoding"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.CancerGrouping.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on grouping of ICD-10 cancer codes
#'
#' A tibble
#'
#' @format ## 'Res.CancerGrouping'
#' Tibble
#' \describe{
#'   \item{ICD10Code.Short}{Three digit ICD-10 code}
#'   \item{CancerTopographyGroup.ICD10}{Topography group as put forth by ICD-10}
#'   \item{CancerTopographyOrgan.ICD10}{Affected organ / topography as put forth by ICD-10}
#'   \item{CancerTopographyGroup.ZFKD}{Topography detail as put forth by ZFKD}
#'   \item{CancerTopographySpecification}{Additional information on topography}
#'   \item{CancerSpecification}{Specification of cancer entity where needed}
#'   \item{CancerIsLikelyToMetastasize}{}
#'   \item{CancerIsCarcinomaInSitu}{}
#'   \item{CancerIsNeoplasmOfUncertainBehavior}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.CancerGrouping"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.CancerSurgery.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on OPS codes in cancer surgery
#'
#' A tibble
#'
#' @format ## 'Res.CancerSurgery'
#' Tibble
#' \describe{
#'   \item{ICD10Code.Short}{Three digit ICD-10 code}
#'   \item{CancerTopographyDetail.ICD10}{Affected organ / topography as put forth by ICD-10}
#'   \item{OPSCode.Short}{Four digit OPS code}
#'   \item{Procedure}{German label of procedure coded in OPS}
#'   \item{IsLikelyCancerRelated}{}
#'   \item{IsLikelyCurativeIntention_Primary}{}
#'   \item{IsLikelyCurativeIntention_Secondary}{}
#'   \item{IsLikelySupportive_Direct}{}
#'   \item{IsLikelySupportive_Indirect}{}
#'   \item{IsInPlattform65cCatalogue}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.CancerSurgery"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Colors.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Preferred colors by Tinkerbelly
#'
#' A list of named hexadecimal RGB codes
#'
#' @format ## `Colors`
#' A list of named strings (hexadecimal RGB codes)
#' \describe{
#'   \item{name}{Color name}
#'   \item{code}{Color code}
#' }
#' @source Own preferences after researching a lot of color palette stuff
"Colors"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.OPSCodes.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on OPS codes in general
#'
#' A tibble
#'
#' @format ## 'Res.OPSCodes'
#' Tibble
#' \describe{
#'   \item{OPSVersion}{Year of OPS version}
#'   \item{CodeLevel}{}
#'   \item{IsTerminal}{}
#'   \item{ChapterCode}{}
#'   \item{FirstSubgroupCodeOfGroup}{}
#'   \item{SubgroupCode}{}
#'   \item{OPSCode}{}
#'   \item{NeedsLocalization}{}
#'   \item{Procedure}{}
#'   \item{Procedure.Main}{}
#'   \item{Procedure.Specification}{}
#'   \item{Procedure.Subspecification}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.OPSCodes"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.P21Departments.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on Hospital Department coding in the context of P21 data
#'
#' A tibble
#'
#' @format ## 'Res.P21Departments'
#' Tibble
#' \describe{
#'   \item{DepartmentCode}{}
#'   \item{DepartmentOriginalLabel}{}
#'   \item{Department}{}
#'   \item{OperatingSpecialty}{}
#'   \item{Subspecialty}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.P21Departments"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Res.P21DischargeReasons.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on Discharge Reason coding in the context of P21 data
#'
#' A tibble
#'
#' @format ## 'Res.P21DischargeReasons'
#' Tibble
#' \describe{
#'   \item{DischargeReasonCode}{}
#'   \item{DischargeReasonOriginalLabel}{}
#'   \item{DischargeCategory}{}
#' }
#' @source <https://github.com/BastianReiter/TinkerLab/tree/main/Development/Data>
"Res.P21DischargeReasons"
