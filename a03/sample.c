#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "util.h"

EXEC SQL INCLUDE SQLCA;

// **************************** BASIC (single tuple) ******************************
int main(int argc, char *argv[]) {
   int i;

   EXEC SQL BEGIN DECLARE SECTION;
      char db[6] = "cs348";
      char title[72], pubid[9];
   EXEC SQL END DECLARE SECTION;

   printf("Sample C program: SAMPLE2\n" );

   EXEC SQL CONNECT TO :db;

   printf("Connected to DB2\n");

   EXEC SQL WHENEVER SQLERROR  GO TO error;

   for (i=1; i<argc; i++) {
     strncpy(pubid,argv[i],8);
     
     EXEC SQL WHENEVER NOT FOUND GO TO nope;
     EXEC SQL SELECT title INTO :title
              FROM   publication
              WHERE  pubid = :pubid;
     
     printf("%10s: %s\n",pubid,title);
     continue;
   nope:
     printf("%10s: *** not found *** \n",pubid);
   };

   EXEC SQL COMMIT;
   EXEC SQL CONNECT reset;
   exit(0);

error:
   check_error("My error",&sqlca);
   EXEC SQL WHENEVER SQLERROR CONTINUE;

   EXEC SQL ROLLBACK;
   EXEC SQL CONNECT reset;
   exit(1);
}


// **************************** CURSOR (multiple tuple) ******************************
EXEC SQL INCLUDE SQLCA; 

EXEC SQL BEGIN DECLARE SECTION;
   char db[6] = "cs348";
   char title[72], name[20], apat[10];
   short aid;
EXEC SQL END DECLARE SECTION;

int main(int argc, char *argv[]) {
   if (argc!=2) {
      printf("Usage: sample3 <pattern>\n");
      exit(1);
   };

   printf("Sample C program: SAMPLE3\n" );

   EXEC SQL WHENEVER SQLERROR  GO TO error;

   EXEC SQL CONNECT TO :db;

   printf("Connected to DB2\n");

   strncpy(apat,argv[1],8);
     
   EXEC SQL DECLARE author CURSOR FOR 
             SELECT name, title 
             FROM author , wrote, publication
             WHERE name LIKE :apat
               AND aid=author
               AND pubid=publication;

   EXEC SQL OPEN author;
   EXEC SQL WHENEVER NOT FOUND GO TO end;
   for (;;) {
     EXEC SQL FETCH author INTO :name, :title;
     printf("%10s -> %20s: %s\n",apat,name,title);
     };
end:
   EXEC SQL CLOSE author;

   EXEC SQL COMMIT;
   EXEC SQL CONNECT RESET;
   exit(0);

error:
   check_error("My error",&sqlca);
   EXEC SQL WHENEVER SQLERROR CONTINUE;

   EXEC SQL ROLLBACK;
   EXEC SQL CONNECT reset;
   exit(1);
}



// **************************** MAKE CHANGE  ******************************
char *gets(char *str);

EXEC SQL INCLUDE SQLCA; 

EXEC SQL BEGIN DECLARE SECTION;
   char db[6] = "cs348";
   char url[72], name[20];
EXEC SQL END DECLARE SECTION;

int main(int argc, char *argv[]) {

   printf("Sample C program: SAMPLE4\n" );

   EXEC SQL WHENEVER SQLERROR  GO TO error;

   EXEC SQL CONNECT TO :db;

   printf("Connected to DB2\n");

   EXEC SQL DECLARE author CURSOR
         FOR SELECT name
             FROM author
             WHERE url IS NULL
         FOR UPDATE OF url;

   EXEC SQL OPEN author;
   EXEC SQL WHENEVER NOT FOUND GO TO end;
   for (;;) {
     EXEC SQL FETCH author INTO :name;
     printf("Author '%s' has no URL\n", name);
     printf("enter URL to fix or <cr> to delete: ");
     gets(url);
     if (strcmp(url,"")==0) {
       printf("Deleting '%s'\n",name);
       EXEC SQL DELETE FROM author
                WHERE CURRENT OF author;
     } else {
       printf("Seting URL for '%s' to '%s'\n",name,url);
       EXEC SQL UPDATE author
                SET url = :url
                WHERE CURRENT OF author;
     }
   };
end:
   EXEC SQL CLOSE author;

   EXEC SQL ROLLBACK;
   EXEC SQL CONNECT reset;
   exit(0);

error:
   check_error("My error",&sqlca);
   EXEC SQL WHENEVER SQLERROR CONTINUE;

   EXEC SQL ROLLBACK;
   EXEC SQL CONNECT reset;
   exit(1);
}



// *************************** DYNAMIC *************************************
EXEC SQL INCLUDE SQLCA; 
EXEC SQL INCLUDE SQLDA; 

EXEC SQL BEGIN DECLARE SECTION;
   char  db[6] = "cs348";
   char  sqlstmt[1000];
EXEC SQL END DECLARE SECTION;

struct sqlda *slct;

int main(int argc, char *argv[]) {
   int i, isnull; short type;
   
   printf("Sample C program : ADHOC interactive SQL\n");

   /* bail out on error */
   EXEC SQL WHENEVER SQLERROR  GO TO error;

   /* connect to the database */
   EXEC SQL CONNECT TO :db;
   printf("Connected to DB2\n");

   strncpy(sqlstmt,argv[1],1000);
   printf("Processing <%s>\n",sqlstmt);

   /* compile the sql statement */
   EXEC SQL PREPARE stmt FROM :sqlstmt;

   init_da(&slct,1);

   /* now we find out what it is */
   EXEC SQL DESCRIBE stmt INTO :*slct;

   i= slct->sqld; 
   if (i>0) {
     printf("      ... looks like a query\n");

     /* new SQLDA to hold enough descriptors for answer */
     init_da(&slct,i);

     /* get the names, types, etc... */
     EXEC SQL DESCRIBE stmt INTO :*slct;

     printf("Number of slct variables <%d>\n",slct->sqld);
     for (i=0; i<slct->sqld; i++ ) {
       printf("  variable %d <%.*s (%d%s [%d])>\n",
                    i,
                    slct->sqlvar[i].sqlname.length,
                    slct->sqlvar[i].sqlname.data,
                    slct->sqlvar[i].sqltype, 
                    ( (slct->sqlvar[i].sqltype&1)==1 ? "": " not null"),
                    slct->sqlvar[i].sqllen);
     }
     printf("\n");
     
     /* allocate buffers for the returned tuples */
     for (i=0; i<slct->sqld; i++ ) {
       slct->sqlvar[i].sqldata = malloc(slct->sqlvar[i].sqllen);
       slct->sqlvar[i].sqlind = malloc(sizeof(short));
       *slct->sqlvar[i].sqlind = 0;
     }

     /* and now process the query */
     EXEC SQL DECLARE cstmt CURSOR FOR stmt;
     EXEC SQL OPEN cstmt;
     EXEC SQL WHENEVER NOT FOUND GO TO end;

     /* print the header */
     for (i=0; i<slct->sqld; i++ ) 
       printf("%-*.*s ",slct->sqlvar[i].sqllen, 
                        slct->sqlvar[i].sqlname.length,
                        slct->sqlvar[i].sqlname.data);
     printf("\n");
    
     for (;;) {
       /* fetch next tuple into the prepared buffers */
       EXEC SQL FETCH cstmt USING DESCRIPTOR :*slct;
       for (i=0; i<slct->sqld; i++ ) 
         if ( *(slct->sqlvar[i].sqlind) < 0 ) 
           print_var("NULL",
                     slct->sqlvar[i].sqltype,
                     slct->sqlvar[i].sqlname.length,
                     slct->sqlvar[i].sqllen);
         else
           print_var(slct->sqlvar[i].sqldata,
                     slct->sqlvar[i].sqltype,
                     slct->sqlvar[i].sqlname.length,
                     slct->sqlvar[i].sqllen);
       printf("\n");
       };
   end:
     printf("\n");
   } else {
     printf("      ... looks like an update\n");
     
     EXEC SQL EXECUTE stmt;
   };
   //printf("Rows processed: %d\n",sqlca.sqlerrd[2]);

   /* and get out of here */
   EXEC SQL COMMIT;
   EXEC SQL CONNECT reset;
   exit(0);

error:
   check_error("My error",&sqlca);
   EXEC SQL WHENEVER SQLERROR CONTINUE;

   EXEC SQL ROLLBACK;
   EXEC SQL CONNECT reset;
   exit(1);
}