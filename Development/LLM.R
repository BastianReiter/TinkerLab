

library(ellmer)
library(pdftools)


chat <- chat_openai(base_url = "https://litellm.s.studiumdigitale.uni-frankfurt.de",
                    api_key = "sk-ltp_wRiS6I5cCh5oVRfDzA",
                    model = "gpt-4o",
                    system_prompt = "You are a friendly AI bot that helps me extract structured data from a text that was converted from a pdf file.")

chat$chat("Hello how are you?")


StageTableRow <- type_object( .description = "A row in a 'Stage' table to classify 'Stage' based on 'T', 'N', and 'M' values.",
                              Stage = type_enum(description = "A 'Stage' value like 'Stage I', 'Stage II' and others. They begin with 'Stage'. If you can not classify the value, label it as 'Unclear'.",
                                                values = c('O', '0is', '0a',
                                                           'I', 'IA', 'IA1', 'IA2', 'IB', 'IB1', 'IB2', 'IC', 'IS',
                                                           'II', 'IIA', 'IIA1', 'IIA2', 'IIB', 'IIC',
                                                           'III', 'IIIA', 'IIIB', 'IIIC', 'IIIC1', 'IIIC2', 'IIID',
                                                           'IV', 'IVA', 'IVB', 'IVC',
                                                           'Unclear')),
                              T = type_enum(description = "A 'T' value like 'T1', 'T2' and others. They usually begin with 'T' or it is the string 'Any T'. If you can not classify the value, label it as 'Unclear'.",
                                            values = c('Tis', 'T0', 'pTis',
                                                       'T1', 'T1a', 'T1a1', 'T1a2', 'T1b', 'T1b1', 'T1b2', 'T1c', 'T1b-d', 'pT1', 'pT1-T4',
                                                       'T2', 'T2a', 'T2a1', 'T2a2', 'T2b', 'T2c', 'T2c-d', 'cT2', 'cT2a', 'cT2b', 'cT2c', 'pT2', 'pT2-T4',
                                                       'T3', 'T3a', 'T3b', 'T3c', 'T3b-c', 'T3d', 'pT3', 'pT4',
                                                       'T4', 'T4a', 'T4b', 'T4c', 'T4d', 'T4e', 'T4b-c', 'T4d-e',
                                                       'Any T', 'Any pT', 'Any pT/TX',
                                                       'Unclear')),
                              N = type_enum(description = "Third column containing 'N' values like 'N0', 'N1' and others. They usually begin with 'N' or it is the string 'Any N'. If you can not classify the value, label it as 'Unclear'.",
                                            values = c('N0',
                                                       'N1', 'N1a', 'N1b', 'N1c',
                                                       'N2',
                                                       'N3',
                                                       'Any N',
                                                       'Unclear')),
                              M = type_enum(description = "Fourth column containing 'M' values like 'M0' and 'M1'. If you can not classify the value, label it as 'Unclear'.",
                                            values = c('M0', 'M1', 'Any M')))


StageTableRow.Basic <- type_object( .description = "A row in a 'Stage' table to classify 'Stage' based on 'T', 'N', and 'M' values.",

                                    Stage = type_string(description = "A 'Stage' value like 'Stage I', 'Stage II' and others. They begin with 'Stage'. If you can not classify the value, label it as 'Unclear'."),

                                    T = type_string(description = "A 'T' value like 'T1', 'T2' and others. They usually begin with 'T' or it is the string 'Any T'. If you can not classify the value, label it as 'Unclear'."),

                                    N = type_string(description = "Third column containing 'N' values like 'N0', 'N1' and others. They usually begin with 'N' or it is the string 'Any N'. If you can not classify the value, label it as 'Unclear'."),

                                    M = type_string(description = "Fourth column containing 'M' values like 'M0' and 'M1'. If you can not classify the value, label it as 'Unclear'."))


StageTable <- type_object(.description = "A tabular depiction of stages classified by certain values for primary tumor extent (T), affection of regional lymph nodes (N), and evidence of distant metastasis (M).",

                          TopographyGroup = type_string(description = "Current topographical group of malignome entities."),

                          ICDCodes = type_array(description = "The distinct ICD-O or ICD-10 codes mentioned in the current topography group.",
                                                items = type_string()),

                          ClassificationType = type_enum(description = "For some topographies there are separate stage tables for 'Clinical Stage' and 'Pathological Stage' classification. If no such separation is present, assume 'Common'.",
                                                         values = c('Clinical', 'Pathological', 'Common')),

                          StageTable = type_array(description = "Collection of table rows belonging to the current 'Stage' table.",
                                                   items = StageTableRow.Basic))


chat$chat_structured(
  paste("I will give you a text from the book 'TNM Classification of Malignant Tumors, Ninth Edition', which contains classification of the anatomical extent of solid tumors.",
        "I am interested in the classification of 'Stage' by primary tumor extent (T), affection of regional lymph nodes (N), and evidence of distant metastasis (M).",
        "I need you to extract data of tables that depict this classification. The book is structured by topography groups. So not every cancer entity has its own Stage table.",
        "For some topographies there are separate stage tables for 'Clinical Stage' and 'Pathological Stage' classification. If no such separation is present, assume 'Common'.",
        "Here is the text:",
        PDFText),
  type = type_array(description = "The 'Stage' tables for different topography groups.",
                    items = StageTable),
  convert = FALSE
)




PDFText <- pdf_text("TNMClassificationOfMalignantTumorsNinthEdition.pdf")

PDFText <- paste(PDFText, collapse = " \n")


Test <- chat$last_turn(role = "assistant")@contents[[1]]@value$wrapper

Test[[1]]$StageTable
