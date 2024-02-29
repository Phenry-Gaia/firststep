     Fqftpsrc   o    e             disk    rename(qftpsrc:ftpsrc)
     f*
     C     *ENTRY        PLIST
     C                   PARM                    pUSER            10
     C                   PARM                    pPWD             50
     c                   parm                    pobj             10
     c                   parm                    plib             10
     c                   parm                    ptyp             10
     c                   parm                    plibr            10
     c                   parm                    psav             10
     c                   parm                    plibf            10
     c                   parm                    ppub             04
     c*-------------------------------------------------------------------*
     c*                                                                   *
     c* génération du scripte pour envoyer des objets                     *
     c*                                                                   *
     c*-------------------------------------------------------------------*
      /free
         srcdta =  puser + ' ' + ppwd                                      ;
         write ftpsrc                                                      ;
         srcdta =  'lcd ' + plibf                                          ;
         write ftpsrc                                                      ;
         srcdta =  'cd '  + plibf                                          ;
         write ftpsrc                                                      ;
         srcdta =  'bin'                                                   ;
         write ftpsrc                                                      ;
         srcdta =  'QUOTE RCMD CRTSAVF ' + %trim(plibf) + '/' + psav       ;
         write ftpsrc                                                      ;
         srcdta =  'PUT' + ' ' + psav                                      ;
         write ftpsrc                                                      ;
         srcdta =  'QUOTE RCMD RSTOBJ OBJ(' + pobj + ') SAVLIB(' + plib +
         ') DEV(*SAVF) SAVF(' + %trim(plibf) + '/' + psav + ') ' +
                 ' RSTLIB('+ plibr + ')'                                   ;
         write ftpsrc                                                      ;
         srcdta =  'QUOTE RCMD DLTF ' + %trim(plibf) + '/' + psav          ;
         write ftpsrc                                                      ;
          //
          //  droits public *all
          //
         if ppub = '*YES' ;
         srcdta =  'QUOTE RCMD GRTOBJAUT OBJ(' + %trim(plibr) +
         '/' + %trim(pobj) + ') OBJTYPE(' + ptyp +
         ') USER(*PUBLIC) AUT(*ALL)'                                       ;
         write ftpsrc                                                      ;
         endif                                                             ;
         srcdta =  'QUIT'                                                  ;
         write ftpsrc                                                      ;
         *inlr = *on                                                       ;
      /end-free
