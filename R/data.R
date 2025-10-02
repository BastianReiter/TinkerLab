

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
# ATCCoding.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Table of ATC codes of all categoric levels with german labels
#'
#' A tibble
#'
#' @format ## 'ATCCoding'
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
"ATCCoding"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CancerGrouping.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on grouping of ICD-10 cancer codes
#'
#' A tibble
#'
#' @format ## 'CancerGrouping'
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
"CancerGrouping"



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CancerSurgery.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Meta data on OPS codes in cancer surgery
#'
#' A tibble
#'
#' @format ## 'CancerSurgery'
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
"CancerSurgery"



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
# OPSCodes.rda
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Data on OPS codes in general
#'
#' A tibble
#'
#' @format ## 'OPSCodes'
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
"OPSCodes"
