C                                                                      C
C----------------------------------------------------------------------C
C                                                                      C
C A 23-species reduced model for mixture averaged diffusion for 
C  the 99-species reduced mechanism for iso-octane oxidation
C
C Reference: 
C  C.S. Yoo, Z. Luo, T.F. Lu, H. Kim, J.H. Chen, 
C  �A DNS study of ignition characteristics of a lean iso-octane/air 
C   mixture under HCCI and SACI conditions,� 
C  Proc. Combust. Inst., 34(2) 2985�2993, 2013.
C                                                                      C
C----------------------------------------------------------------------C
C                                                                      C
      SUBROUTINE MCADIF (P, T, XX, RMCWRK, D)
C
      IMPLICIT DOUBLE PRECISION (A-H, O-Z), INTEGER (I-N)
C
      DIMENSION XX(*), D(*), RMCWRK(*)
      DIMENSION X(99), Y(99), WT(99), XXWT(99)
      DIMENSION DG(23,23), XG(23), QG(23)
      DATA WT/1.00797, 2.01594, 15.9994, 31.9988, 
     *  17.0074, 18.0153, 33.0068, 34.0147, 
     *  28.0106, 44.01, 30.0265, 62.0253, 
     *  61.0173, 45.0179, 48.0418, 47.0339, 
     *  16.043, 15.0351, 14.0271, 30.0701, 
     *  29.0622, 28.0542, 27.0462, 26.0382, 
     *  44.0536, 42.0376, 41.0297, 61.061, 
     *  58.0807, 57.0727, 56.0647, 55.0568, 
     *  42.0813, 41.0733, 40.0653, 40.0653, 
     *  39.0574, 107.087, 75.088, 90.0795, 
     *  56.0647, 57.1163, 56.1084, 55.1004, 
     *  89.1151, 89.1151, 90.1231, 72.1078, 
     *  71.0998, 121.114, 104.107, 72.1078, 
     *  71.0998, 70.0918, 69.0839, 70.0918, 
     *  88.1072, 103.099, 71.1434, 70.1355, 
     *  70.1355, 70.1355, 69.1275, 69.1275, 
     *  57.0727, 84.1625, 84.1625, 70.1355, 
     *  55.1004, 98.1896, 98.1896, 97.1817, 
     *  97.1817, 131.196, 82.1466, 81.1386, 
     *  81.1386, 103.142, 86.1349, 114.233, 
     *  112.217, 112.217, 145.223, 145.223, 
     *  145.223, 145.223, 146.231, 128.216, 
     *  128.216, 128.216, 177.222, 177.222, 
     *  177.222, 113.181, 113.181, 177.222, 
     *  160.215, 160.215, 28.0134/
C
      ZERO = 0.0D0
      ALOGT = LOG(T)
      PA = P/1.01325D+06
C
C
      SUMXW = ZERO
      SUMXX = ZERO
      DO K = 1, 99
         X(K) = MAX(XX(K), 1.0D-50)
         SUMXX = SUMXX + X(K)
         XXWT(K) = X(K)*WT(K)
         SUMXW = SUMXW + XXWT(K)
      ENDDO
      DO K = 1, 99
         X(K) = X(K)/SUMXX
         Y(K) = XXWT(K)/SUMXW
      ENDDO
      XG(  1) = +X(  1) 
      XG(  2) = +X(  2) 
      XG(  3) = +X(  3) +X(  5) 
      XG(  4) = +X(  4) +X(  7) +X(  8) +X(  9) +X( 99) 
      XG(  5) = +X(  6) 
      XG(  6) = +X( 10) 
      XG(  7) = +X( 11) 
      XG(  8) = +X( 12) +X( 13) +X( 32) +X( 41) 
      XG(  9) = +X( 14) +X( 15) +X( 16) 
      XG( 10) = +X( 17) +X( 18) +X( 19) 
      XG( 11) = +X( 20) +X( 21) 
      XG( 12) = +X( 22) 
      XG( 13) = +X( 23) +X( 24) 
      XG( 14) = +X( 25) +X( 26) +X( 33) +X( 34) +X( 35) 
     *          +X( 36) +X( 37) 
      XG( 15) = +X( 27) 
      XG( 16) = +X( 38) 
      XG( 17) = +X( 39) +X( 40) 
      XG( 18) = +X( 31) +X( 42) 
      XG( 19) = +X( 50) +X( 80) 
      XG( 20) = +X( 28) +X( 29) +X( 30) +X( 43) +X( 44) 
     *          +X( 65) +X( 69) 
      XG( 21) = +X( 45) +X( 46) +X( 47) +X( 48) +X( 49) 
     *          +X( 52) +X( 53) +X( 54) +X( 55) +X( 56) +X( 57) 
     *          +X( 58) +X( 59) +X( 60) +X( 61) +X( 62) +X( 63) 
     *          +X( 64) +X( 66) +X( 67) +X( 68) +X( 75) +X( 76) 
     *          +X( 77) +X( 78) 
      XG( 22) = +X( 51) +X( 70) +X( 71) +X( 72) +X( 73) 
     *          +X( 79) 
      XG( 23) = +X( 74) +X( 81) +X( 82) +X( 83) +X( 84) 
     *          +X( 85) +X( 86) +X( 87) +X( 88) +X( 89) +X( 90) 
     *          +X( 91) +X( 92) +X( 93) +X( 94) +X( 95) +X( 96) 
     *          +X( 97) +X( 98) 
C
      DG(1,1)=EXP(-14.7654 + ALOGT*(4.19545
     1           +ALOGT*(-0.327962+ALOGT*0.0141239)))
      DG(2,1)=EXP(-11.6869 + ALOGT*(2.88373
     1           +ALOGT*(-0.163778+ALOGT*0.00726587)))
      DG(2,2)=EXP(-10.2307 + ALOGT*(2.1536
     1           +ALOGT*(-0.0696902+ALOGT*0.00323396)))
      DG(3,1)=EXP(-15.003 + ALOGT*(4.13192
     1           +ALOGT*(-0.327534+ALOGT*0.0144276)))
      DG(3,2)=EXP(-10.6011 + ALOGT*(2.15713
     1           +ALOGT*(-0.0652473+ALOGT*0.0028096)))
      DG(3,3)=EXP(-13.295 + ALOGT*(2.93899
     1           +ALOGT*(-0.170601+ALOGT*0.00754736)))
      DG(4,1)=EXP(-17.1949 + ALOGT*(4.8626
     1           +ALOGT*(-0.421591+ALOGT*0.0184637)))
      DG(4,2)=EXP(-12.2869 + ALOGT*(2.73982
     1           +ALOGT*(-0.145591+ALOGT*0.0064967)))
      DG(4,3)=EXP(-14.7436 + ALOGT*(3.35009
     1           +ALOGT*(-0.224538+ALOGT*0.00990653)))
      DG(4,4)=EXP(-15.7917 + ALOGT*(3.57214
     1           +ALOGT*(-0.251847+ALOGT*0.0110253)))
      DG(5,1)=EXP(-16.9518 + ALOGT*(4.4162
     1           +ALOGT*(-0.311489+ALOGT*0.0115966)))
      DG(5,2)=EXP(-17.8721 + ALOGT*(4.90511
     1           +ALOGT*(-0.417387+ALOGT*0.0178885)))
      DG(5,3)=EXP(-18.9455 + ALOGT*(4.93572
     1           +ALOGT*(-0.411406+ALOGT*0.0172332)))
      DG(5,4)=EXP(-20.3613 + ALOGT*(5.19586
     1           +ALOGT*(-0.430122+ALOGT*0.0174494)))
      DG(5,5)=EXP(-13.0121 + ALOGT*(1.42917
     1           +ALOGT*(0.166156+ALOGT*-0.0121432)))
      DG(6,1)=EXP(-17.8842 + ALOGT*(4.849
     1           +ALOGT*(-0.392501+ALOGT*0.016058)))
      DG(6,2)=EXP(-15.3064 + ALOGT*(3.8739
     1           +ALOGT*(-0.295611+ALOGT*0.0131133)))
      DG(6,3)=EXP(-17.584 + ALOGT*(4.33248
     1           +ALOGT*(-0.346489+ALOGT*0.0149528)))
      DG(6,4)=EXP(-18.4755 + ALOGT*(4.47059
     1           +ALOGT*(-0.361214+ALOGT*0.0154654)))
      DG(6,5)=EXP(-19.649 + ALOGT*(4.53678
     1           +ALOGT*(-0.310349+ALOGT*0.0109643)))
      DG(6,6)=EXP(-20.69 + ALOGT*(5.10116
     1           +ALOGT*(-0.426432+ALOGT*0.017631)))
      DG(7,1)=EXP(-16.3246 + ALOGT*(3.98177
     1           +ALOGT*(-0.248387+ALOGT*0.00855709)))
      DG(7,2)=EXP(-17.5385 + ALOGT*(4.69478
     1           +ALOGT*(-0.395831+ALOGT*0.0171833)))
      DG(7,3)=EXP(-19.0912 + ALOGT*(4.83891
     1           +ALOGT*(-0.400101+ALOGT*0.0167861)))
      DG(7,4)=EXP(-20.2 + ALOGT*(5.05853
     1           +ALOGT*(-0.423908+ALOGT*0.0176406)))
      DG(7,5)=EXP(-18.3315 + ALOGT*(3.85052
     1           +ALOGT*(-0.200511+ALOGT*0.00547775)))
      DG(7,6)=EXP(-21.2408 + ALOGT*(5.14638
     1           +ALOGT*(-0.408582+ALOGT*0.0159502)))
      DG(7,7)=EXP(-19.5182 + ALOGT*(4.21316
     1           +ALOGT*(-0.254686+ALOGT*0.0080629)))
      DG(8,1)=EXP(-16.1264 + ALOGT*(3.85756
     1           +ALOGT*(-0.231602+ALOGT*0.00778343)))
      DG(8,2)=EXP(-17.3997 + ALOGT*(4.60341
     1           +ALOGT*(-0.384759+ALOGT*0.0167341)))
      DG(8,3)=EXP(-19.1333 + ALOGT*(4.78209
     1           +ALOGT*(-0.392763+ALOGT*0.0164589)))
      DG(8,4)=EXP(-20.0832 + ALOGT*(4.92948
     1           +ALOGT*(-0.408328+ALOGT*0.017003)))
      DG(8,5)=EXP(-18.5606 + ALOGT*(3.89757
     1           +ALOGT*(-0.211355+ALOGT*0.00614816)))
      DG(8,6)=EXP(-21.4081 + ALOGT*(5.14334
     1           +ALOGT*(-0.412389+ALOGT*0.0162682)))
      DG(8,7)=EXP(-20.1548 + ALOGT*(4.42251
     1           +ALOGT*(-0.288096+ALOGT*0.00975095)))
      DG(8,8)=EXP(-21.0335 + ALOGT*(4.7114
     1           +ALOGT*(-0.332619+ALOGT*0.0119269)))
      DG(9,1)=EXP(-16.2013 + ALOGT*(3.92213
     1           +ALOGT*(-0.239342+ALOGT*0.00811062)))
      DG(9,2)=EXP(-17.6358 + ALOGT*(4.72962
     1           +ALOGT*(-0.400415+ALOGT*0.0173839)))
      DG(9,3)=EXP(-19.1507 + ALOGT*(4.8273
     1           +ALOGT*(-0.396936+ALOGT*0.0165768)))
      DG(9,4)=EXP(-20.2637 + ALOGT*(5.04248
     1           +ALOGT*(-0.421228+ALOGT*0.0174988)))
      DG(9,5)=EXP(-18.259 + ALOGT*(3.79397
     1           +ALOGT*(-0.193162+ALOGT*0.00517866)))
      DG(9,6)=EXP(-21.4487 + ALOGT*(5.18955
     1           +ALOGT*(-0.414854+ALOGT*0.0162482)))
      DG(9,7)=EXP(-19.5549 + ALOGT*(4.19027
     1           +ALOGT*(-0.251552+ALOGT*0.00792477)))
      DG(9,8)=EXP(-20.4569 + ALOGT*(4.49743
     1           +ALOGT*(-0.298561+ALOGT*0.010225)))
      DG(9,9)=EXP(-19.7207 + ALOGT*(4.21316
     1           +ALOGT*(-0.254686+ALOGT*0.0080629)))
      DG(10,1)=EXP(-17.5051 + ALOGT*(4.87978
     1           +ALOGT*(-0.41593+ALOGT*0.0178838)))
      DG(10,2)=EXP(-13.1378 + ALOGT*(3.04616
     1           +ALOGT*(-0.186319+ALOGT*0.00830318)))
      DG(10,3)=EXP(-15.2948 + ALOGT*(3.56392
     1           +ALOGT*(-0.250886+ALOGT*0.010988)))
      DG(10,4)=EXP(-16.6474 + ALOGT*(3.93425
     1           +ALOGT*(-0.297575+ALOGT*0.0129521)))
      DG(10,5)=EXP(-20.5869 + ALOGT*(5.21875
     1           +ALOGT*(-0.424086+ALOGT*0.0168444)))
      DG(10,6)=EXP(-19.1265 + ALOGT*(4.72733
     1           +ALOGT*(-0.388642+ALOGT*0.0164115)))
      DG(10,7)=EXP(-20.473 + ALOGT*(5.12436
     1           +ALOGT*(-0.423122+ALOGT*0.0172354)))
      DG(10,8)=EXP(-20.0491 + ALOGT*(4.88767
     1           +ALOGT*(-0.391949+ALOGT*0.0158531)))
      DG(10,9)=EXP(-20.3317 + ALOGT*(5.02988
     1           +ALOGT*(-0.408725+ALOGT*0.0165219)))
      DG(10,10)=EXP(-17.2381 + ALOGT*(4.1569
     1           +ALOGT*(-0.323617+ALOGT*0.0139629)))
      DG(11,1)=EXP(-18.2119 + ALOGT*(4.88225
     1           +ALOGT*(-0.393586+ALOGT*0.0159646)))
      DG(11,2)=EXP(-15.7435 + ALOGT*(3.98933
     1           +ALOGT*(-0.31134+ALOGT*0.0138257)))
      DG(11,3)=EXP(-17.6456 + ALOGT*(4.30992
     1           +ALOGT*(-0.343474+ALOGT*0.0148195)))
      DG(11,4)=EXP(-18.565 + ALOGT*(4.47809
     1           +ALOGT*(-0.362155+ALOGT*0.0155057)))
      DG(11,5)=EXP(-20.2157 + ALOGT*(4.79098
     1           +ALOGT*(-0.352491+ALOGT*0.0131414)))
      DG(11,6)=EXP(-20.7305 + ALOGT*(5.09266
     1           +ALOGT*(-0.424571+ALOGT*0.0175194)))
      DG(11,7)=EXP(-21.369 + ALOGT*(5.16819
     1           +ALOGT*(-0.411307+ALOGT*0.0160647)))
      DG(11,8)=EXP(-21.2829 + ALOGT*(5.0701
     1           +ALOGT*(-0.401139+ALOGT*0.0157111)))
      DG(11,9)=EXP(-21.4219 + ALOGT*(5.15105
     1           +ALOGT*(-0.408782+ALOGT*0.0159431)))
      DG(11,10)=EXP(-19.2367 + ALOGT*(4.73522
     1           +ALOGT*(-0.389957+ALOGT*0.0164822)))
      DG(11,11)=EXP(-20.836 + ALOGT*(5.1115
     1           +ALOGT*(-0.426957+ALOGT*0.0176213)))
      DG(12,1)=EXP(-17.6603 + ALOGT*(4.82032
     1           +ALOGT*(-0.39157+ALOGT*0.0161384)))
      DG(12,2)=EXP(-14.9053 + ALOGT*(3.74801
     1           +ALOGT*(-0.278572+ALOGT*0.0123462)))
      DG(12,3)=EXP(-17.2383 + ALOGT*(4.26588
     1           +ALOGT*(-0.339094+ALOGT*0.0146874)))
      DG(12,4)=EXP(-18.1525 + ALOGT*(4.41848
     1           +ALOGT*(-0.35472+ALOGT*0.0151954)))
      DG(12,5)=EXP(-20.2508 + ALOGT*(4.94097
     1           +ALOGT*(-0.375286+ALOGT*0.0142529)))
      DG(12,6)=EXP(-20.3882 + ALOGT*(5.05908
     1           +ALOGT*(-0.420525+ALOGT*0.0173531)))
      DG(12,7)=EXP(-21.1101 + ALOGT*(5.17528
     1           +ALOGT*(-0.413455+ALOGT*0.0162016)))
      DG(12,8)=EXP(-20.846 + ALOGT*(4.99572
     1           +ALOGT*(-0.391406+ALOGT*0.0152833)))
      DG(12,9)=EXP(-21.0379 + ALOGT*(5.10399
     1           +ALOGT*(-0.403009+ALOGT*0.0157009)))
      DG(12,10)=EXP(-18.8634 + ALOGT*(4.69169
     1           +ALOGT*(-0.385543+ALOGT*0.0163431)))
      DG(12,11)=EXP(-20.5234 + ALOGT*(5.08493
     1           +ALOGT*(-0.424248+ALOGT*0.0175325)))
      DG(12,12)=EXP(-20.2541 + ALOGT*(5.08873
     1           +ALOGT*(-0.426085+ALOGT*0.0176649)))
      DG(13,1)=EXP(-17.587 + ALOGT*(4.71165
     1           +ALOGT*(-0.37151+ALOGT*0.0150226)))
      DG(13,2)=EXP(-15.2345 + ALOGT*(3.83567
     1           +ALOGT*(-0.288421+ALOGT*0.0127053)))
      DG(13,3)=EXP(-17.4385 + ALOGT*(4.29852
     1           +ALOGT*(-0.341162+ALOGT*0.0146863)))
      DG(13,4)=EXP(-18.5492 + ALOGT*(4.53738
     1           +ALOGT*(-0.368833+ALOGT*0.0157549)))
      DG(13,5)=EXP(-20.2694 + ALOGT*(4.88247
     1           +ALOGT*(-0.363615+ALOGT*0.0135993)))
      DG(13,6)=EXP(-20.6235 + ALOGT*(5.10259
     1           +ALOGT*(-0.423202+ALOGT*0.0173528)))
      DG(13,7)=EXP(-21.1029 + ALOGT*(5.11133
     1           +ALOGT*(-0.400957+ALOGT*0.0155032)))
      DG(13,8)=EXP(-20.9671 + ALOGT*(4.98979
     1           +ALOGT*(-0.387134+ALOGT*0.0149687)))
      DG(13,9)=EXP(-21.0435 + ALOGT*(5.04689
     1           +ALOGT*(-0.391576+ALOGT*0.0150565)))
      DG(13,10)=EXP(-19.1987 + ALOGT*(4.77982
     1           +ALOGT*(-0.394825+ALOGT*0.0166583)))
      DG(13,11)=EXP(-20.787 + ALOGT*(5.14138
     1           +ALOGT*(-0.428712+ALOGT*0.0176142)))
      DG(13,12)=EXP(-20.4862 + ALOGT*(5.12932
     1           +ALOGT*(-0.428363+ALOGT*0.0176462)))
      DG(13,13)=EXP(-20.7833 + ALOGT*(5.19602
     1           +ALOGT*(-0.434085+ALOGT*0.0177803)))
      DG(14,1)=EXP(-16.2138 + ALOGT*(3.90041
     1           +ALOGT*(-0.238213+ALOGT*0.00811399)))
      DG(14,2)=EXP(-17.3307 + ALOGT*(4.57826
     1           +ALOGT*(-0.381459+ALOGT*0.01659)))
      DG(14,3)=EXP(-19.0379 + ALOGT*(4.76795
     1           +ALOGT*(-0.392114+ALOGT*0.0164829)))
      DG(14,4)=EXP(-20.0623 + ALOGT*(4.95501
     1           +ALOGT*(-0.41287+ALOGT*0.0172528)))
      DG(14,5)=EXP(-18.7257 + ALOGT*(3.98548
     1           +ALOGT*(-0.22336+ALOGT*0.00667548)))
      DG(14,6)=EXP(-21.4262 + ALOGT*(5.18656
     1           +ALOGT*(-0.418761+ALOGT*0.0165753)))
      DG(14,7)=EXP(-20.246 + ALOGT*(4.4883
     1           +ALOGT*(-0.297286+ALOGT*0.0101673)))
      DG(14,8)=EXP(-20.8779 + ALOGT*(4.6842
     1           +ALOGT*(-0.328756+ALOGT*0.011748)))
      DG(14,9)=EXP(-20.4405 + ALOGT*(4.52426
     1           +ALOGT*(-0.302306+ALOGT*0.0103945)))
      DG(14,10)=EXP(-20.1617 + ALOGT*(4.96033
     1           +ALOGT*(-0.403215+ALOGT*0.0164188)))
      DG(14,11)=EXP(-21.403 + ALOGT*(5.15189
     1           +ALOGT*(-0.413171+ALOGT*0.01629)))
      DG(14,12)=EXP(-21.0394 + ALOGT*(5.10935
     1           +ALOGT*(-0.408146+ALOGT*0.0160893)))
      DG(14,13)=EXP(-21.1623 + ALOGT*(5.1029
     1           +ALOGT*(-0.4037+ALOGT*0.0157621)))
      DG(14,14)=EXP(-20.8624 + ALOGT*(4.7114
     1           +ALOGT*(-0.332619+ALOGT*0.0119269)))
      DG(15,1)=EXP(-16.5253 + ALOGT*(4.66868
     1           +ALOGT*(-0.388181+ALOGT*0.0166727)))
      DG(15,2)=EXP(-12.7251 + ALOGT*(3.02549
     1           +ALOGT*(-0.183162+ALOGT*0.0081467)))
      DG(15,3)=EXP(-15.4794 + ALOGT*(3.73432
     1           +ALOGT*(-0.27349+ALOGT*0.011987)))
      DG(15,4)=EXP(-16.5664 + ALOGT*(3.93932
     1           +ALOGT*(-0.297302+ALOGT*0.0129017)))
      DG(15,5)=EXP(-19.9108 + ALOGT*(5.08521
     1           +ALOGT*(-0.410859+ALOGT*0.0164261)))
      DG(15,6)=EXP(-19.1353 + ALOGT*(4.75125
     1           +ALOGT*(-0.39156+ALOGT*0.0165348)))
      DG(15,7)=EXP(-20.6137 + ALOGT*(5.22013
     1           +ALOGT*(-0.435386+ALOGT*0.0177667)))
      DG(15,8)=EXP(-20.3285 + ALOGT*(5.00412
     1           +ALOGT*(-0.407529+ALOGT*0.0165521)))
      DG(15,9)=EXP(-20.6448 + ALOGT*(5.18475
     1           +ALOGT*(-0.429976+ALOGT*0.0174978)))
      DG(15,10)=EXP(-17.326 + ALOGT*(4.25468
     1           +ALOGT*(-0.335474+ALOGT*0.0144408)))
      DG(15,11)=EXP(-19.257 + ALOGT*(4.76671
     1           +ALOGT*(-0.393484+ALOGT*0.0166153)))
      DG(15,12)=EXP(-18.9043 + ALOGT*(4.75122
     1           +ALOGT*(-0.392619+ALOGT*0.0166245)))
      DG(15,13)=EXP(-19.2577 + ALOGT*(4.84293
     1           +ALOGT*(-0.402345+ALOGT*0.0169586)))
      DG(15,14)=EXP(-20.4315 + ALOGT*(5.08844
     1           +ALOGT*(-0.420551+ALOGT*0.0172042)))
      DG(15,15)=EXP(-17.2131 + ALOGT*(4.26376
     1           +ALOGT*(-0.336031+ALOGT*0.0144409)))
      DG(16,1)=EXP(-15.3955 + ALOGT*(3.40576
     1           +ALOGT*(-0.161629+ALOGT*0.00427365)))
      DG(16,2)=EXP(-18.5688 + ALOGT*(4.98471
     1           +ALOGT*(-0.434162+ALOGT*0.0188688)))
      DG(16,3)=EXP(-19.5394 + ALOGT*(4.82665
     1           +ALOGT*(-0.395326+ALOGT*0.0164281)))
      DG(16,4)=EXP(-20.5222 + ALOGT*(4.96183
     1           +ALOGT*(-0.407192+ALOGT*0.0167303)))
      DG(16,5)=EXP(-15.9417 + ALOGT*(2.5536
     1           +ALOGT*(-0.0133735+ALOGT*-0.00320928)))
      DG(16,6)=EXP(-21.2096 + ALOGT*(4.90674
     1           +ALOGT*(-0.37478+ALOGT*0.0143655)))
      DG(16,7)=EXP(-19.9555 + ALOGT*(4.23131
     1           +ALOGT*(-0.261448+ALOGT*0.00854658)))
      DG(16,8)=EXP(-21.0848 + ALOGT*(4.61063
     1           +ALOGT*(-0.318366+ALOGT*0.0112691)))
      DG(16,9)=EXP(-20.3651 + ALOGT*(4.34216
     1           +ALOGT*(-0.276933+ALOGT*0.00924792)))
      DG(16,10)=EXP(-20.1958 + ALOGT*(4.8077
     1           +ALOGT*(-0.374691+ALOGT*0.014823)))
      DG(16,11)=EXP(-20.9669 + ALOGT*(4.82468
     1           +ALOGT*(-0.365115+ALOGT*0.0139811)))
      DG(16,12)=EXP(-20.3844 + ALOGT*(4.67824
     1           +ALOGT*(-0.344703+ALOGT*0.0130371)))
      DG(16,13)=EXP(-20.5151 + ALOGT*(4.68166
     1           +ALOGT*(-0.342078+ALOGT*0.0128133)))
      DG(16,14)=EXP(-20.7271 + ALOGT*(4.50536
     1           +ALOGT*(-0.303415+ALOGT*0.0105767)))
      DG(16,15)=EXP(-19.9614 + ALOGT*(4.69222
     1           +ALOGT*(-0.359504+ALOGT*0.0141524)))
      DG(16,16)=EXP(-20.0598 + ALOGT*(3.96194
     1           +ALOGT*(-0.220165+ALOGT*0.00650316)))
      DG(17,1)=EXP(-14.752 + ALOGT*(3.05137
     1           +ALOGT*(-0.107644+ALOGT*0.00161633)))
      DG(17,2)=EXP(-19.1363 + ALOGT*(5.17379
     1           +ALOGT*(-0.459037+ALOGT*0.0199584)))
      DG(17,3)=EXP(-19.5031 + ALOGT*(4.75415
     1           +ALOGT*(-0.382702+ALOGT*0.0157493)))
      DG(17,4)=EXP(-20.5342 + ALOGT*(4.92793
     1           +ALOGT*(-0.401369+ALOGT*0.0164227)))
      DG(17,5)=EXP(-16.3225 + ALOGT*(2.71802
     1           +ALOGT*(-0.0403067+ALOGT*-0.00182588)))
      DG(17,6)=EXP(-21.3685 + ALOGT*(4.93836
     1           +ALOGT*(-0.378252+ALOGT*0.0144981)))
      DG(17,7)=EXP(-19.8305 + ALOGT*(4.13088
     1           +ALOGT*(-0.245685+ALOGT*0.00776691)))
      DG(17,8)=EXP(-21.0367 + ALOGT*(4.54833
     1           +ALOGT*(-0.307671+ALOGT*0.0107099)))
      DG(17,9)=EXP(-20.2304 + ALOGT*(4.23978
     1           +ALOGT*(-0.260763+ALOGT*0.00844181)))
      DG(17,10)=EXP(-20.2084 + ALOGT*(4.77013
     1           +ALOGT*(-0.368232+ALOGT*0.0144835)))
      DG(17,11)=EXP(-21.1347 + ALOGT*(4.85183
     1           +ALOGT*(-0.36714+ALOGT*0.014018)))
      DG(17,12)=EXP(-20.3763 + ALOGT*(4.6237
     1           +ALOGT*(-0.334782+ALOGT*0.0124969)))
      DG(17,13)=EXP(-20.6435 + ALOGT*(4.68933
     1           +ALOGT*(-0.341433+ALOGT*0.0127301)))
      DG(17,14)=EXP(-20.7061 + ALOGT*(4.45233
     1           +ALOGT*(-0.294111+ALOGT*0.0100864)))
      DG(17,15)=EXP(-20.1041 + ALOGT*(4.70406
     1           +ALOGT*(-0.359435+ALOGT*0.0140911)))
      DG(17,16)=EXP(-20.1264 + ALOGT*(3.98885
     1           +ALOGT*(-0.225172+ALOGT*0.00677662)))
      DG(17,17)=EXP(-20.1717 + ALOGT*(3.99265
     1           +ALOGT*(-0.225598+ALOGT*0.00679291)))
      DG(18,1)=EXP(-16.5174 + ALOGT*(3.85978
     1           +ALOGT*(-0.228529+ALOGT*0.00747161)))
      DG(18,2)=EXP(-17.8862 + ALOGT*(4.70659
     1           +ALOGT*(-0.402295+ALOGT*0.0176661)))
      DG(18,3)=EXP(-19.3433 + ALOGT*(4.77439
     1           +ALOGT*(-0.395615+ALOGT*0.0167351)))
      DG(18,4)=EXP(-19.9029 + ALOGT*(4.7844
     1           +ALOGT*(-0.393595+ALOGT*0.016526)))
      DG(18,5)=EXP(-18.8459 + ALOGT*(3.93446
     1           +ALOGT*(-0.221223+ALOGT*0.00674668)))
      DG(18,6)=EXP(-21.4701 + ALOGT*(5.12092
     1           +ALOGT*(-0.415993+ALOGT*0.0166679)))
      DG(18,7)=EXP(-20.7065 + ALOGT*(4.60349
     1           +ALOGT*(-0.319635+ALOGT*0.0114073)))
      DG(18,8)=EXP(-21.779 + ALOGT*(4.98933
     1           +ALOGT*(-0.378637+ALOGT*0.0142927)))
      DG(18,9)=EXP(-21.1515 + ALOGT*(4.74362
     1           +ALOGT*(-0.339633+ALOGT*0.0123386)))
      DG(18,10)=EXP(-20.0666 + ALOGT*(4.82865
     1           +ALOGT*(-0.389002+ALOGT*0.0159045)))
      DG(18,11)=EXP(-21.3708 + ALOGT*(5.06666
     1           +ALOGT*(-0.407546+ALOGT*0.0162473)))
      DG(18,12)=EXP(-20.8364 + ALOGT*(4.93111
     1           +ALOGT*(-0.388321+ALOGT*0.0153412)))
      DG(18,13)=EXP(-20.9119 + ALOGT*(4.91201
     1           +ALOGT*(-0.382439+ALOGT*0.014958)))
      DG(18,14)=EXP(-21.5623 + ALOGT*(4.93348
     1           +ALOGT*(-0.3706+ALOGT*0.0139148)))
      DG(18,15)=EXP(-20.2966 + ALOGT*(4.90595
     1           +ALOGT*(-0.399219+ALOGT*0.0163594)))
      DG(18,16)=EXP(-21.9047 + ALOGT*(4.93199
     1           +ALOGT*(-0.370416+ALOGT*0.0139068)))
      DG(18,17)=EXP(-21.8938 + ALOGT*(4.88916
     1           +ALOGT*(-0.362416+ALOGT*0.0134697)))
      DG(18,18)=EXP(-22.2594 + ALOGT*(5.17252
     1           +ALOGT*(-0.411761+ALOGT*0.01608)))
      DG(19,1)=EXP(-11.0969 + ALOGT*(1.22371
     1           +ALOGT*(0.16682+ALOGT*-0.0117744)))
      DG(19,2)=EXP(-20.4001 + ALOGT*(5.52415
     1           +ALOGT*(-0.498414+ALOGT*0.0213965)))
      DG(19,3)=EXP(-19.363 + ALOGT*(4.46108
     1           +ALOGT*(-0.32782+ALOGT*0.0126726)))
      DG(19,4)=EXP(-20.241 + ALOGT*(4.60167
     1           +ALOGT*(-0.345777+ALOGT*0.0134724)))
      DG(19,5)=EXP(-17.4084 + ALOGT*(3.08766
     1           +ALOGT*(-0.0964673+ALOGT*0.00100672)))
      DG(19,6)=EXP(-20.7269 + ALOGT*(4.47155
     1           +ALOGT*(-0.305067+ALOGT*0.0108544)))
      DG(19,7)=EXP(-18.9281 + ALOGT*(3.56592
     1           +ALOGT*(-0.161674+ALOGT*0.00380106)))
      DG(19,8)=EXP(-20.1294 + ALOGT*(3.96329
     1           +ALOGT*(-0.21877+ALOGT*0.00640782)))
      DG(19,9)=EXP(-19.2354 + ALOGT*(3.62666
     1           +ALOGT*(-0.169364+ALOGT*0.00410031)))
      DG(19,10)=EXP(-19.4674 + ALOGT*(4.2665
     1           +ALOGT*(-0.288497+ALOGT*0.0104537)))
      DG(19,11)=EXP(-20.5519 + ALOGT*(4.4029
     1           +ALOGT*(-0.294761+ALOGT*0.0103545)))
      DG(19,12)=EXP(-19.7718 + ALOGT*(4.15966
     1           +ALOGT*(-0.260604+ALOGT*0.0087736)))
      DG(19,13)=EXP(-19.7983 + ALOGT*(4.12449
     1           +ALOGT*(-0.253003+ALOGT*0.00834048)))
      DG(19,14)=EXP(-19.8204 + ALOGT*(3.88419
     1           +ALOGT*(-0.208081+ALOGT*0.00594552)))
      DG(19,15)=EXP(-19.0906 + ALOGT*(4.02835
     1           +ALOGT*(-0.251873+ALOGT*0.00864203)))
      DG(19,16)=EXP(-20.7245 + ALOGT*(4.08839
     1           +ALOGT*(-0.23576+ALOGT*0.00714693)))
      DG(19,17)=EXP(-20.4301 + ALOGT*(3.93521
     1           +ALOGT*(-0.212622+ALOGT*0.00602981)))
      DG(19,18)=EXP(-21.2458 + ALOGT*(4.41824
     1           +ALOGT*(-0.288144+ALOGT*0.00977281)))
      DG(19,19)=EXP(-18.9798 + ALOGT*(3.12917
     1           +ALOGT*(-0.0930837+ALOGT*0.000300422)))
      DG(20,1)=EXP(-16.1763 + ALOGT*(3.78308
     1           +ALOGT*(-0.219388+ALOGT*0.00712835)))
      DG(20,2)=EXP(-17.873 + ALOGT*(4.74595
     1           +ALOGT*(-0.406864+ALOGT*0.0178427)))
      DG(20,3)=EXP(-19.3977 + ALOGT*(4.83855
     1           +ALOGT*(-0.402988+ALOGT*0.0170179)))
      DG(20,4)=EXP(-19.9576 + ALOGT*(4.83812
     1           +ALOGT*(-0.398795+ALOGT*0.0166823)))
      DG(20,5)=EXP(-18.9235 + ALOGT*(4.00328
     1           +ALOGT*(-0.228968+ALOGT*0.00705081)))
      DG(20,6)=EXP(-21.4584 + ALOGT*(5.13827
     1           +ALOGT*(-0.41552+ALOGT*0.0165453)))
      DG(20,7)=EXP(-20.5487 + ALOGT*(4.55895
     1           +ALOGT*(-0.310638+ALOGT*0.0109028)))
      DG(20,8)=EXP(-21.4693 + ALOGT*(4.87495
     1           +ALOGT*(-0.359373+ALOGT*0.0132918)))
      DG(20,9)=EXP(-20.9094 + ALOGT*(4.66169
     1           +ALOGT*(-0.325172+ALOGT*0.011572)))
      DG(20,10)=EXP(-20.0788 + ALOGT*(4.86205
     1           +ALOGT*(-0.391412+ALOGT*0.0159367)))
      DG(20,11)=EXP(-21.3863 + ALOGT*(5.09214
     1           +ALOGT*(-0.40823+ALOGT*0.0161794)))
      DG(20,12)=EXP(-20.8383 + ALOGT*(4.9589
     1           +ALOGT*(-0.389708+ALOGT*0.0153206)))
      DG(20,13)=EXP(-20.9287 + ALOGT*(4.94114
     1           +ALOGT*(-0.383621+ALOGT*0.0149134)))
      DG(20,14)=EXP(-21.2923 + ALOGT*(4.83668
     1           +ALOGT*(-0.353894+ALOGT*0.0130356)))
      DG(20,15)=EXP(-20.2976 + ALOGT*(4.94372
     1           +ALOGT*(-0.402262+ALOGT*0.0164218)))
      DG(20,16)=EXP(-21.5318 + ALOGT*(4.78647
     1           +ALOGT*(-0.34674+ALOGT*0.0127019)))
      DG(20,17)=EXP(-21.4478 + ALOGT*(4.71068
     1           +ALOGT*(-0.334113+ALOGT*0.0120505)))
      DG(20,18)=EXP(-21.9919 + ALOGT*(5.06819
     1           +ALOGT*(-0.393657+ALOGT*0.0151207)))
      DG(20,19)=EXP(-20.7686 + ALOGT*(4.22582
     1           +ALOGT*(-0.258538+ALOGT*0.00832831)))
      DG(20,20)=EXP(-21.8692 + ALOGT*(5.02943
     1           +ALOGT*(-0.385017+ALOGT*0.0146138)))
      DG(21,1)=EXP(-14.7431 + ALOGT*(2.98417
     1           +ALOGT*(-0.0960969+ALOGT*0.000976728)))
      DG(21,2)=EXP(-18.8121 + ALOGT*(5.01283
     1           +ALOGT*(-0.439011+ALOGT*0.019124)))
      DG(21,3)=EXP(-19.7791 + ALOGT*(4.84157
     1           +ALOGT*(-0.396639+ALOGT*0.0164558)))
      DG(21,4)=EXP(-20.2987 + ALOGT*(4.82918
     1           +ALOGT*(-0.391975+ALOGT*0.016149)))
      DG(21,5)=EXP(-18.341 + ALOGT*(3.62364
     1           +ALOGT*(-0.174601+ALOGT*0.00456463)))
      DG(21,6)=EXP(-21.3498 + ALOGT*(4.93953
     1           +ALOGT*(-0.383111+ALOGT*0.0148834)))
      DG(21,7)=EXP(-20.0527 + ALOGT*(4.20933
     1           +ALOGT*(-0.258725+ALOGT*0.00842814)))
      DG(21,8)=EXP(-21.3325 + ALOGT*(4.66831
     1           +ALOGT*(-0.327229+ALOGT*0.011704)))
      DG(21,9)=EXP(-20.5354 + ALOGT*(4.3568
     1           +ALOGT*(-0.279425+ALOGT*0.00937232)))
      DG(21,10)=EXP(-19.9708 + ALOGT*(4.67285
     1           +ALOGT*(-0.359238+ALOGT*0.0142303)))
      DG(21,11)=EXP(-21.1509 + ALOGT*(4.84909
     1           +ALOGT*(-0.369353+ALOGT*0.0142065)))
      DG(21,12)=EXP(-20.414 + ALOGT*(4.62376
     1           +ALOGT*(-0.337159+ALOGT*0.012684)))
      DG(21,13)=EXP(-20.6468 + ALOGT*(4.67581
     1           +ALOGT*(-0.341868+ALOGT*0.0128246)))
      DG(21,14)=EXP(-20.9852 + ALOGT*(4.56275
     1           +ALOGT*(-0.312223+ALOGT*0.0110086)))
      DG(21,15)=EXP(-20.1053 + ALOGT*(4.68254
     1           +ALOGT*(-0.358714+ALOGT*0.0141363)))
      DG(21,16)=EXP(-21.7741 + ALOGT*(4.74035
     1           +ALOGT*(-0.337525+ALOGT*0.0121832)))
      DG(21,17)=EXP(-21.6853 + ALOGT*(4.66704
     1           +ALOGT*(-0.325149+ALOGT*0.0115414)))
      DG(21,18)=EXP(-22.1344 + ALOGT*(4.99105
     1           +ALOGT*(-0.379553+ALOGT*0.0143587)))
      DG(21,19)=EXP(-20.8684 + ALOGT*(4.12526
     1           +ALOGT*(-0.241585+ALOGT*0.00743936)))
      DG(21,20)=EXP(-21.79 + ALOGT*(4.85348
     1           +ALOGT*(-0.356954+ALOGT*0.0132017)))
      DG(21,21)=EXP(-21.9526 + ALOGT*(4.7836
     1           +ALOGT*(-0.344321+ALOGT*0.0125219)))
      DG(22,1)=EXP(-13.6126 + ALOGT*(2.41565
     1           +ALOGT*(-0.0100132+ALOGT*-0.00324666)))
      DG(22,2)=EXP(-20.0155 + ALOGT*(5.45467
     1           +ALOGT*(-0.496338+ALOGT*0.0216052)))
      DG(22,3)=EXP(-19.7812 + ALOGT*(4.76868
     1           +ALOGT*(-0.381536+ALOGT*0.0155671)))
      DG(22,4)=EXP(-20.5876 + ALOGT*(4.86974
     1           +ALOGT*(-0.392007+ALOGT*0.0159396)))
      DG(22,5)=EXP(-16.8175 + ALOGT*(2.89041
     1           +ALOGT*(-0.0688121+ALOGT*-0.000341754)))
      DG(22,6)=EXP(-21.3264 + ALOGT*(4.84619
     1           +ALOGT*(-0.364689+ALOGT*0.0138465)))
      DG(22,7)=EXP(-19.7053 + ALOGT*(3.99886
     1           +ALOGT*(-0.226595+ALOGT*0.00687591)))
      DG(22,8)=EXP(-21.0954 + ALOGT*(4.49885
     1           +ALOGT*(-0.300064+ALOGT*0.0103412)))
      DG(22,9)=EXP(-20.15 + ALOGT*(4.12735
     1           +ALOGT*(-0.244346+ALOGT*0.00766848)))
      DG(22,10)=EXP(-20.0835 + ALOGT*(4.63595
     1           +ALOGT*(-0.347998+ALOGT*0.013488)))
      DG(22,11)=EXP(-21.0956 + ALOGT*(4.75756
     1           +ALOGT*(-0.352564+ALOGT*0.0132946)))
      DG(22,12)=EXP(-20.3769 + ALOGT*(4.54031
     1           +ALOGT*(-0.321875+ALOGT*0.0118619)))
      DG(22,13)=EXP(-20.4703 + ALOGT*(4.53163
     1           +ALOGT*(-0.317756+ALOGT*0.011578)))
      DG(22,14)=EXP(-20.7505 + ALOGT*(4.39623
     1           +ALOGT*(-0.285633+ALOGT*0.00968155)))
      DG(22,15)=EXP(-20.0151 + ALOGT*(4.56503
     1           +ALOGT*(-0.337336+ALOGT*0.0129652)))
      DG(22,16)=EXP(-20.5364 + ALOGT*(4.11914
     1           +ALOGT*(-0.244947+ALOGT*0.00773834)))
      DG(22,17)=EXP(-20.5209 + ALOGT*(4.0911
     1           +ALOGT*(-0.240163+ALOGT*0.00748893)))
      DG(22,18)=EXP(-21.9139 + ALOGT*(4.82996
     1           +ALOGT*(-0.353184+ALOGT*0.0130109)))
      DG(22,19)=EXP(-20.4585 + ALOGT*(3.88672
     1           +ALOGT*(-0.205072+ALOGT*0.00565508)))
      DG(22,20)=EXP(-21.5236 + ALOGT*(4.67299
     1           +ALOGT*(-0.328098+ALOGT*0.0117515)))
      DG(22,21)=EXP(-21.7124 + ALOGT*(4.61371
     1           +ALOGT*(-0.316822+ALOGT*0.0111276)))
      DG(22,22)=EXP(-20.7476 + ALOGT*(4.13342
     1           +ALOGT*(-0.246043+ALOGT*0.00775524)))
      DG(23,1)=EXP(-10.4283 + ALOGT*(0.863653
     1           +ALOGT*(0.22119+ALOGT*-0.0144492)))
      DG(23,2)=EXP(-20.8923 + ALOGT*(5.67956
     1           +ALOGT*(-0.518772+ALOGT*0.0222831)))
      DG(23,3)=EXP(-19.61 + ALOGT*(4.50773
     1           +ALOGT*(-0.332453+ALOGT*0.0128019)))
      DG(23,4)=EXP(-20.1903 + ALOGT*(4.53072
     1           +ALOGT*(-0.335034+ALOGT*0.0129409)))
      DG(23,5)=EXP(-16.9896 + ALOGT*(2.87961
     1           +ALOGT*(-0.0702122+ALOGT*-5.15837e-005)))
      DG(23,6)=EXP(-20.6282 + ALOGT*(4.38709
     1           +ALOGT*(-0.293293+ALOGT*0.0103126)))
      DG(23,7)=EXP(-19.0083 + ALOGT*(3.56606
     1           +ALOGT*(-0.16281+ALOGT*0.00390315)))
      DG(23,8)=EXP(-20.1873 + ALOGT*(3.95322
     1           +ALOGT*(-0.218312+ALOGT*0.00642333)))
      DG(23,9)=EXP(-19.3576 + ALOGT*(3.64391
     1           +ALOGT*(-0.172899+ALOGT*0.00431189)))
      DG(23,10)=EXP(-19.3706 + ALOGT*(4.17794
     1           +ALOGT*(-0.275277+ALOGT*0.00980842)))
      DG(23,11)=EXP(-20.4967 + ALOGT*(4.34553
     1           +ALOGT*(-0.28736+ALOGT*0.010035)))
      DG(23,12)=EXP(-19.3564 + ALOGT*(3.93886
     1           +ALOGT*(-0.229274+ALOGT*0.00730024)))
      DG(23,13)=EXP(-19.7112 + ALOGT*(4.05001
     1           +ALOGT*(-0.243062+ALOGT*0.00789953)))
      DG(23,14)=EXP(-19.8293 + ALOGT*(3.85372
     1           +ALOGT*(-0.204725+ALOGT*0.00582639)))
      DG(23,15)=EXP(-18.8349 + ALOGT*(3.86531
     1           +ALOGT*(-0.228142+ALOGT*0.00750579)))
      DG(23,16)=EXP(-20.3616 + ALOGT*(3.90116
     1           +ALOGT*(-0.210882+ALOGT*0.00605528)))
      DG(23,17)=EXP(-20.2214 + ALOGT*(3.81777
     1           +ALOGT*(-0.197751+ALOGT*0.00540836)))
      DG(23,18)=EXP(-21.3728 + ALOGT*(4.44258
     1           +ALOGT*(-0.292542+ALOGT*0.0100123)))
      DG(23,19)=EXP(-19.3451 + ALOGT*(3.25359
     1           +ALOGT*(-0.111261+ALOGT*0.00116325)))
      DG(23,20)=EXP(-20.8476 + ALOGT*(4.22701
     1           +ALOGT*(-0.25956+ALOGT*0.00840619)))
      DG(23,21)=EXP(-21.0267 + ALOGT*(4.16288
     1           +ALOGT*(-0.247818+ALOGT*0.00776077)))
      DG(23,22)=EXP(-20.3324 + ALOGT*(3.80819
     1           +ALOGT*(-0.19571+ALOGT*0.00528757)))
      DG(23,23)=EXP(-19.5347 + ALOGT*(3.31013
     1           +ALOGT*(-0.120667+ALOGT*0.00165127)))
C
      DO I=1,23
        DO J=I+1,23
          DG(I, J) = DG(J, I)
        ENDDO
      ENDDO
C
      DO I=1,23
        QG(I) = 0.D0
        DO J=1,23
          QG(I) = QG(I) + XG(J)/DG(I,J)
        ENDDO
      ENDDO
C
      D(  1) = (1.D0-Y(1))/(QG(1)-X(1)/DG(1,1))/PA
      D(  2) = (1.D0-Y(2))/(QG(2)-X(2)/DG(2,2))/PA
      D(  3) = (1.D0-Y(3))/(QG(3)-X(3)/DG(3,3))/PA
      D(  4) = (1.D0-Y(4))/(QG(4)-X(4)/DG(4,4))/PA
      D(  5) = (1.D0-Y(5))/(QG(3)-X(5)/DG(3,3))/PA
      D(  6) = (1.D0-Y(6))/(QG(5)-X(6)/DG(5,5))/PA
      D(  7) = (1.D0-Y(7))/(QG(4)-X(7)/DG(4,4))/PA
      D(  8) = (1.D0-Y(8))/(QG(4)-X(8)/DG(4,4))/PA
      D(  9) = (1.D0-Y(9))/(QG(4)-X(9)/DG(4,4))/PA
      D( 10) = (1.D0-Y(10))/(QG(6)-X(10)/DG(6,6))/PA
      D( 11) = (1.D0-Y(11))/(QG(7)-X(11)/DG(7,7))/PA
      D( 12) = (1.D0-Y(12))/(QG(8)-X(12)/DG(8,8))/PA
      D( 13) = (1.D0-Y(13))/(QG(8)-X(13)/DG(8,8))/PA
      D( 14) = (1.D0-Y(14))/(QG(9)-X(14)/DG(9,9))/PA
      D( 15) = (1.D0-Y(15))/(QG(9)-X(15)/DG(9,9))/PA
      D( 16) = (1.D0-Y(16))/(QG(9)-X(16)/DG(9,9))/PA
      D( 17) = (1.D0-Y(17))/(QG(10)-X(17)/DG(10,10))/PA
      D( 18) = (1.D0-Y(18))/(QG(10)-X(18)/DG(10,10))/PA
      D( 19) = (1.D0-Y(19))/(QG(10)-X(19)/DG(10,10))/PA
      D( 20) = (1.D0-Y(20))/(QG(11)-X(20)/DG(11,11))/PA
      D( 21) = (1.D0-Y(21))/(QG(11)-X(21)/DG(11,11))/PA
      D( 22) = (1.D0-Y(22))/(QG(12)-X(22)/DG(12,12))/PA
      D( 23) = (1.D0-Y(23))/(QG(13)-X(23)/DG(13,13))/PA
      D( 24) = (1.D0-Y(24))/(QG(13)-X(24)/DG(13,13))/PA
      D( 25) = (1.D0-Y(25))/(QG(14)-X(25)/DG(14,14))/PA
      D( 26) = (1.D0-Y(26))/(QG(14)-X(26)/DG(14,14))/PA
      D( 27) = (1.D0-Y(27))/(QG(15)-X(27)/DG(15,15))/PA
      D( 28) = (1.D0-Y(28))/(QG(20)-X(28)/DG(20,20))/PA
      D( 29) = (1.D0-Y(29))/(QG(20)-X(29)/DG(20,20))/PA
      D( 30) = (1.D0-Y(30))/(QG(20)-X(30)/DG(20,20))/PA
      D( 31) = (1.D0-Y(31))/(QG(18)-X(31)/DG(18,18))/PA
      D( 32) = (1.D0-Y(32))/(QG(8)-X(32)/DG(8,8))/PA
      D( 33) = (1.D0-Y(33))/(QG(14)-X(33)/DG(14,14))/PA
      D( 34) = (1.D0-Y(34))/(QG(14)-X(34)/DG(14,14))/PA
      D( 35) = (1.D0-Y(35))/(QG(14)-X(35)/DG(14,14))/PA
      D( 36) = (1.D0-Y(36))/(QG(14)-X(36)/DG(14,14))/PA
      D( 37) = (1.D0-Y(37))/(QG(14)-X(37)/DG(14,14))/PA
      D( 38) = (1.D0-Y(38))/(QG(16)-X(38)/DG(16,16))/PA
      D( 39) = (1.D0-Y(39))/(QG(17)-X(39)/DG(17,17))/PA
      D( 40) = (1.D0-Y(40))/(QG(17)-X(40)/DG(17,17))/PA
      D( 41) = (1.D0-Y(41))/(QG(8)-X(41)/DG(8,8))/PA
      D( 42) = (1.D0-Y(42))/(QG(18)-X(42)/DG(18,18))/PA
      D( 43) = (1.D0-Y(43))/(QG(20)-X(43)/DG(20,20))/PA
      D( 44) = (1.D0-Y(44))/(QG(20)-X(44)/DG(20,20))/PA
      D( 45) = (1.D0-Y(45))/(QG(21)-X(45)/DG(21,21))/PA
      D( 46) = (1.D0-Y(46))/(QG(21)-X(46)/DG(21,21))/PA
      D( 47) = (1.D0-Y(47))/(QG(21)-X(47)/DG(21,21))/PA
      D( 48) = (1.D0-Y(48))/(QG(21)-X(48)/DG(21,21))/PA
      D( 49) = (1.D0-Y(49))/(QG(21)-X(49)/DG(21,21))/PA
      D( 50) = (1.D0-Y(50))/(QG(19)-X(50)/DG(19,19))/PA
      D( 51) = (1.D0-Y(51))/(QG(22)-X(51)/DG(22,22))/PA
      D( 52) = (1.D0-Y(52))/(QG(21)-X(52)/DG(21,21))/PA
      D( 53) = (1.D0-Y(53))/(QG(21)-X(53)/DG(21,21))/PA
      D( 54) = (1.D0-Y(54))/(QG(21)-X(54)/DG(21,21))/PA
      D( 55) = (1.D0-Y(55))/(QG(21)-X(55)/DG(21,21))/PA
      D( 56) = (1.D0-Y(56))/(QG(21)-X(56)/DG(21,21))/PA
      D( 57) = (1.D0-Y(57))/(QG(21)-X(57)/DG(21,21))/PA
      D( 58) = (1.D0-Y(58))/(QG(21)-X(58)/DG(21,21))/PA
      D( 59) = (1.D0-Y(59))/(QG(21)-X(59)/DG(21,21))/PA
      D( 60) = (1.D0-Y(60))/(QG(21)-X(60)/DG(21,21))/PA
      D( 61) = (1.D0-Y(61))/(QG(21)-X(61)/DG(21,21))/PA
      D( 62) = (1.D0-Y(62))/(QG(21)-X(62)/DG(21,21))/PA
      D( 63) = (1.D0-Y(63))/(QG(21)-X(63)/DG(21,21))/PA
      D( 64) = (1.D0-Y(64))/(QG(21)-X(64)/DG(21,21))/PA
      D( 65) = (1.D0-Y(65))/(QG(20)-X(65)/DG(20,20))/PA
      D( 66) = (1.D0-Y(66))/(QG(21)-X(66)/DG(21,21))/PA
      D( 67) = (1.D0-Y(67))/(QG(21)-X(67)/DG(21,21))/PA
      D( 68) = (1.D0-Y(68))/(QG(21)-X(68)/DG(21,21))/PA
      D( 69) = (1.D0-Y(69))/(QG(20)-X(69)/DG(20,20))/PA
      D( 70) = (1.D0-Y(70))/(QG(22)-X(70)/DG(22,22))/PA
      D( 71) = (1.D0-Y(71))/(QG(22)-X(71)/DG(22,22))/PA
      D( 72) = (1.D0-Y(72))/(QG(22)-X(72)/DG(22,22))/PA
      D( 73) = (1.D0-Y(73))/(QG(22)-X(73)/DG(22,22))/PA
      D( 74) = (1.D0-Y(74))/(QG(23)-X(74)/DG(23,23))/PA
      D( 75) = (1.D0-Y(75))/(QG(21)-X(75)/DG(21,21))/PA
      D( 76) = (1.D0-Y(76))/(QG(21)-X(76)/DG(21,21))/PA
      D( 77) = (1.D0-Y(77))/(QG(21)-X(77)/DG(21,21))/PA
      D( 78) = (1.D0-Y(78))/(QG(21)-X(78)/DG(21,21))/PA
      D( 79) = (1.D0-Y(79))/(QG(22)-X(79)/DG(22,22))/PA
      D( 80) = (1.D0-Y(80))/(QG(19)-X(80)/DG(19,19))/PA
      D( 81) = (1.D0-Y(81))/(QG(23)-X(81)/DG(23,23))/PA
      D( 82) = (1.D0-Y(82))/(QG(23)-X(82)/DG(23,23))/PA
      D( 83) = (1.D0-Y(83))/(QG(23)-X(83)/DG(23,23))/PA
      D( 84) = (1.D0-Y(84))/(QG(23)-X(84)/DG(23,23))/PA
      D( 85) = (1.D0-Y(85))/(QG(23)-X(85)/DG(23,23))/PA
      D( 86) = (1.D0-Y(86))/(QG(23)-X(86)/DG(23,23))/PA
      D( 87) = (1.D0-Y(87))/(QG(23)-X(87)/DG(23,23))/PA
      D( 88) = (1.D0-Y(88))/(QG(23)-X(88)/DG(23,23))/PA
      D( 89) = (1.D0-Y(89))/(QG(23)-X(89)/DG(23,23))/PA
      D( 90) = (1.D0-Y(90))/(QG(23)-X(90)/DG(23,23))/PA
      D( 91) = (1.D0-Y(91))/(QG(23)-X(91)/DG(23,23))/PA
      D( 92) = (1.D0-Y(92))/(QG(23)-X(92)/DG(23,23))/PA
      D( 93) = (1.D0-Y(93))/(QG(23)-X(93)/DG(23,23))/PA
      D( 94) = (1.D0-Y(94))/(QG(23)-X(94)/DG(23,23))/PA
      D( 95) = (1.D0-Y(95))/(QG(23)-X(95)/DG(23,23))/PA
      D( 96) = (1.D0-Y(96))/(QG(23)-X(96)/DG(23,23))/PA
      D( 97) = (1.D0-Y(97))/(QG(23)-X(97)/DG(23,23))/PA
      D( 98) = (1.D0-Y(98))/(QG(23)-X(98)/DG(23,23))/PA
      D( 99) = (1.D0-Y(99))/(QG(4)-X(99)/DG(4,4))/PA
C
      RETURN
      END