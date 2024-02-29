     dsystemeDS       sds
     dinit_user                      10     overlay(systemeDS:254)
     C     *ENTRY        PLIST
     C                   PARM                    psnd             10
     C                   PARM                    psys             80
     C                   PARM                    pUSER            10
     c                   parm                    pobj             10
     c                   parm                    plib             10
     c                   parm                    ptyp             10
     c                   parm                    plibr            10
     c                   parm                    pstatus           2
     c                   parm                    lib01            10
     c*-------------------------------------------------------------------*
     c*                                                                   *
     c* Ecriture dans le fichier historiques des envois                   *
     c*                                                                   *
     c*-------------------------------------------------------------------*
     c/exec sql
     c+  INSERT INTO SNDOBJP VALUES(:psnd   ,
     c+         :psys   , :puser    ,
     c+  :pobj    , :plib    , :ptyp  , :plibr
     c+  , curdate(), curtime(),
     c+  :pstatus, :init_user, :lib01)
     c/end-exec
     C                   eval      *inlr = *on
