     FDSPSMTPE1 cf   e             workstn SFILE(sfl01:cle01)
     d cle01           s              4  0
     d id              s             29
     d rep             s              1
      *
     c     *entry        plist
     c                   parm                    id
     c/free
       exec sql
       declare curs02 cursor for
         select
       translate(substr(joesd, 73, 70), '@', 'à')
         from   logmail
         where substr(joesd, 39, 29) = :id
        ;
       exec sql
         Open curs02
        ;
        // initialisation
        // information du travail
        //
       exec sql
         select JOJOB, JOUSER, JONBR, JOPGM  into
               :JOJOB, :JOUSER, :JONBR, :JOPGM
         from   logmail

         where substr(joesd, 39, 29) = :id
         and( JOESD
         like('%SNDMAIL TO MSF%')
         or
         JOESD
         like('%INTERNETGATEWAY%'))
        ;
        *in40 = *on ;
        cle01 = 0   ;
        write ctl01 ;
        *in40 = *off;
        // chargement
        dou sqlcode <> 0 ;

       exec sql
         fetch curs02 into  :wdetail
        ;

          if        sqlcod =  0   ;
          //mappage des zones
            cle01 = cle01 + 1     ;
            write     sfl01       ;
          endif                   ;
        enddo                     ;
        *in43 = *on ;
        // affichage
        *in42  = *on ;
          if        cle01  >  0   ;
            *in41 =    *on        ;
          else                    ;
            *in41 = *off          ;
          endif                   ;
          write(e)  fmt01         ;
         if %error ;
          dsply 'Données incorrectes' ' ' rep ;
         endif ;
          exfmt(e)  ctl01         ;
         if %error ;
          dsply 'Données incorrectes' ' ' rep ;
         endif ;
       exec sql
         close curs02
        ;
        *inlr = *on;
      /end-free
