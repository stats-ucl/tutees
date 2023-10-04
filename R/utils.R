# make_data=function(file) {
#   library(dplyr)
#   tutees1 = readxl::read_xlsx(file,sheet="FIRST YEAR") %>% rename(Name=`FIRST YEAR`) %>% mutate(Group="FIRST YEAR") |>
#     filter(!is.na(`Personal Tutor`))
#   tutees2 = readxl::read_xlsx(file,sheet="SECOND YEAR") %>% rename(Name=`SECOND YEAR`) %>% mutate(Group="SECOND YEAR") |>
#     filter(!is.na(`Personal Tutor`))
#   tutees3 = readxl::read_xlsx(file,sheet="THIRD YEAR") %>% rename(Name=`THIRD YEAR`) %>% mutate(Group="THIRD YEAR") |>
#     filter(!is.na(`Personal Tutor`))
#   tutees4 = readxl::read_xlsx(file,sheet=4) %>% rename(Name=`MSc`) %>% mutate(Group="MSc STUDENTS") |>
#     filter(!is.na(`Personal Tutor`))
#   tutees5 = readxl::read_xlsx(file,sheet="PENDING") %>%
#     rename(
#       Name=`PENDING`,
#       ## These are needed in 2023/24
#       "Personal Tutor"="PERSONAL TUTOR",
#       "Fee Status"="FEE STATUS"
#       ##
#     ) %>% mutate(Group="PENDING") |>
#     select(-c(`Interruptions/LSA/Exam`)) |>
#     filter(!is.na(`Personal Tutor`))
#   tutees=rbind(tutees1,tutees2,tutees3,tutees4,tutees5)
#   tutees=tutees %>%
#     tidyr::separate(col=Name,sep=",",into=c("Surname","Name")) %>%
#     mutate(Name=stringr::str_trim(stringr::str_remove_all(Name,"Miss|Mr|Ms|\\(repeat\\)|\\(RFI\\)|\\(Q\\)|\\(Part-time Year 1\\)|\\(Part-time Year 2\\)"))) %>%
#     select(-`...1`)
#   saveRDS(tutees,file=here::here("data/data2324.Rds"))
# }
#
#
# # Commands like
# od=get_business_onedrive()
# od$download_file("path_to_the_file_in_OneDrive",dest="local_path")
# data=readxl::read_xlsx("local_path",sheet=...)
# # create an object 'data' with the online spreadsheet's content.
# # This can be manipulated/used to make operations and if changed
# # can be uploaded using a command like
# writexl::write_excel(data,path="local_path")
# od$upload_file("local_path",dest="path_to_the_file_in_OneDrive")
# #
# # It's possible to access the shared folders/files doing
# od=get_business_onedrive()
# sod=od$list_shared_items()
# # This creates an object where each element is a folder shared with the current user
# sod[[1]]$download("path-to-file")
# # would download the name stored in the first shared folder under 'path-to-file'
# # it's possible to get all the folders names with
# sod |> names()
# #
# # This process could be highly specialised per user. For instance, if the folder
# # was owned by 'Baio, Gianluca' but shared with 'Leport, Karen', it's possible
# # to check who's actually using the script with
# if(od$properties$owner$user$displayName=="Baio, Gianluca") {
#   folder=od$list_items("Name-of-the-folder")
# }
# if(od$properties$owner$user$displayName %in% c("Leport, Karen","Jones, Elinor")) {
#   folder=od$list_shared_items()[["Names-of-the-folder"]]
# }
# #
# # This would allow to write a script that figures out who's using it and then
# # finds the right files in the right named directory. Then can download/use/
# # upload (if changed)...
