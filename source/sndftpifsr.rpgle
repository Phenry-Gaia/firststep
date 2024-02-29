     Fqftpsrc   o    e             disk    rename(qftpsrc:ftpsrc)
     f*
     C     *ENTRY        PLIST
     c                   parm                    psystem          40
     C                   PARM                    pUSER            10
     C                   PARM                    pPWD             50
     c                   parm                    pifs            132
     c                   parm                    prpt            132
     c                   parm                    prptc           132
     c*-------------------------------------------------------------------*
     c*                                                                   *
     c* génération du scripte pour envoyer un fichier IFS                 *
     c*                                                                   *
     c*-------------------------------------------------------------------*
      /free
         srcdta =  puser + ' ' + ppwd                                      ;
         write ftpsrc                                                      ;
      //
          srcdta =  'namefmt 1'                                  ;
          write ftpsrc                                                      ;
      // positionnement dans le répertoire
          srcdta =  'lcd ' + %trim(prpt)                                    ;
          write ftpsrc                                                      ;
          srcdta =  'cd '  + %trim(prptc)                                   ;
          write ftpsrc                                                      ;
       // envoi du fichier
         srcdta =  'Put  ' + pifs                                 ;
         write ftpsrc                                                      ;
       // sortie de FTP
         srcdta =  'QUIT'                                                  ;
         write ftpsrc                                                      ;
       //
         *inlr = *on                                                       ;
      /end-free
