     c*-------------------------------------------------------------------*
     c*                                                                   *
     c* Génération scripte ftp pour envoi bibliothèque                    *
     c*     version  carte c colonnées                                    *
     c*                                                                   *
     c*-------------------------------------------------------------------*
     Fqftpsrc   o    e             disk    rename(qftpsrc:ftpsrc)
     C     *ENTRY        PLIST
     C                   PARM                    pUSER            10
     C                   PARM                    pPWD             50
     c                   parm                    plib             10
     c                   parm                    psav             10
     c                   parm                    plibf            10
     c                   parm                    prst             10
     c                   parm                    ppub              4
     c*-------------------------------------------------------------------*
     c*                                                                   *
     c* generation d'un scripte d'envoi de bibliothèques                  *
     c*                                                                   *
     c*-------------------------------------------------------------------*
      /free
     C                   if        prst = '*SAVLIB'
     c                   eval      prst  = plib
     c                   endif
     c                   eval      srcdta =  puser + ' ' + ppwd
     c                   write     ftpsrc
     c                   eval      srcdta =  'lcd '  + plibf
     c                   write     ftpsrc
     c                   eval      srcdta =  'cd  ' + plibf
     c                   write     ftpsrc
     c                   eval      srcdta =  'bin'
     c                   write     ftpsrc
     c                   eval      srcdta =  'QUOTE RCMD CRTSAVF '
     c                                       + %trim(plibf) + '/' + psav
     c                   write     ftpsrc
     c                   eval      srcdta =  'PUT' +  ' ' + psav
     c                   write     ftpsrc
     c                   eval      srcdta = 'QUOTE RCMD RSTLIB SAVLIB(' + plib +
     c                              ') DEV(*SAVF) SAVF(' + %trim(plibf)
     c                                 + '/' + psav + ')'  + ' ' +
     c                              'RSTLIB(' +  %trim(prst)  + ') '  +
     c                              'FRCOBJCVN(*yes) OUTPUT(*OUTFILE) ' +
     c                              'OUTFILE(GAIA/LSRSTOBJ) OUTMBR(*FIRST *ADD)'
     c                   write     ftpsrc
     c                   eval      srcdta =  'QUOTE RCMD DLTF ' +  %TRIM(plibf)
     c                                       + '/' + psav
     c                   write     ftpsrc
     c*  //
     c*  // Mise en place des droits publics
     c*  //
     c                   if        ppub = '*YES'
     c*  // bibliothèque
     c                   eval      srcdta='QUOTE RCMD GRTOBJAUT OBJ('
     c                                       + %trim(prst ) +
     c                                       '/*ALL) OBJTYPE(*all) ' +
     c                                       'USER(*PUBLIC) AUT(*ALL)'
     c                   write     ftpsrc
     c*  // objets de la bibliothèque
     c                   eval      srcdta =  'QUOTE RCMD GRTOBJAUT OBJ('
     c                             + %trim(prst) +
     c                             ') OBJTYPE(*LIB) USER(*PUBLIC) ' +
     c                                       'AUT(*ALL)'
     c                   write     ftpsrc
     c                   endif
     c                   eval      srcdta =  'QUIT'
     c                   write     ftpsrc
     c                   eval      *inlr = *on
