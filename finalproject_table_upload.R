



projpath <- getwd()

if(!exists("xdbsock")) {
    xdbsock <- ""
    cat("\n", "Parameter 'xdbsock' not found, setting to empty string for general usage", "\n")
}


library(RMySQL)


drv <- dbDriver("MySQL")






########################################






xdbuser <- Sys.getenv("db_admin_user")
xpw     <- Sys.getenv("db_admin_password")
xdbname <- Sys.getenv("db_admin_db")
xdbhost <- Sys.getenv("db_admin_endpoint")
xdbport <- as.integer( Sys.getenv("db_admin_port") )



con <- dbConnect(drv
                 , user=xdbuser
                 , password=xpw
                 , dbname = xdbname
                 , host=xdbhost
                 , port=xdbport
                 , unix.sock=xdbsock)



#xpathTables <- file.path("___data")


#dfx <- read.table( file.path(xpathTables, "ozone.tsv") , sep="\t", header=TRUE )
#head(dfx)

#dfx <- data.frame("ID"=I(1:nrow(dfx)), dfx)


### ozone_data is called "pothole" name convention

xtableName <- 'music'

xbool.tableExists <- dbExistsTable(con, xtableName) ; xbool.tableExists



############################## IMPORTANT NOTE -- THE FOLLOWING CODE CHUNK DESTROYS THE TABLE METADATA
############################## IN REAL LIFE, YOU'LL SURELY WANT STRICT LIMITATIONS OVER THIS OPERATION

if(xbool.tableExists) {
    qstr <- paste0("DROP TABLE ", xtableName)
    xx <- dbGetQuery(con, qstr)
}



#qstr <-
#paste0(
#"
#CREATE TABLE "
#,  xtableName  ,
#"
#(ID INT NOT NULL AUTO_INCREMENT, x DOUBLE, y DOUBLE, o3 DOUBLE, PRIMARY KEY (ID))
#"
#)
#xx <- dbGetQuery(con, qstr)




qstr <-
paste0("CREATE TABLE "
,  xtableName  ,
"
(id varchar(10)	NOT NULL
  , track varchar(255)
, artist	varchar(255)
, uri	varchar(255)
, danceability FLOAT
, energy FLOAT
, song_key	INT
, loudness FLOAT
, song_mode INT
, speechiness FLOAT	
, acousticness FLOAT
, instrumentalness FLOAT
, liveness FLOAT
, valence FLOAT
, tempo FLOAT
, duration_ms INT
, time_signature INT	
, chorus_hit FLOAT
, sections INT
, hit	INT
, decade VARCHAR(55)
)
"
)
xx <- dbGetQuery(con, qstr)




qstr <- paste0("SHOW COLUMNS FROM ", xtableName)
dbGetQuery(con, qstr)


qstr <- paste0("DESCRIBE ", xtableName)
dbGetQuery(con, qstr)






qstr <-
paste0(
"LOAD DATA LOCAL INFILE 'C:/Users/theje/Desktop/UCLA/405/JeremyProject/wm_project.csv' ",
" INTO TABLE ", xtableName,
" FIELDS TERMINATED BY ',' ",
" LINES TERMINATED BY '\n' ",
" IGNORE 1 ROWS"
)


qstr

dbGetQuery(con, qstr)




dbGetQuery(con, "SELECT count(*) FROM music")

dbGetQuery(con, "SELECT * FROM music LIMIT 100")






## LOAD DATA LOCAL INFILE '___data/ozone.tsv'  INTO TABLE db1.ozone_data_test  FIELDS TERMINATED BY '\t'  LINES TERMINATED BY '\n'  IGNORE 1 ROWS



##### In connection advanced tab, in options: OPT_LOCAL_INFILE=1
##### Use absolute local path


## LOAD DATA LOCAL INFILE '/Users/davezes/Files/Creations/UCLAteaching/2021_02/MAS405/__code_base/___data/ozone.tsv'  INTO TABLE db1.ozone_data_test  FIELDS TERMINATED BY '\t'  LINES TERMINATED BY '\n'  IGNORE 1 ROWS







dbDisconnect(con)


