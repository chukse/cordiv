# This code is aimed at finding which structural property best predicts the Evolutionary Rates.

# Last updated by Amir Shahmoradi, Friday 4:25 PM, February 13 2015, Wilke Lab, ICMB, UT Austin

setwd('C:/Users/Amir/Documents/GitHub/cordiv/analysis/src')

# excluded_pdbs = c('1BBS_A','1BS0_A','1DIN_A','1HPL_A')   # These are the 4 PDBs that did not have complete r4s evolutionary rates and are omitted from the dataset to avoid NA values.
pdb_temp = data.frame()
best_structural_predictors_of_ER = data.frame()  # This data frame will contain correlations of select structural variables with r4sJC evolutionary rates, for each pdb file on eaxch row
counter = 0

for(pdb in levels(res_prop_elj$pdb))
{
  counter = counter + 1
  cat( paste(str(counter),pdb) )
  
  pdb_elj    = res_prop_elj[res_prop_elj$pdb==pdb,] # c('seqent','ddgent')]
  pdb_jec    = res_prop_jec[res_prop_jec$pdb==pdb,] # c('zr4s_JC')]
  pdb_hps    = res_prop_hps[res_prop_hps$pdb==pdb,] # c('hpskd','hpsww','hpshh')] )
  pdb_dssp   = res_prop_dssp[res_prop_dssp$pdb==pdb,] # c('asa','rsa','hbe','rss')] )
  pdb_wcn_bf = res_prop_wcn_bf[res_prop_wcn_bf$pdb==pdb, ]
  pdb_voroSC = res_prop_voroSC[res_prop_voroSC$pdb==pdb, ]
  pdb_voroCA = res_prop_voroCA[res_prop_voroCA$pdb==pdb, ]
  
  pdb_temp = cbind( subset(pdb_elj, select = c(pdb,seqent,ddgent))
                  , subset(pdb_jec, select = c(zr4s_JC))
                  , subset(pdb_hps, select = c(hpshh))
                  , subset(pdb_dssp, select = c(rsa,hbe))
                  , subset(pdb_wcn_bf, select = c(wcnSC,wcnCA,bfSC))
                  , subset(pdb_voroSC, select = c(VSCarea))
                  , subset(pdb_voroCA, select = c(VCAarea))
                  )
  r.rsa.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$rsa,method='sp')
  r.wcnSC.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$wcnSC,method='sp')
  r.wcnCA.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$wcnCA,method='sp')
  r.vareaSC.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$VSCarea,method='sp')
  r.ddgent.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$ddgent,method='sp')
  r.vareaCA.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$VCAarea,method='sp')
  r.bfSC.r4sJC = cor(pdb_temp$zr4s_JC,pdb_temp$bfSC,method='sp')
  r.hbe.r4sJC = cor(pdb_temp$zr4s_JC,abs(pdb_temp$hbe),method='sp')
  
  #row = data.frame( pdb = pdb, rsa = r.rsa.r4sJC, wcn = r.wcn.r4sJC, vareaSC = r.vareaSC.r4sJC, ddgent = r.ddgent.r4sJC )
  row = data.frame( pdb, r.wcnCA.r4sJC, r.wcnSC.r4sJC, r.rsa.r4sJC, r.vareaSC.r4sJC, r.ddgent.r4sJC , r.vareaCA.r4sJC , r.bfSC.r4sJC , r.hbe.r4sJC )
  best_structural_predictors_of_ER = rbind( best_structural_predictors_of_ER, row )
}

write.csv(best_structural_predictors_of_ER, file = "../tables/best_structural_predictors_of_ER.csv", row.names=F )

# NOW GENERATE CORRELATIONS HISTOGRAM DATA:
hist.rsa = density(best_structural_predictors_of_ER$r.rsa.r4sJC)
hist.wcnSC = density(best_structural_predictors_of_ER$r.wcnSC.r4sJC)
hist.wcnCA = density(best_structural_predictors_of_ER$r.wcnCA.r4sJC)
hist.vareaSC = density(best_structural_predictors_of_ER$r.vareaSC.r4sJC)
hist.ddgent = density(best_structural_predictors_of_ER$r.ddgent.r4sJC)
hist.bfSC = density(best_structural_predictors_of_ER$r.bfSC.r4sJC)
hist.hbe = density(best_structural_predictors_of_ER$r.hbe.r4sJC)

# Now plot histograms in a single plot
#colors = c('green', 'blue', 'red', 'black', 'gray', 'cyan2')
pdf( "../figures/best_structural_predictors_of_ER.pdf", width=4.5, height=4, useDingbats=FALSE )
par( mai=c(0.65, 0.65, 0.05, 0.05), mgp=c(2, 0.5, 0), tck=-0.03 )
plot(  hist.rsa$x
    ,  hist.rsa$y
    ,   col = 'blue'
<<<<<<< HEAD
    ,   xlim = c(-0.5,0.85)
=======
    ,   xlim = c(0.0,0.85)
>>>>>>> 519de7a0894a0bf5b518c93b746a5aed87117401
    ,   ylim = c(0,5.5)
    #,   col=colors[1]
    #,   ylim=c(0,7)
    #,   border = colors[1]
    #,   lty = 0
    ,   type = 'l'
    ,   lwd  = 2 
    #,   main = 'Correlations with Evolutionary Rates'
    #,   xlab = expression(paste('Absolute Spearman Cor. with Evolutionary Rates ',rho))
    ,   xlab = 'Absolute Spearman Cor. with Evolutionary Rates'
    ,   ylab = 'frequency'
    )
lines( hist.ddgent$x
     , hist.ddgent$y
     , col = 'green'
     , lwd  = 2
     )
lines( hist.vareaSC$x
     , hist.vareaSC$y
     , col = 'red'
     , lwd  = 2
     )
lines( abs(hist.wcnSC$x)
     , abs(hist.wcnSC$y)
     , col = 'black'
     , lwd = 2
     )
lines( abs(hist.wcnCA$x)
     , abs(hist.wcnCA$y)
     , col = 'black'
     , lwd = 2
     , lty = 2
     )
lines( hist.bfSC$x
     , hist.bfSC$y
     , col = 'cyan2'
     , lwd = 2
     )
<<<<<<< HEAD
lines( -hist.hbe$x
     , hist.hbe$y
     , col = 'grey'
     , lwd = 2
     )

legend( 'topleft'
      , c("Voronoi Cell Area","H-bond strength", "WCN (SC)", "WCN (CA)", "ddG Rate", "Bfactor", "RSA")
      , col = c('red','grey','black','black','green','cyan2','blue')
=======
#lines( -hist.hbe$x
#     , hist.hbe$y
#     , col = 'grey'
#     , lwd = 2
#     )

legend( 'topleft'
      #, c("Voronoi Cell Area","H-bond strength", "WCN (SC)", "WCN (CA)", "ddG Rate", "Bfactor", "RSA")
      , c("Voronoi Cell Area","WCN (SC)", "WCN (CA)", "ddG Rate", "Bfactor", "RSA")
      , col = c('red','black','black','green','cyan2','blue')
>>>>>>> 519de7a0894a0bf5b518c93b746a5aed87117401
      , lty = c(1,1,2,1,1)
      , lwd = 2
      , bty = 'n'
      , cex = 0.9
      )

graphics.off()
