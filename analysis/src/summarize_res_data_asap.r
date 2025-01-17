# This R function takes in the residue properties of all ASAP proteins from DSSP, and PDB files and and combines them into a single dataframe for further analysis at pdb level.

# input files:  
#               ../../elj_pdb_entropies.in
#               ../../properties/res_prop_HPS_asap.out
#               ../../properties/res_prop_dssp_asap.out
#               ../../properties/res_prop_wcn_bf_asap.out

# Last updated by Amir Shahmoradi, Thursday 3:40 PM, Aug 28 2014, Wilke Lab, ICMB, UT Austin

#install.packages("reshape2")
#library("reshape2")
#library('corrplot')

setwd('C:/Users/Amir/Documents/GitHub/cordiv/analysis/src')

#res_prop_elj            = read.table('../../elj_pdb_entropies.in', header=T)
#res_prop_elj$pdb        = factor(res_prop_elj$pdb)
                         
#res_prop_jec            = read.csv('../../jec_pdb_r4s.csv', header=T)
#res_prop_jec$pdb        = factor(res_prop_jec$pdb)
                         
res_prop_hps_asap        = read.table('../../properties/res_prop_hps_asap.out', header=T)
res_prop_hps_asap$pdb    = factor(res_prop_hps_asap$pdb)
                         
res_prop_dssp_asap       = read.table('../../properties/res_prop_dssp_asap.out', header=T)
res_prop_dssp_asap$pdb   = factor(res_prop_dssp_asap$pdb)

res_prop_wcn_bf_asap     = read.table('../../properties/res_prop_wcn_bf_asap.out', header=T)
res_prop_wcn_bf_asap$pdb = factor(res_prop_wcn_bf_asap$pdb)

res_prop_voroSC_asap     = read.table('../../properties/res_prop_voronoiSC_asap.out', header=T)
res_prop_voroSC_asap$pdb = factor(res_prop_voroSC_asap$pdb)
res_prop_voroSC_asap     = cbind(res_prop_voroSC_asap, VSCmodified_volume = res_prop_voroSC_asap$VSCvolume)
maxval = max(res_prop_voroSC_asap$VSCvolume)
res_prop_voroSC_asap$VSCmodified_volume[res_prop_voroSC_asap$VSCvolume_change_ratio != 0] = maxval
res_prop_voroSC_asap$VSCmodified_volume = res_prop_voroSC_asap$VSCmodified_volume * res_prop_voroSC_asap$VSCvolume_change_ratio

nonviral_pdbs = c('1AJ8_A','1AOR_A','1CTS_A','1MP9_A','3GSZ_A','3I5K_A')   # These are thermophilic proteins, in addition to the 2 viral PDBs that are from the same family as 3GOL_A and therefore redundant.
pdb_prop_from_residue_prop_asap = data.frame()    # This dataframe will contain the mean median and variance of sequqence entropy and ddG entropy for each pdb file.
counter = 0

for(pdb in levels(res_prop_dssp_asap$pdb))
{
  if (!(pdb %in% nonviral_pdbs))
  {
    counter = counter + 1
    cat( paste(str(counter),pdb) )
    
    #pdb_elj    = res_prop_elj[res_prop_elj$pdb==pdb,] # c('seqent','ddgent')]
    #pdb_jec    = res_prop_jec[res_prop_jec$pdb==pdb,] # c('zr4s_JC')]
    pdb_hps    = res_prop_hps_asap[res_prop_hps_asap$pdb==pdb,] # c('hpskd','hpsww','hpshh')] )
    pdb_dssp   = res_prop_dssp_asap[res_prop_dssp_asap$pdb==pdb,] # c('asa','rsa','hbe','rss')] )
    pdb_wcn_bf = res_prop_wcn_bf_asap[res_prop_wcn_bf_asap$pdb==pdb, ] #c('asa','rsa','hbe','rss')] )
    
    pdb_temp = cbind( #subset(pdb_elj, select = c(seqent,ddgent))
                    #, subset(pdb_jec, select = c(zr4s_JC))
                      subset(pdb_hps, select = c(hpskd,hpsww,hpshh))
                    , subset(pdb_dssp, select = c(asa,rsa,hbe))
                    , subset(pdb_wcn_bf, select = -c(pdb,resnam,resnum))
                    )
    
    pdb_long = reshape(pdb_temp, ids = rownames(pdb_temp), varying = colnames(pdb_temp), v.names = 'value', timevar = 'variable', times = colnames(pdb_temp), direction = 'long')
    pdb_long$variable = factor(pdb_long$variable)
    
    counter1 = 0
    
    for (variable1 in levels(pdb_long$variable))
    {
      counter1 = counter1 + 1
      #cat (variable1, '\n')
      var1 = pdb_long[pdb_long$variable == variable1,]
      
      # Claculate potentially important statistical moments of the factored variable:
      row = data.frame(pdb, variable = paste0('sum.',variable1), value = sum(var1$value))       ; pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,row)
      row = data.frame(pdb, variable = paste0('mean.',variable1), value = mean(var1$value))     ; pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,row)
      row = data.frame(pdb, variable = paste0('median.',variable1), value = median(var1$value)) ; pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,row)
      row = data.frame(pdb, variable = paste0('sd.',variable1), value = sd(var1$value))         ; pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,row)
      
      # Now calculate the Spearman correlations between pairs of variables:
      counter2 = 0
      for (variable2 in levels(pdb_long$variable))
      {
        counter2 = counter2 + 1
        if ( variable1 != variable2 & counter1 < counter2)
        {
          var2 = pdb_long[pdb_long$variable == variable2,]
          x = cor.test( var1$value, var2$value, method='spearman', na.action="na.omit" )
          r = x$estimate
          p = x$p.value
          
          row = data.frame(pdb, variable = paste0('r.',variable1,'.',variable2), value = r)
          pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,row)
        }
      }
    }
  }
}


# Now get Secondary Structure residue data:
pdb_prop_ss = data.frame()    # This dataframe will contain the mean median and variance of sequqence entropy and ddG entropy for each pdb file.
counter = 0

for(pdb in levels(res_prop_dssp_asap$pdb))
{
  counter = counter + 1
  cat( paste(str(counter),pdb) )
  
  pdb_dssp   = res_prop_dssp_asap[res_prop_dssp_asap$pdb==pdb,] # c('asa','rsa','hbe','rss')] )

  sum.GSS    = length(which(pdb_dssp$rss == 'G'))
  sum.HSS    = length(which(pdb_dssp$rss == 'H'))
  sum.ISS    = length(which(pdb_dssp$rss == 'I'))
  sum.TSS    = length(which(pdb_dssp$rss == 'T'))
  sum.ESS    = length(which(pdb_dssp$rss == 'E'))
  sum.BSS    = length(which(pdb_dssp$rss == 'B'))
  sum.SSS    = length(which(pdb_dssp$rss == 'S'))
  sum.LSS    = length(which(pdb_dssp$rss == 'L'))
             + length(which(pdb_dssp$rss == 'C'))
             + length(which(pdb_dssp$rss == '_'))
  sum.helix  = sum.GSS + sum.HSS + sum.ISS
  sum.betas  = sum.ESS + sum.BSS
  sum.hbdif  = sum.helix + sum.betas

  pdb.nres   = length(pdb_dssp$pdb)
  
  mean.GSS   = sum.GSS/pdb.nres
  mean.HSS   = sum.HSS/pdb.nres
  mean.ISS   = sum.ISS/pdb.nres
  mean.TSS   = sum.TSS/pdb.nres
  mean.ESS   = sum.ESS/pdb.nres
  mean.BSS   = sum.BSS/pdb.nres
  mean.SSS   = sum.SSS/pdb.nres
  mean.LSS   = sum.LSS/pdb.nres
  mean.helix = sum.helix/pdb.nres
  mean.betas = sum.betas/pdb.nres
  mean.hbdif = sum.hbdif/pdb.nres

  row = data.frame(pdb, variable = 'sum.GSS'   , value = sum.GSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.HSS'   , value = sum.HSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.ISS'   , value = sum.ISS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.TSS'   , value = sum.TSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.ESS'   , value = sum.ESS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.BSS'   , value = sum.BSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.SSS'   , value = sum.SSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.LSS'   , value = sum.LSS   ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.helix' , value = sum.helix ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.betas' , value = sum.betas ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'sum.hbdif' , value = sum.hbdif ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.GSS'  , value = mean.GSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.HSS'  , value = mean.HSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.ISS'  , value = mean.ISS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.TSS'  , value = mean.TSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.ESS'  , value = mean.ESS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.BSS'  , value = mean.BSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.SSS'  , value = mean.SSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.LSS'  , value = mean.LSS  ) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.helix', value = mean.helix) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.betas', value = mean.betas) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  row = data.frame(pdb, variable = 'mean.hbdif', value = mean.hbdif) ; pdb_prop_ss = rbind(pdb_prop_ss,row)
  
}

pdb_prop_from_residue_prop_asap = rbind(pdb_prop_from_residue_prop_asap,pdb_prop_ss)

write.csv( pdb_prop_from_residue_prop_asap, "../tables/pdb_prop_from_residue_prop_asap.csv", row.names=F )





###  row.names(pdb_prop_scor)  = c()
###  row.names(pdb_prop_scorp) = c()
###  row.names(pdb_prop_elj) = c()
###  
###  write.csv( pdb_prop_scor, "../tables/pdb_prop_scor.csv", row.names=F )
###  write.csv( pdb_prop_scorp, "../tables/pdb_prop_scorp.csv", row.names=F )
###  
###  all_pdb_prop = cbind(pdb_prop_dssp,subset(pdb_prop_scor, select = -c(pdb)),subset(pdb_prop_elj, select = -c(pdb)))
###  
###  all_pdb_prop_subset = subset(all_pdb_prop, select = -c(name,nssb))
###  cormat = cor(all_pdb_prop_subset, method = 'spearman')
###  #corrplot.mixed(cormat)
###  corrplot(cormat, method='circle')
###  
###  # Now do some statistics on the calculated correlations. First melt the correlation data.frame to make a long format data set.
###  pdb_prop_scor           = melt(pdb_prop_scor)
###  pdb_prop_scor$variable  = factor(pdb_prop_scor$variable)
###  
###  scor_stat = data.frame()
###  
###  for (variable in levels(pdb_prop_scor$variable))
###  {
###    temp = pdb_prop_scor[pdb_prop_scor$variable==variable,]
###    mean.scor   = mean(temp$value)
###    median.scor = median(temp$value)
###    sd.scor     = sd(temp$value)
###    
###    row = data.frame(variable = variable,
###                     mean     = mean.scor,
###                     median   = median.scor,
###                     sd       = sd.scor
###                     )
###    scor_stat = rbind(scor_stat,row)
###  }
###  
###  row.names(scor_stat) = c()
###  write.csv( scor_stat, "../tables/scor_stat.csv", row.names=F )
###  