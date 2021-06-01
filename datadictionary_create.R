


projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}



#xpathTables <- file.path(projpath, "_taskCatalogs", xthis.taskName, "__Tables")



library(RMySQL)

library(rjson)


drv <- dbDriver("MySQL")






######################################## dataDictionary

################### You must add the appropriate parameters to you .Renviron file

xdbuser <- Sys.getenv("db_admin_user")
xpw     <- Sys.getenv("db_admin_password")
xdbname <- Sys.getenv("db_admin_db")
xdbhost <- Sys.getenv("db_admin_endpoint")
xdbport <- as.integer( Sys.getenv("db_admin_port") )


con <- dbConnect(drv, user=xdbuser, password=xpw, dbname=xdbname, host=xdbhost, port=xdbport, unix.sock=xdbsock)



dbListTables(con)

dbGetInfo(con)


#################


qstr <- paste0(
"SELECT * FROM music limit 100"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx


############### let's document, simply, DB

##### dataDictionary is an example of camel-case naming convension

xbool.tableExists <- dbExistsTable(con, "dataDictionary") ; xbool.tableExists


xthis_taskName <- "music"

############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE dataDictionary
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste("DROP TABLE dataDictionary",  sep="")
    xx <- dbGetQuery(con, qstr)
}



############ note that table name is primary key -- primary keys MUST BE UNIQUE

#qstr <- paste0("CREATE TABLE dataDictionary (tableName VARCHAR(100) NOT NULL, about TEXT, variableDefs TEXT, PRIMARY KEY (tableName))")
#xx <- dbGetQuery(con, qstr)
### xvariables <- "longitude: geo longitude; latitude: geo latitude; O3: ground level ozone concentration, ppm"



qstr <- paste0("CREATE TABLE dataDictionary (tableName VARCHAR(100) NOT NULL, about TEXT, variableDefs JSON, PRIMARY KEY (tableName))")
xx <- dbGetQuery(con, qstr)



qstr <- paste0(
"SELECT * FROM dataDictionary"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx




xabout <- "music"

xls_vars <-
list(
"id"="observation id particular to this WM project",
"track"="The Name of the track.",
"artist"="The Name of the Artist",
"uri"="The resource identifier for the track.",
"danceability"="Danceability describes how suitable a track is for dancing based on a
combination of musical elements including tempo, rhythm stability, beat strength, and overall
regularity. A value of 0.0 is least danceable and 1.0 is most danceable.",
"energy"="Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of
intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example,
death metal has high energy, while a Bach prelude scores low on the scale. Perceptual
features contributing to this attribute include dynamic range, perceived loudness, timbre,
onset rate, and general entropy",
"key"="The estimated overall key of the track. Integers map to pitches using standard Pitch
Class notation. E.g. 0 = C, 1 = C#/Db, 2 = D, and so on. If no key was detected, the value is -
1.",
"loudness"="The overall loudness of a track in decibels (dB). Loudness values are averaged
across the entire track and are useful for comparing relative loudness of tracks. Loudness is
the quality of a sound that is the primary psychological correlate of physical strength
(amplitude). Values typical range between -60 and 0 db.",
"mode"="Mode indicates the modality (major or minor) of a track, the type of scale from which
its melodic content is derived. Major is represented by 1 and minor is 0.",
"speechiness"="Speechiness detects the presence of spoken words in a track. The more
exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0
the attribute value. Values above 0.66 describe tracks that are probably made entirely of
spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music
and speech, either in sections or layered, including such cases as rap music. Values below
0.33 most likely represent music and other non-speech-like tracks.",
"acousticness"="A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0
represents high confidence the track is acoustic.",
"instrumentalness"="Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are
treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The
closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal
content. Values above 0.5 are intended to represent instrumental tracks, but confidence is
higher as the value approaches 1.0.",
"liveness"="Detects the presence of an audience in the recording. Higher liveness values
represent an increased probability that the track was performed live. A value above 0.8
provides strong likelihood that the track is live.",
"valence"="A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a
track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while
tracks with low valence sound more negative (e.g. sad, depressed, angry).",
"tempo"="The overall estimated tempo of a track in beats per minute (BPM). In musical
terminology, tempo is the speed or pace of a given piece and derives directly from the
average beat duration.",
"duration_ms"="The duration of the track in milliseconds. (1 second = 1000 ms)",
"time_signature"=": An estimated overall time signature of a track. The time signature (meter) is
a notational convention to specify how many beats are in each bar (or measure)",
"chorus_hit"="This the the author’s best estimate of when the chorus would start for the track.
Its the timestamp of the start of the third section of the track (in milliseconds). This feature
was extracted from the data recieved by the API call for Audio Analysis of that particular
track.",
"sections"="The number of sections the particular track has. This feature was extracted from
the data recieved by the API call for Audio Analysis of that particular track.",
"hit"="The target variable for the track. It can be either ‘0’ or ‘1’. ‘1’ implies that this song has
featured in the weekly list (Issued by Billboards) of Hot-100 tracks in that decade at least
once and is therefore a ‘hit’. ‘0’ Implies that the track is a ‘flop’.",
"decade"="added by us so we could send all the data in one file. Decade was not included as a
variable in the original data. It was added using the file name at time of file reading."
)


xls_info <-
list(
"about"="music data",
"codebook"=xls_vars
)




xinfoJSON <- toJSON(xls_info)



xinfoEscaped <- dbEscapeStrings(con, xinfoJSON)
xinfoEscaped




qstr <- paste0(
"INSERT INTO dataDictionary (tableName, about, variableDefs) VALUES (",
"'", xthis_taskName, "', ",
"'", xabout, "', ",
"'", xinfoEscaped, "'",
")"
) ; qstr

xx <- dbGetQuery(con, qstr)



#############################

qstr <- paste0(
"SELECT * FROM dataDictionary"
) ; qstr
xx <- dbGetQuery(con, qstr)
xx


##### writeLines( xx[4, "variableDefs"], con=file.path("~", "Desktop", "DD_json.json"))



qstr <- paste0("SHOW COLUMNS FROM dataDictionary")
dbGetQuery(con, qstr)


#####################################
#####################################
#####################################  JSON


yy <- dbGetQuery(con, "SELECT * FROM metadata")

######## view as list -- a little more readable
fromJSON(yy[ 1, "entry"])

writeLines(yy[ 1, "entry"], file.path("~", "DZ_metadata.json"))




################# data dictionary

yy <- dbGetQuery(con, "SELECT * FROM dataDictionary")

######## view as list -- a little more readable
fromJSON(yy[ 1, "variableDefs"])

writeLines(yy[ 1, "variableDefs"], file.path("~", "Desktop", "DZ_DDexample.json"))






dbDisconnect(con)




############################## workbench and mysql-client

if(FALSE) {
    
    ################## in workbench
    
    ### note may need to double click db name in schema to set default db for queries
    select * from dataDictionary
    
    
    ################### mysql command line
    
    mysql -h database-1.cpr21gaoimsy.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
    
    \u db1
    
    \G 'select * from dataDictionary'
    
    --or--
    
    select * from dataDictionary ;
    
    
    
    ##################### ADD NEW USER
    
    ################# new user in mysql -- do not do this in AWS RDS Console
    
    ########### in mysql:
    
    SHOW GRANTS FOR 'admin' ;
    
    GRANT SELECT ON db1.* TO 'readOnly' IDENTIFIED BY '2277read**00' ;
    
    #### you can now see user readOnly on MySQL Workbench
    
    
    ################### stopped here
    
}



